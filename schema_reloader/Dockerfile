FROM python:3.13-alpine

RUN apk upgrade --update --no-interactive

COPY requirements/runtime.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY \
  --chown=0:0 \
  --chmod=644 \
  reload_schema.py \
  /opt/reload_schema.py

CMD ["python", "/opt/reload_schema.py"]
