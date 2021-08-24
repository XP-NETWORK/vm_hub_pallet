FROM rust:1-buster as build-subs

WORKDIR /usr

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y git clang libclang-dev
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly

WORKDIR /usr/vm_hub_pallet
COPY . .
RUN cargo build --release

FROM debian:buster as runner

WORKDIR /usr/app

COPY --from=build-subs /usr/vm_hub_pallet/target/release/node-template /usr/app
EXPOSE 9944
CMD ["./node-template", "--dev"]
