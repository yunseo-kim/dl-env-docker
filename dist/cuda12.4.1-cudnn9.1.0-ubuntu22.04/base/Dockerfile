FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
LABEL kim.yunseo.maintainer="Yunseo Kim <dev@yunseo.kim>"
LABEL kim.yunseo.version="1.2"
LABEL kim.yunseo.release-date="2025-12-18"
LABEL description="Dockerfiles for building a basic deep learning development environment, which includes CUDA & cuDNN, OpenSSH Server and tmux only."

# 1. install basic utilities and Python-related packages, gosu, and SSH server
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    gosu \
    openssh-server \
    python3 \
    python-is-python3 \
    python3-pip \
    ssh \
    tmux \
    && rm -rf /var/lib/apt/lists/* \
# verify that the binary works
    && gosu nobody true
    
# 2. Set up time zone
ARG TZ="Asia/Seoul"  # If necessary, replace it with a value that works for you.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 3. Set up SSH server
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# 4. Create remote user
#
# The password must be pre-specified at build time with the `DL_ENV_PASSWD`
# environment variable.
ARG USER_NAME="remote"
ARG HOME_DIR="/home/$USER_NAME"
RUN --mount=type=secret,id=USER_PASSWORD \
    useradd --create-home --home-dir $HOME_DIR --shell /bin/bash $USER_NAME \
    && awk -v user="$USER_NAME" '{print user ":" $0}' /run/secrets/USER_PASSWORD | chpasswd

# 5. Switch to remote user
ENV USER_NAME="$USER_NAME"
USER $USER_NAME
WORKDIR $HOME_DIR

# 6. Install setuptools and pip
RUN python3 -m pip install -U setuptools pip
ENV PATH="$HOME_DIR/.local/bin:$PATH"

# 7. Create a workspace directory to locate jupyter notebooks and .py files
ENV WORK_DIR="$HOME_DIR/workspace"
RUN mkdir -p $WORK_DIR

# 8. Expose SSH and Jupyter Lab ports
EXPOSE 22 8888

# 9. Switch to root
USER root

# 10. Copy the entry point script and grant permission to run it
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
