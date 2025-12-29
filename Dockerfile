FROM python:3.14.2-slim

LABEL org.opencontainers.image.source="https://github.com/ayresfonseca/ansible-runner"
LABEL org.opencontainers.image.description="Ansible Runner"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app

COPY pyproject.toml ./
COPY poetry.lock ./
COPY collections ./collections/

RUN  apt-get update && apt-get upgrade -y && apt-get install -y build-essential mariadb-client rsync && \
        rm -rf /var/lib/apt/lists/*
RUN  pip install --no-cache-dir "poetry==2.2.1" && \
        poetry config virtualenvs.create false && \
        poetry install --no-root --without dev

RUN ansible-galaxy collection install -r collections/requirements.yml
