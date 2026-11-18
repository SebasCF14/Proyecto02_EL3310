# Proyecto02_EL3310
Programa en SystemVerilog que permite multiplicar y dividir por medio de una ALU 64-bits. Proyecto Corto #2 del curso "Diseño de Sistemas Digitales" EL-3310 de la Escuela de Ingeniería Electrónica del Instituto Tecnológico de Costa Rica.

### 📝 Pruebas del multiplicador 
Se realizaron 5 pruebas diferentes para el multiplicador, utilizando un módulo para hacer el testbench asignándole valores al multiplicando y multiplicador. Las pruebas fueron las siguientes:
- Multiplicación básica
- Multiplicación por cero
- Multiplicación por uno
- Multiplicación máxima de 32-bits
- Multiplicación de escala media
El banco de pruebas sirvió para analizar el comportamiento de la ALU ante distintos casos específicos de multiplicación. Así mismo, nos permitió encontrar errores en la limpieza de los productos anteriores cuando se realizaba una nueva multiplicación.

![Banco de pruebas del multiplicador](PruebaM.jpg)

![Formas de onda del multiplicador](WaveM.jpg)

### 📝 Pruebas del divisor
Para el divisor, se realizaron 9 pruebas, debido a que requiere más controles en cuanto a las limitaciones matemáticas y técnicas, como la división entre cero o decimales en el cociente. Utilizando también un módulo para hacer el testbench, asignándole valores al dividendo y divisor, las pruebas fueron las siguientes:
- División inexacta
- División exacta
- Dividendo menor al divisor
- Dividendo igual cero
- División entre uno
- Dividendo igual al divisor
- División de una iteración
- Dividendo de 32-bits
- División entre cero
La división requería realizar más pruebas debido a sus limitaciones matemáticas como la indefinición de una división entre cero. De igual manera, existían dos formas diferentes de realizar la solución como lo son:
1. Tomando en cuenta los decimales del cociente para obtener un residuo nulo
2. La solución implementada donde se separa el cociente y el residuo
Se opta por la segunda por el objetivo principal del proyecto, además de evitar el uso de decimales en divisiones periódicas.

![Banco de pruebas del multiplicador](PruebaM.jpg)

![Formas de onda del multiplicador](WaveM.jpg)


