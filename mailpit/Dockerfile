# Mailpit, official image, pinned by version and digest.
# It is Fider's built-in outbox: Fider signs people in with emailed links,
# so the first administrator's activation email lands here until you set up real SMTP.
FROM axllent/mailpit:v1.34.0@sha256:23a2ef85bc50853ab3093645d1d64679afd8887e89da5e48a88940c172591a4e

# Web UI on PORT (8025), SMTP on 1025 (private network only), messages on the /data volume.
ENV MP_DATABASE=/data/mailpit.db \
    MP_SMTP_BIND_ADDR="[::]:1025" \
    MP_MAX_MESSAGES=1000

EXPOSE 8025 1025
ENTRYPOINT ["/bin/sh", "-c", "mkdir -p \"$(dirname \"$MP_DATABASE\")\" && exec /mailpit --listen \"[::]:${PORT:-8025}\""]
