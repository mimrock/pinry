FROM python:3.12-slim-bookworm

ARG POETRY_VERSION=2.4.1
ARG PNPM_VERSION=10.34.5

ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY . /app

# config nodejs
RUN apt-get update \
    && apt-get install --yes --no-install-recommends curl xz-utils \
    && rm -rf /var/lib/apt/lists/*
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n 18
RUN npm -g install "pnpm@${PNPM_VERSION}"

WORKDIR /app
RUN python -m pip install --no-cache-dir "poetry==${POETRY_VERSION}"
RUN poetry install
RUN rm -fr /app/*
