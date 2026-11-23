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
El codificador convertirá una secuencia de 24 bytes binarios a 32 caracteres imprimibles. Para hacer esto, primero se calcula la cantidad de iteracciones necesarias a ser recorrida, tomando grupos de a 3 bytes. Estos bytes se agruparán en un registro de 32 bits para luego dividirlo en cuatro grupos de 6 bits. Cada grupo de bits será utilizado para encontrar la posicion de cada caracter correpondiente a la tabla (TablaConversion) y el resultado se almacenará en un espacio reservado para esto (secuenciaImprimibleA).

### Decodificación
El decodificador convierte una cadena de 32 caracteres impribles en sus 24 bytes originales. Para esto, se recorre la cadena caracter por caracter y se busca cada uno en la tabla de conversión (TablaConversion), logrando obtener de cada uno su posición en dicha tabla.
Luego se acumulan las posiciones en grupos de solo 4 caracteres. Una vez obtenidos las 4 posiciones de cada caracter, se reconstruyen hacia unicamente 3 bytes. Dichos bytes van a ser una secuencia binaria que van a ser almacenados en dentro de un espacio reservado (secuenciaBinariaB). Luego el proceso se repite hasta procesar todos los caracteres imprimibles (secuenciaImpribleB).

**Integrantes**: Joaquin Penna y Guadalupe Avalos