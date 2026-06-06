# Tools Cache Mount (ci-tools-cache-mounts) — CI marketplace container.
# This repo is an NFS/cache-mount helper with no web UI; this image serves a
# minimal status page so the app is installable + health-checkable in the Hub.
# Published as ghcr.io/companionintelligence/ci-tools-cache-mounts.
FROM nginx:1.27-alpine
COPY status/index.html /usr/share/nginx/html/index.html
EXPOSE 80
