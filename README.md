# TP Final - Organización del Computador - Cátedra: Volpi 

## Enunciado

Implementar en assembler Intel x86_64 un programa que:  
- Codifique una secuencia binaria ubicada en memoria de acuerdo a la plantilla 
tpf.asm, y coloque la secuencia de caracteres imprimibles en el correspondiente 
espacio reservado. Se pide la codificación de binario a caracteres imprimibles de 
la cadena. Observar que la secuencia binaria es múltiplo de 3 (no es necesario 
agregar 0x00 de relleno) 

- Decodifique una secuencia de caracteres imprimibles ubicada en memoria de 
acuerdo a la plantilla tpf.asm y coloque la secuencia de caracteres imprimibles en 
el correspondiente espacio reservado.  


Se pide la codificación de binario a caracteres imprimibles de una cadena y la 
decodificación de caracteres imprimibles a binario de otra cadena. Observar que la 
secuencia binaria es múltiplo de 3 (no es necesario agregar 0x00 de relleno) y la 
secuencia de caracteres imprimibles es múltiplo de 4 (la decodificación no requiere 
eliminar caracteres de relleno)


### Codificación
El codificador toma una secuencia de 24 bytes definidos en la seccion `.data` bajo el nombre de `secuenciaBinariaA` y los codifica en base64 para obtener una cadena de caracteres imprimibles, convirtiendo de a 3 bytes en 4 caracteres, la cual se guarda en el espacio reservado bajo el nombre de `secuenciaImprimibleA`. Al transformar la secuencia de bytes a caracteres, esto se hace segun la tabla definida bajo el nombre de `TablaConversion`.

Para hacer esto se decidio utilizar las versiones de 32 bits de los registros ya que es el tamaño mas pequeño de registro que puede almacenar 24 bits.
Y se trabaja en la seccion mas a la derecha (menos significativa) ya que nos permite cargar de a 3 bytes facilmente haciendo uso el byte low del registro, y luego poder acceder a cada grupo con shifts del tamaño de estos; tambien deja alineados a los bytes para aplicarle la mascara asi apagar los bits que no se van a usar.

La eleccion de algunos registros fueron impuestos por las instrucciones y otros siguen convenciones:
 * RSI y RDI: Por convencion, RSI se utiliza como puntero de origen (`secuenciaBinariaA`) y RDI como puntero al destino(`secuenciaImprimibleA`)
 * RCX/ECX: Es un requisito de la instrucción loop `loop_codificar`. Cada vez que se ejecuta loop, el procesador decrementa RCX en 1 y salta si RCX != 0
 * RAX/EAX/AL: Es exigido por la instrucción div para recibir el dividendo y guardar ahi el cociente. Dentro del bucle se reutiliza como registro acumulador/temporal para desplazar bits, aplicar la mascara y buscar el caracter en la tabla.  
 * RDX/EDX: Es utilizado por div. Una vez hecha la division, queda libre para almacenar la direccion base de 64 bits de `TablaConversion` y permitir el desplazaminto al indice `[rdx + rax]`.
 * RBX/EBX/BL: Se usa como registro de proposito general.

### Decodificación
El decodificador toma una cadena de 32 caracteres imprimibles de la sección `secuenciaImprimibleB` y los convierte de Base64 a una secuencia de 24 bytes, que se almacenan en el espacio reservado `secuenciaBinariaB`. Para hacer esta conversión, se trabaja con grupos de 4 caracteres imprimibles, obteniendo la posición de cada uno dentro de la tabla definida bajo el nombre de `TablaConversion`. Luego, se agrupan esas 4 posiciones para reconstruir los 24 bits originales, a partir de los cuales se generan 3 bytes.

Para hacer esto se utilizó registros de 32 bits, ya que permiten almacenar los 24 bits correspondientes a cada grupo de 4 caracteres Base64. Se trabaja en el registro acumulador, donde se van incorporando las posiciones obtenidas de la tabla. Para ello, se desplaza su contenido 6 bits hacia la izquierda y agrega la nueva posición. De esta manera, cada posición ocupa 6 bits y se van agrupando hasta completar los 24 bits del grupo. Una vez reunidos, se utilizan desplazamientos y máscaras para obtener los tres bytes que se almacenan en el destino.

La elección de algunos registros fue determinada por las operaciones realizadas, mientras que otros siguen convenciones:

- RSI: Se utiliza como puntero de origen (`secuenciaImprimibleB`). Avanza una posición por cada carácter leído.

- RDI: Se utiliza como puntero de destino (`secuenciaBinariaB`). Una vez generados los tres bytes, avanza tres posiciones.

- RAX/EAX/AL: Se utiliza como registro acumulador. AL recibe el carácter imprimible leído desde la secuencia. Luego, EAX almacena progresivamente las posiciones encontradas en la tabla, desplazando su contenido 6 bits hacia la izquierda y agregando cada nueva posición. Finalmente, contiene los 24 bits necesarios para reconstruir los tres bytes.

- RCX/ECX: Se utiliza como contador durante la búsqueda de la posición de cada carácter dentro de `TablaConversion`. Comienza en cero y se incrementa hasta encontrar una coincidencia. Su valor final representa el índice del carácter dentro de la tabla.

- RDX/EDX: Se utiliza como contador para llevar la cantidad de caracteres procesados dentro de cada grupo de 4. Al completar el grupo, también se reutiliza como registro temporal para extraer los tres bytes del acumulador mediante desplazamientos y máscaras.


**Integrantes**: Joaquin Penna y Guadalupe Avalos
