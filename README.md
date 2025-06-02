# Simulación de Empacador (Cerillito) en Mercury

Este proyecto simula a un "empacador" o "cerillito" mexicano utilizando el lenguaje de programación Mercury con una interfaz gráfica. La simulación sigue la lógica de empacado del mundo real, asegurando que los artículos compatibles se empacen juntos, mientras que los incompatibles se mantengan separados.

## Estructura del Proyecto

El proyecto está organizado en varios módulos de Mercury:

- `empacador.m` - Módulo principal que inicia la aplicación  
- `category.m` - Define las categorías de artículos y las reglas de compatibilidad  
- `item.m` - Define los artículos del supermercado con sus propiedades  
- `bag.m` - Implementa la gestión de bolsas y la lógica de colocación de artículos  
- `packing_rules.m` - Contiene la lógica y reglas de empacado  
- `ui.m` - Interfaz de usuario basada en texto para la simulación  
- `gui.m` - Implementación conceptual de la interfaz gráfica de usuario  

## Funcionalidades Clave

1. **Categorización lógica**: Los artículos se organizan en categorías como frutas y verduras, lácteos, carnes, productos químicos, etc.
2. **Algoritmo inteligente de empacado**: Sigue la lógica y restricciones reales del empacado.
3. **Compatibilidad de categorías**: Evita que artículos incompatibles se coloquen juntos (por ejemplo, alimentos con productos químicos).
4. **Gestión de peso**: Controla el peso de la bolsa para evitar sobrecargas.
5. **Interfaz interactiva**: Permite a los usuarios controlar el proceso de empacado.

## Ejecución de la Simulación

Para ejecutar esta simulación, necesitas tener un compilador de Mercury instalado en tu sistema. Una vez instalado, puedes compilar y ejecutar el proyecto con los siguientes comandos:

```bash
mmc --make empacador
./empacador
