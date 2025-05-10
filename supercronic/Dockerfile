FROM debian:12.10-slim

ARG CRONTAB="${CRONTAB_PATH}"

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
    SUPERCRONIC=supercronic-linux-amd64

RUN apt-get update && apt-get install -y \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

WORKDIR /crontab

# RUN if [[ -z "${CRONTAB_PATH}" ]] ; then {echo copy default crontab ; cp crontab ./crontab ; ${CRONTAB}=./crontab} fi
COPY run.sh ./run.sh
COPY crontab_default ./crontab_default
RUN /bin/bash -c ./run.sh
CMD supercronic ${CRONTAB}
# COPY crontab ./crontab

# CMD supercronic crontab
