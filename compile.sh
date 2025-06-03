#!/bin/bash
# Compilar el programa Mercury
mmc --make empacador

# Verificar si la compilación fue exitosa
if [ $? -eq 0 ]; then
    echo "Compilación exitosa. Iniciando interfaz gráfica..."
    python3 gui.py
else
    echo "Error en la compilación de Mercury"
    exit 1
fi