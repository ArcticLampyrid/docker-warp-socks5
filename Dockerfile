FROM alpine:3.19

RUN apk add --no-cache curl \
  && ARCH=$(uname -m) \
  && if [ "${ARCH}" = "i386" ]; then ARCH="386"; fi \
  && if [ "${ARCH}" = "i686" ]; then ARCH="386"; fi \
  && if [ "${ARCH}" = "x86_64" ]; then ARCH="amd64"; fi \
  && if [ "${ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
  && WGCF_URL=$(curl -fsSL https://api.github.com/repos/ViRb3/wgcf/releases/latest | grep 'browser_download_url' | cut -d'"' -f4 | grep "_linux_${ARCH}") \
  && curl -fsSL "${WGCF_URL}" -o ./wgcf \
  && chmod +x ./wgcf \
  && mv ./wgcf /usr/bin \
  && WIREPROXY_URL=$(curl -fsSL https://api.github.com/repos/pufferffish/wireproxy/releases/latest | grep 'browser_download_url' | cut -d'"' -f4 | grep "wireproxy_linux_${ARCH}.tar.gz") \
  && curl -fsSL "${WIREPROXY_URL}" -o ./wireproxy.tar.gz \
  && tar -xzf wireproxy.tar.gz \
  && rm wireproxy.tar.gz \
  && chmod +x ./wireproxy \
  && mv ./wireproxy /usr/bin

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ADD warp-health-check.sh /usr/local/bin/warp-health-check.sh
EXPOSE 40000/tcp
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/usr/local/bin/warp-health-check.sh" ]
