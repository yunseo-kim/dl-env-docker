# dl-env-docker
Dockerfiles for building a deep learning development environment, which is based on CUDA &amp; cuDNN images provided by the [nvidia/cuda repository](https://hub.docker.com/r/nvidia/cuda) on Docker Hub.  
For more details, read [my blog posts](https://www.yunseo.kim/posts/how-to-build-a-deep-learning-development-environment-with-nvidia-container-toolkit-and-docker-1/).

## Prerequisites
- Systems with NVIDIA GPUs that support CUDA
  - You can check the GPU model name installed in your current computer with the `lspci | grep -i nvidia` command in the terminal.
  - On the <https://docs.nvidia.com/deeplearning/cudnn/latest/reference/support-matrix.html> page, check the **supported NVIDIA graphics driver versions**, required **CUDA Compute Capability** conditions, and the list of **supported NVIDIA hardware** for each cuDNN version.
  - Find the corresponding model name in the GPU list at <https://developer.nvidia.com/cuda-gpus>, and check the **Compute Capability** value. This value must meet the **CUDA Compute Capability** condition checked earlier to use CUDA and cuDNN without issues.
- Host OS with the appropriate version of the graphics driver installed
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)
- [Docker Engine](https://docs.docker.com/engine/)

## Overview of Dockerfiles
Three flavors of images are provided:
- `base`: Includes CUDA & cuDNN, setuptools, and pip.
- `torch`: Builds on the `base` and includes the JupyterLab, Numpy, Scipy, pandas, Matplotlib, Seaborn, scikit-learn, tqdm, and PyTorch.
- `rapids`: Builds on the `torch` and includes the Cupy, cuDF, cuML, and DALI.

## How to use
### Using pre-built images
Pre-built images are available in the [yunseokim/dl-env](https://hub.docker.com/r/yunseokim/dl-env/tags) repository on Docker Hub.  
You can pull the images with the following command.
```bash
# Tag(base)
docker pull yunseokim/dl-env:base-cuda12.4.1-cudnn9.1.0-ubuntu22.04

# Tag(torch)
docker pull yunseokim/dl-env:torch-cuda12.4.1-cudnn9.1.0-ubuntu22.04

# Tag(rapids)
docker pull yunseokim/dl-env:rapids-cuda12.4.1-cudnn9.1.0-ubuntu22.04
```

***When you run a container from this prebuilt image, the account password for the 'remote' user is initialized to 000000. It is extremely vulnerable, so reset the login password immediately after the first run of the container.***

### Build manually
After downloading the desired Dockerfile from this repository, you can build the image yourself by running the following command from the path where the Dockerfile is located.
```bash
docker build -t yunseokim/dl-env:<tag> -f ./Dockerfile . \
--build-arg USER_PASSWORD=<password>
```
Enter the tag of your choice in the \<tag\> field, and in the \<password\> field, enter the login password to be used when remotely login to the 'remote' account with SSH.

### Docker run example
- Make sure to add the `--gpus all` argument to use GPUs in the container runtime.
- Below is an example format for a Docker run. You can customize it to your needs.
```bash
docker run -itd --name dl-env --gpus all \
-p <server-port>:<container-jupyter-port> \
-p <server-port>:<container-ssh-port> \
--restart <always> \
-v <volume-name>:<workspace> \
-w <workspace> \
<image-name>:<tag>
```
