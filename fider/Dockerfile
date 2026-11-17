# Fider, official image, pinned by version and digest.
# Bump both the tag and the digest together, and add a CHANGELOG.md entry.
FROM getfider/fider:v0.40.0@sha256:9b4a043595ad96e3064f8091d2734dbc4f0113fe0e1a908a778e9c4fa96971f7

COPY --chmod=0755 start.sh /app/start.sh

# Fider listens on PORT (3000 by default) and serves /_health without login.
EXPOSE 3000
CMD ["/app/start.sh"]
