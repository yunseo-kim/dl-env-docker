FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
LABEL maintainer="contact@yunseo.kim"
LABEL version="1.0"
LABEL description="Dockerfiles for building a deep learning development environment, which includes the JupyterLab, Numpy, Scipy, pandas, Matplotlib, Seaborn, scikit-learn, tqdm, and PyTorch."

RUN apt-get update -y && apt-get install -y --no-install-recommends\
    apt-utils \
    ssh \
    curl \
    openssh-server \
    python3 \
    python-is-python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*
    
# Set up time zone
ARG TZ="Asia/Seoul"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

# Disable root access via password
RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config

# Create a non-root user and switch to it
ARG USER_NAME="remote"
ARG USER_PASSWORD="000000"
RUN useradd --create-home --password $USER_PASSWORD $USER_NAME
ENV HOME=/home/$USER_NAME
USER $USER_NAME
WORKDIR $HOME
# Re-run ssh when the container restarts.
RUN echo "sudo service ssh start > /dev/null" >> $HOME/.bashrc
# Create a workspace directory to locate jupyter notebooks and .py files
RUN mkdir -p $HOME/workspace

RUN python3 -m pip install -U setuptools pip
ENV PATH="$HOME/.local/bin:$PATH"

RUN python3 -m pip install -U jupyterlab numpy scipy pandas matplotlib seaborn[stats] scikit-learn tqdm
RUN python3 -m pip install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

CMD cd $HOME/workspace && \
    jupyter lab --no-browser --autoreload --ip=0.0.0.0 --notebook-dir="$HOME/workspace"
