FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHON_VERSION 3.7.1
ENV PYTHON_ROOT $HOME/local/python-$PYTHON_VERSION
ENV PATH $PYTHON_ROOT/bin:$PATH
ENV PYENV_ROOT $HOME/.pyenv
#RUN sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  less \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  llvm \
  make \
  python-dev \
  python-pip \
  tk-dev \
  vim \
  wget \
  xz-utils \
  zlib1g-dev
# Install Python
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
  && $PYENV_ROOT/plugins/python-build/install.sh \
  && /usr/local/bin/python-build -v $PYTHON_VERSION $PYTHON_ROOT \
  && rm -rf $PYENV_ROOT
WORKDIR /home
# Upgrade pip
COPY requirements.txt /home
RUN pip3 install --upgrade pip
RUN cat /home/requirements.txt | xargs -n 1 pip3 install
COPY . /home
