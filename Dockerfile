ARG UID=1001
ARG GID=1001

FROM node:22-bookworm-slim as base

# build stage
FROM base AS deps

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

FROM base AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY . .

RUN sed -i "s/images:/output: 'standalone',images:/" next.config.ts

RUN npm run build

# run stage
FROM base AS runner

ARG UID
ARG GID

ENV NODE_ENV production
ENV HOSTNAME=

RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    supervisor curl jq jc borgbackup/bookworm-backports openssh-server rsyslog && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} borgwarehouse && useradd -m -u ${UID} -g ${GID} borgwarehouse

RUN cp /etc/ssh/moduli /home/borgwarehouse/

WORKDIR /home/borgwarehouse/app

COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/docker/docker-bw-init.sh /app/LICENSE ./
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/helpers/shells ./helpers/shells
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/.next/standalone ./
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/public ./public
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/.next/static ./.next/static
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/docker/supervisord.conf ./
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/docker/rsyslog.conf /etc/rsyslog.conf
COPY --from=builder --chown=borgwarehouse:borgwarehouse /app/docker/sshd_config ./

FROM base AS supercronic
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

WORKDIR /cron

COPY crontab ./

RUN supercronic crontab

USER borgwarehouse

EXPOSE 3000 3022

ENTRYPOINT ["./docker-bw-init.sh"]
