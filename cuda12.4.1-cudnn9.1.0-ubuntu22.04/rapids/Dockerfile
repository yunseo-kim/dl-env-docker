FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
LABEL maintainer="contact@yunseo.kim"
LABEL version="1.1"
LABEL description="Dockerfiles for building a deep learning development environment, which includes the JupyterLab, Numpy, Scipy, pandas, Matplotlib, Seaborn, scikit-learn, tqdm, PyTorch, Cupy, cuDF, cuML, and DALI."

# 1. install basic utilities and Python-related packages, sudo, and SSH server
RUN apt-get update -y && apt-get install -y --no-install-recommends\
    apt-utils \
    sudo \
    ssh \
    curl \
    openssh-server \
    tmux \
    python3 \
    python-is-python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*
    
# 2. Set up time zone
ARG TZ="Asia/Seoul"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 3. Set up SSH server
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# 4. Create remote user (password can be passed to --build-arg at build time)
ARG USER_NAME="remote"
ARG USER_PASSWORD="000000"
RUN useradd --create-home --shell /bin/bash $USER_NAME && \
    echo "$USER_NAME:$USER_PASSWORD" | chpasswd && \
    adduser $USER_NAME sudo

# 5. Switch to remote user
USER $USER_NAME
ENV HOME=/home/$USER_NAME
WORKDIR $HOME

# 6. Install pip and ml/dl related packages
RUN python3 -m pip install -U setuptools pip
ENV PATH="$HOME/.local/bin:$PATH"

RUN python3 -m pip install -U \
        jupyterlab numpy scipy pandas matplotlib seaborn[stats] scikit-learn tqdm && \
    python3 -m pip install -U --index-url https://download.pytorch.org/whl/cu124 \
        torch torchvision torchaudio && \
    python3 -m pip install -U cupy-cuda12x && \
    python3 -m pip install -U --extra-index-url=https://pypi.nvidia.com \
        cudf-cu12==24.8.* cuml-cu12==24.8.* nvidia-dali-cuda120

# 7. Create a workspace directory to locate jupyter notebooks and .py files
RUN mkdir -p $HOME/workspace

# 8. Expose SSH and Jupyter Lab ports
EXPOSE 22 8888

# 9. Copy the entry point script and grant permission to run it
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
