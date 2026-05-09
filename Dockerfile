FROM tianon/gosu:1.19-trixie AS gosu_source
FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tini \
    git \
    openssh-client \
    ripgrep \
    procps && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 --from=gosu_source /gosu /usr/local/bin/

RUN useradd -u 10000 -m -d /opt/data hermes
RUN mkdir -p /workspace && chmod 1777 /workspace

WORKDIR /opt/hermes

RUN git clone --depth 1 --branch v2026.5.7 https://github.com/NousResearch/hermes-agent.git . && \
    rm -rf .git

RUN pip install --no-cache-dir uv==0.11.6
RUN uv venv && uv pip install --no-cache-dir -e ".[messaging,cron,cli,pty,honcho,mcp,acp]"

RUN chmod -R a+rX /opt/hermes

ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
VOLUME [ "/opt/data" ]
WORKDIR /workspace
ENTRYPOINT [ "/usr/bin/tini", "-g", "--", "/opt/hermes/docker/entrypoint.sh" ]
