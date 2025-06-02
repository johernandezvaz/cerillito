FROM debian:bullseye

# Dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    m4 \
    pkg-config \
    zlib1g-dev \
    libatomic1 \
    git \
    flex \
    bison \
    && rm -rf /var/lib/apt/lists/*

# Descargar Mercury
WORKDIR /opt
RUN curl -LO https://dl.mercurylang.org/release/mercury-srcdist-22.01.1.tar.gz && \
    tar -xzf mercury-srcdist-22.01.1.tar.gz

# Compilar Mercury
WORKDIR /opt/mercury-srcdist-22.01.1
RUN ./configure --with-llds-base-grade=none && \
    make PARALLEL=-j$(nproc) all

# Agregar al PATH
ENV MERCURY_HOME=/opt/mercury-srcdist-22.01.1
ENV PATH="${MERCURY_HOME}/stage2/scripts:${PATH}"

# Verifica que mmc esté disponible (debug temporal)
RUN which mmc && mmc --version

# Carpeta de trabajo del proyecto
WORKDIR /app

# Copiar fuente Mercury
COPY . .

# Compilar tu programa
RUN mmc --make empacador

# Ejecutar
CMD ["./empacador"]
