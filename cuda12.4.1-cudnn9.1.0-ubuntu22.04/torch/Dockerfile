FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
LABEL kim.yunseo.maintainer="Yunseo Kim <contact@yunseo.kim>"
LABEL kim.yunseo.version="1.1"
LABEL kim.yunseo.release-date="2025-02-16"
LABEL description="Dockerfiles for building a deep learning development environment, which includes the JupyterLab, OpenSSH Server, tmux, Numpy, Scipy, pandas, Matplotlib, Seaborn, scikit-learn, tqdm, and PyTorch."

# 1. install basic utilities and Python-related packages, sudo, and SSH server
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

# 4. Create remote user (password can be passed to --build-arg at build time)
#
# This default password is very weak. Make sure to change it to your own unique
# password string!
#
# This Dockerfile assumes that the built image will only be used by yourself or
# a small group of trusted insiders, and if you need to distribute the image
# without exposing sensitive information, using --build-arg is dangerous.
# See the official Docker documentation.
ARG USER_NAME="remote"
ARG USER_PASSWORD="000000"
ARG HOME_DIR="/home/$USER_NAME"
RUN useradd --create-home --home-dir $HOME_DIR --shell /bin/bash $USER_NAME \
    && echo "$USER_NAME:$USER_PASSWORD" | chpasswd

# 5. Switch to remote user
ENV USER_NAME="$USER_NAME"
USER $USER_NAME
WORKDIR $HOME_DIR

# 6. Install pip and ml/dl related packages
RUN python3 -m pip install -U setuptools pip
ENV PATH="$HOME_DIR/.local/bin:$PATH"

RUN python3 -m pip install -U \
        jupyterlab numpy scipy pandas matplotlib seaborn[stats] scikit-learn tqdm \
    && python3 -m pip install -U torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu124

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
