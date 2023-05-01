FROM rust:latest AS builder
RUN apt update && apt install -y git
RUN update-ca-certificates
WORKDIR /tcp-relay-rust
RUN git clone https://github.com/cedric05/tcp-relay-rust . --no-checkout && git checkout 6de9bd191fa97aa73e8696ebefd5a50286eb2b25
RUN cargo build --release

FROM debian:bullseye-slim
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=builder /tcp-relay-rust/target/release/tcp-relay-rust /tcp-relay-rust

RUN apt update \
  && apt install -y curl gnupg \
  && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bullseye main" | tee /etc/apt/sources.list.d/cloudflare-client.list \
  && apt update \
  && apt install -y cloudflare-warp \
  && apt remove -y curl \
  && apt autoremove -y \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*
  
ADD entrypoint.sh /entrypoint.sh
EXPOSE 40000/tcp
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]