import datetime
import logging
import os
import sys

import azure.identity
import kubernetes.client
import requests


_log = logging.getLogger(__name__)

def main():
    handler = logging.StreamHandler(sys.stderr)
    handler.setFormatter(logging.Formatter(fmt="%(levelname)s %(message)s"))
    _log.addHandler(handler)
    _log.setLevel(logging.INFO)

    try:
        oldest_tiamat_pod = get_oldest_tiamat_pod_info(os.environ["K8S_NAMESPACE"])

    except Exception:
        _log.exception("Failed to read Tiamat pods")
        sys.exit(1)

    if not oldest_tiamat_pod:
        _log.warning("No Tiamat pods found")
        return

    oldest_tiamat_pod_uptime = get_current_datetime(datetime.timezone.utc) - oldest_tiamat_pod.metadata.creation_timestamp

    tiamat_uptime_threshold = datetime.timedelta(
        seconds=int(os.environ["TIAMAT_UPTIME_THRESHOLD"]),
    )

    if oldest_tiamat_pod_uptime > tiamat_uptime_threshold:
        _log.info(
            "Hasura schema reload not needed; Tiamat has not restarted within threshold period of %s",
            tiamat_uptime_threshold,
        )
        return

    try:
        reload_hasura_remote_schemas()
        _log.info("Hasura remote schemas reloaded")

    except Exception:
        _log.exception("Failed to reload Hasura remote schemas")
        sys.exit(1)


def get_oldest_tiamat_pod_info(
    namespace,
):
    credential = azure.identity.DefaultAzureCredential()
    # The UUID here identifies the AKS Microsoft Entra client application used by kubelogin to perform public client
    # authentication on beforalf of the user, i.e. this value is used in all AKS instances when you want to
    # authenticate with Azure identities.
    # See https://learn.microsoft.com/en-us/azure/aks/kubelogin-authentication#how-to-use-kubelogin-with-aks
    token = credential.get_token("6dae42f8-4368-4678-94ff-3960e28e3630/.default").token

    configuration = kubernetes.client.Configuration()
    configuration.host = f"""https://{os.environ["KUBERNETES_SERVICE_HOST"]}:{os.environ["KUBERNETES_SERVICE_PORT"]}"""
    configuration.api_key["authorization"] = f"Bearer {token}"
    configuration.ssl_ca_cert = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

    with kubernetes.client.ApiClient(configuration) as api_client:
        core_v1_api = kubernetes.client.CoreV1Api(api_client)

        pods = core_v1_api.list_namespaced_pod(
            namespace=namespace,
            label_selector=f"""app={os.environ["K8S_TIAMAT_DEPLOYMENT_NAME"]}""",
        )

    if not pods.items:
        return None

    return min(
        pods.items,
        key=lambda pod: pod.metadata.creation_timestamp,
    )


def reload_hasura_remote_schemas():
    with open(os.environ["HASURA_ADMIN_SECRET_FILE_PATH"], 'rt') as secret_file:
        hasura_admin_secret = secret_file.read().strip()

    response = requests.post(
        f"""{os.environ["HASURA_BASE_URL"]}/v1/metadata""",
        headers={
            "Content-Type": "application/json",
            "x-hasura-admin-secret": hasura_admin_secret,
        },
        data="""{
            "type": "reload_metadata",
            "args": {
                "reload_remote_schemas": true,
                "reload_sources": true
            }
        }""",
    )

    response.raise_for_status()


# Allow patching calls to now; you can not patch datetime.datetime.now
def get_current_datetime(*args, **kwargs):
  return datetime.datetime.now(*args, **kwargs)



if __name__ == "__main__":
    main()
