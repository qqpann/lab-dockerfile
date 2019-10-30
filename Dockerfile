# https://hub.docker.com/r/nvidia/cuda
FROM nvidia/cuda:10.1-devel-ubuntu18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive

ENV CUDNN_VERSION 7.6.4.38
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# https://github.com/phusion/baseimage-docker/issues/319#issuecomment-262550835
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
&& \
    apt-mark hold libcudnn7
    # rm -rf /var/lib/apt/lists/*

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         mercurial \
         libffi-dev \
         libreadline-gplv2-dev \
         libncursesw5-dev \
         libssl-dev \
         libsqlite3-dev \
         tk-dev libgdbm-dev \
         libc6-dev \
         libbz2-dev \
         libpng-dev && \
     rm -rf /var/lib/apt/lists/*

# https://github.com/pyenv/pyenv-installer
RUN curl https://pyenv.run | bash
RUN pyenv install 3.7.4
RUN pyenv global 3.7.4
RUN pip install --upgrade pip

RUN rm -rf /usr/bin/python /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /code
COPY requirements.txt /code
RUN pip install -r requirements.txt
# Install jupyterlab vim extension, which requires nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install nodejs
RUN jupyter labextension install jupyterlab_vim
