import datetime

import pytest

import reload_schema


@pytest.mark.usefixtures("mocks")
def test_reload_not_needed_due_to_no_tiamat_running(
    caplog,
    core_v1_api_mock,
):
    core_v1_api_mock.list_namespaced_pod.return_value.items = []

    reload_schema.main()

    assert "No Tiamat pods found" in caplog.text


@pytest.mark.usefixtures("mocks")
def test_reload_not_needed_due_to_tiamat_not_restarted(
    caplog,
    post_http_request_mock,
):
    reload_schema.main()

    assert "Hasura schema reload not needed; Tiamat has not restarted within threshold period of" in caplog.text

    assert not post_http_request_mock.called


@pytest.mark.usefixtures("mocks")
def test_reload_not_needed_due_to_old_tiamat_not_terminated(
    caplog,
    core_v1_api_mock,
    now_mock,
    create_pod_data_mock,
):
    core_v1_api_mock.list_namespaced_pod.return_value.items = [
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=100),
        ),
            # This one is older than the threshold
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=101),
        ),
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=5),
        ),
    ]

    reload_schema.main()

    assert "Hasura schema reload not needed; Tiamat has not restarted within threshold period of" in caplog.text


@pytest.mark.usefixtures("mocks")
def test_reload(
    caplog,
    core_v1_api_mock,
    now_mock,
    create_pod_data_mock,
    post_http_request_mock,
):
    core_v1_api_mock.list_namespaced_pod.return_value.items = [
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=100),
        ),
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=5),
        ),
    ]

    reload_schema.main()

    post_http_request_mock.assert_called_once_with(
        "http://hasura.local/v1/metadata",
        headers={
            "User-Agent": "hasura-schema-reloader",
            "Content-Type": "application/json",
            "x-hasura-admin-secret": "hasura-admin-secret",
        },
        data="""{
            "type": "reload_metadata",
            "args": {
                "reload_remote_schemas": true,
                "reload_sources": true
            }
        }""",
    )

    post_http_request_mock.return_value.raise_for_status.assert_called_once_with()

    assert "Hasura remote schemas reloaded" in caplog.text


@pytest.mark.usefixtures("mocks")
def test_fail_reading_pods_from_k8s(
    caplog,
    core_v1_api_mock,
):
    core_v1_api_mock.list_namespaced_pod.side_effect = Exception("Test Failure")

    with pytest.raises(SystemExit) as exc_info:
        reload_schema.main()

    assert exc_info.value.args[0] == 1

    assert "Failed to read Tiamat pods" in caplog.text


@pytest.mark.usefixtures("mocks")
def test_fail_to_reload_hasura_remote_schemas(
    caplog,
    core_v1_api_mock,
    now_mock,
    create_pod_data_mock,
    post_http_request_mock,
):
    core_v1_api_mock.list_namespaced_pod.return_value.items = [
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=100),
        ),
    ]

    post_http_request_mock.return_value.raise_for_status.side_effect = Exception("Hasura API Error")

    with pytest.raises(SystemExit) as exc_info:
        reload_schema.main()

    assert exc_info.value.args[0] == 1

    post_http_request_mock.assert_called_once_with(
        "http://hasura.local/v1/metadata",
        headers={
            "User-Agent": "hasura-schema-reloader",
            "Content-Type": "application/json",
            "x-hasura-admin-secret": "hasura-admin-secret",
        },
        data="""{
            "type": "reload_metadata",
            "args": {
                "reload_remote_schemas": true,
                "reload_sources": true
            }
        }""",
    )

    post_http_request_mock.return_value.raise_for_status.assert_called_once_with()

    assert "Failed to reload Hasura remote schemas" in caplog.text


def test_get_current_datetime():
    current_datetime = reload_schema.get_current_datetime()

    assert isinstance(current_datetime, datetime.datetime)


@pytest.fixture
def mocks(
    mocker,
    env_mock,
    azure_default_credential_mock,
    api_client_class_mock,
    core_v1_api_class_mock,
    hasura_admin_secret_mock,
    post_http_request_mock,
):
    result = mocker.Mock(name="mocks")

    result.env_mock = env_mock
    result.azure_default_credential_mock = azure_default_credential_mock
    result.api_client_class_mock = api_client_class_mock
    result.core_v1_api_class_mock = core_v1_api_class_mock
    result.hasura_admin_secret_mock = hasura_admin_secret_mock
    result.post_http_request_mock = post_http_request_mock

    return result


@pytest.fixture
def env_mock(mocker):
    mock_environ = mocker.patch("os.environ", {})

    mock_environ["K8S_NAMESPACE"] = "kube-namespace"
    mock_environ["TIAMAT_UPTIME_THRESHOLD"] = "100"
    mock_environ["KUBERNETES_SERVICE_HOST"] = "k8s-cluster.local"
    mock_environ["KUBERNETES_SERVICE_PORT"] = "1234"
    mock_environ["K8S_TIAMAT_DEPLOYMENT_NAME"] = "tiamat-deployment"
    mock_environ["HASURA_ADMIN_SECRET_FILE_PATH"] = "/path/to/hasura/admin/secret"
    mock_environ["HASURA_BASE_URL"] = "http://hasura.local"

    return mock_environ


@pytest.fixture
def azure_default_credential_mock(mocker):
    credential_mock = mocker.patch("azure.identity.DefaultAzureCredential")
    credential_mock.return_value.return_value = mocker.sentinel.azure_default_credential_token

    return credential_mock


@pytest.fixture
def api_client_class_mock(mocker):
    api_client_class_mock = mocker.patch("kubernetes.client.ApiClient")

    api_client_class_mock.__enter__.return_value = mocker.Mock(name="K8sApiClient")

    return api_client_class_mock


@pytest.fixture
def core_v1_api_class_mock(
    mocker,
    create_pod_data_mock,
    now_mock,
):
    core_v1_api_class_mock = mocker.patch("kubernetes.client.CoreV1Api")

    core_v1_api_class_mock.return_value = mocker.Mock(name="CoreV1Api")

    core_v1_api_class_mock.return_value.list_namespaced_pod.return_value = mocker.Mock()
    core_v1_api_class_mock.return_value.list_namespaced_pod.return_value.items = [
        create_pod_data_mock(
            creation_timestamp=now_mock.return_value - datetime.timedelta(seconds=60 * 60),
        ),
    ]


    return core_v1_api_class_mock


@pytest.fixture
def core_v1_api_mock(core_v1_api_class_mock):
    return core_v1_api_class_mock.return_value


@pytest.fixture
def create_pod_data_mock(
    mocker,
    now_mock,
):
    def impl(*, creation_timestamp):
      mock = mocker.Mock("PodData")
      mock.metadata = mocker.Mock()
      mock.metadata.creation_timestamp = creation_timestamp

      return mock

    return impl



@pytest.fixture
def hasura_admin_secret_mock(mocker):
    open_mock = mocker.mock_open(read_data="hasura-admin-secret\n")

    mocker.patch("builtins.open", open_mock)

    return open_mock


@pytest.fixture
def now_mock(mocker):
    now_mock = mocker.patch(
        "reload_schema.get_current_datetime",
        return_value=datetime.datetime(2025, 9, 22, 6, 0, 0, tzinfo=datetime.timezone.utc),

    )

    return now_mock


@pytest.fixture
def post_http_request_mock(mocker):
    request_mock = mocker.patch("requests.post")

    return request_mock
