FROM debian:trixie-20250929-slim

ARG USERNAME=ephemeral
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CHEZMOI_NAME="Default Name"
ARG CHEZMOI_EMAIL="default@email.com"

ENV TZ=Europe/Helsinki
ENV CHEZMOI_NAME=${CHEZMOI_NAME}
ENV CHEZMOI_EMAIL=${CHEZMOI_EMAIL}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    bats \
    kcov \
    sudo \
    ssh \
    tzdata \
    parallel \
    build-essential \
    ca-certificates


RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -G sudo -s /bin/bash \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME/.local/share/chezmoi

RUN (cd ~/.local && sh -c "$(curl -fsLS get.chezmoi.io)")

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

COPY --chown=$USER_UID:$USER_GID . .

RUN chezmoi init
