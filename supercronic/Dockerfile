FROM debian:12.10-slim

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
    SUPERCRONIC=supercronic-linux-amd64

# Update all packages and install curl 
RUN apt-get update && apt-get install -y \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Refer to https://github.com/aptible/supercronic/releases 
RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Change working directory to crontab
WORKDIR /crontab

# Copy run.sh to the directory
COPY run.sh ./run.sh

# Change the run.sh previleage to excutable
RUN chmod +x ./run.sh

# Copy crontab_default file to the directory
COPY crontab_default ./crontab_default

# Change the crontab_default previleage to excutable
RUN chmod +x ./crontab_default

ENTRYPOINT [ "./run.sh" ]
