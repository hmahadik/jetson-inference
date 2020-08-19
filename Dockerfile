FROM arcturusnetworks/streamproc:base-l4t AS builder

ENV DEBIAN_FRONTEND=non-interactive
COPY . /src/jetson-inference
WORKDIR /src/jetson-inference/build
RUN set -eux; \
  cmake ..; \
  make install DESTDIR=./install

FROM arcturusnetworks/streamproc:base-l4t

ENV DEBIAN_FRONTEND=non-interactive
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    libpython3-dev \
    python3-numpy \
    libglew-dev \
    glew-utils \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libglib2.0-dev \
    qtbase5-dev
COPY --from=arcturusnetworks/jetson-inference:builder /src/jetson-inference/build/install /

