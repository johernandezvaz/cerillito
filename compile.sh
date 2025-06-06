#!/bin/bash
# Compilar el programa Mercury
mmc --make empacador

# Verificar si la compilación fue exitosa
if [ $? -eq 0 ]; then
    echo "Compilación exitosa. Iniciando servidores..."
    # Iniciar el servidor de Express en segundo plano
    node server.js &
    EXPRESS_PID=$!
    
    # Iniciar la interfaz de Vite
    npm run dev
    
    # Al terminar Vite, matar el proceso de Express
    kill $EXPRESS_PID
else
    echo "Error en la compilación de Mercury"
    exit 1
fi