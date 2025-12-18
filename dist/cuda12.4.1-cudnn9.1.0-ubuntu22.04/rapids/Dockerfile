FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
LABEL kim.yunseo.maintainer="Yunseo Kim <dev@yunseo.kim>"
LABEL kim.yunseo.version="1.2"
LABEL kim.yunseo.release-date="2025-12-18"
LABEL description="Dockerfiles for building a deep learning development environment, which includes the JupyterLab, OpenSSH Server, tmux, Numpy, Scipy, pandas, Matplotlib, Seaborn, scikit-learn, tqdm, PyTorch, Cupy, RAPIDS packages, and DALI."

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

# 7. Install ml/dl related packages
RUN python3 -m pip install -U \
        jupyterlab numpy scipy pandas matplotlib seaborn[stats] scikit-learn scikit-image tqdm
RUN python3 -m pip install -U \
        --index-url https://download.pytorch.org/whl/cu124 \
        --extra-index-url=https://pypi.org/simple \
        --extra-index-url=https://pypi.nvidia.com \
        "torch<=2.6.0" "torchvision<=0.21.0" "torchaudio<=2.6.0" \
        cupy-cuda12x \
        "cudf-cu12==25.12.*" "dask-cudf-cu12==25.12.*" "cuml-cu12==25.12.*" \
        "cugraph-cu12==25.12.*" "nx-cugraph-cu12==25.12.*" "cuxfilter-cu12==25.12.*" \
        "cucim-cu12==25.12.*" "pylibraft-cu12==25.12.*" "raft-dask-cu12==25.12.*" \
        "cuvs-cu12==25.12.*" nvidia-dali-cuda120

# 8. Create a workspace directory to locate jupyter notebooks and .py files
ENV WORK_DIR="$HOME_DIR/workspace"
RUN mkdir -p $WORK_DIR

# 9. Expose SSH and Jupyter Lab ports
EXPOSE 22 8888

# 10. Switch to root
USER root

# 11. Copy the entry point script and grant permission to run it
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
