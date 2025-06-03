FROM ubuntu:jammy

# 1. Instalar dependencias con versión específica
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    build-essential \
    autoconf \
    automake \
    flex \
    bison \
    git \
    pkg-config \
    libncurses-dev \
    zlib1g-dev \
    libreadline-dev \
    libgmp-dev \
    libssl-dev \
    unzip \
    python3 \
    cmake \
    ninja-build

# 2. Descargar y compilar Mercury con configuración optimizada
RUN cd /tmp && \
    wget https://github.com/Mercury-Language/mercury-srcdist/archive/refs/tags/rotd-2025-06-02.tar.gz && \
    tar xvf rotd-2025-06-02.tar.gz && \
    cd mercury-srcdist-rotd-2025-06-02 && \
    ./configure \
        --prefix=/usr/local/mercury-rotd \
        --enable-java-grade \
        --enable-csharp-grade \
        --disable-most-grades \
        --enable-debug \
        --enable-static && \
    make PARALLEL=$(nproc) && \
    make install

# 3. Configurar entorno
ENV PATH="/usr/local/mercury-rotd/bin:${PATH}"
ENV MERCURY_OPTIONS="-O0"

# 4. Verificar instalación
RUN mmc --version

# 5. Copiar y compilar empacador.m
COPY empacador.m /app/
WORKDIR /app
RUN mmc --make empacador

# 6. Limpieza para reducir tamaño de imagen
RUN rm -rf /tmp/* /var/lib/apt/lists/*