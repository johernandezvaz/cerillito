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

# Copiar el archivo Mercury local al contenedor
COPY mercury-srcdist-22.01.8.tar.gz /opt/

# Descomprimir Mercury
WORKDIR /opt
RUN tar -xzf mercury-srcdist-22.01.8.tar.gz && \
    rm mercury-srcdist-22.01.8.tar.gz  # Eliminar el comprimido

# Definir MERCURY_HOME
ENV MERCURY_HOME=/opt/mercury-srcdist-22.01.8

# Compilar e instalar Mercury
WORKDIR ${MERCURY_HOME}
RUN ./configure --prefix="${MERCURY_HOME}/stage2" --with-llds-base-grade=none && \
    make PARALLEL=-j$(nproc) all && \
    make install

# Agregar al PATH
ENV PATH="${MERCURY_HOME}/stage2/bin:${PATH}"

# Verificar instalación
RUN which mmc && mmc --version

# Carpeta de trabajo del proyecto
WORKDIR /app

# Copiar fuente Mercury
COPY . .

# Compilar tu programa
RUN mmc --make empacador

# Ejecutar
CMD ["./empacador"]