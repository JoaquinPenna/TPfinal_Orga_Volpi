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
El codificador toma una secuencia de 24 bytes definidos en la seccion `.data` bajo el nombre de `secuenciaBinariaA` y los conviercodifica en base64 para obtener una cadena de carcteres imprimibles, convirtiendo de a 3 bytes en 4 caracteres, la cual se guarda en el espacio reservado bajo el nombre de `secuenciaImprimibleA`. Al transformar la secuencia de bytes a caracteres, esto se hace segun la tabla definida bajo el nombre de `TablaConversion`.

Para hacer esto se decidio utilizar las versiones de 32 bits de los registros ya que es el tamaño mas pequeño de registro que puede almacenar 24 bits.
Y se trabaja en la seccion mas a la derecha (menos significativa) ya que nos permite cargar de a 3 bytes facilmente haciendo uso el byte low del registro, y luego poder acceder a cada grupo con shifts del tamaño de estos; tambien deja alineados a los bytes para aplicarle la mascara asi apagar los bits que no se van a usar.

La eleccion de algunos registros fueron impuestos por las instrucciones y otros siguen convenciones:
 * RSI y RDI: Por convencion, RSI se utiliza como puntero de origen (`secuenciaBinariaA`) y RDI como puntero al destino(`secuenciaImprimibleA`)
 * RCX/ECX: Es un requisito de la instrucción loop `loop_codificar`. Cada vez que se ejecuta loop, el procesador decrementa RCX en 1 y salta si RCX != 0
 * RAX/EAX/AL: Es exigido por la instrucción div para recibir el dividendo y guardar ahi el cociente. Dentro del bucle se reutiliza como registro acumulador/temporal para desplazar bits, aplicar la mascara y buscar el caracter en la tabla.  
 * RDX/EDX: Es utilizado por div. Una vez hecha la division, queda libre para almacenar la direccion base de 64 bits de `TablaConversion` y permitir el desplazaminto al indice `[rdx + rax]`.
 * RBX/EBX/BL: Se usa como registro de proposito general.

### Decodificación
El decodificador convierte una cadena de 32 caracteres impribles en sus 24 bytes originales. Para esto, se recorre la cadena caracter por caracter y se busca cada uno en la tabla de conversión (TablaConversion), logrando obtener de cada uno su posición en dicha tabla.
Luego se acumulan las posiciones en grupos de solo 4 caracteres. Una vez obtenidos las 4 posiciones de cada caracter, se reconstruyen hacia unicamente 3 bytes. Dichos bytes van a ser una secuencia binaria que van a ser almacenados en dentro de un espacio reservado (secuenciaBinariaB). Luego el proceso se repite hasta procesar todos los caracteres imprimibles (secuenciaImpribleB).

**Integrantes**: Joaquin Penna y Guadalupe Avalos
