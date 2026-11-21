global main

section	.data

	secuenciaImprimibleB db	"vhyAHZucgTUuznwTDciGQ8m4TuvUIyjU"
	largoSecuenciaB		db	0x20 ; 32d

	TablaConversion		db	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

section	.bss
    ; Espacio para almacenar los 24bytes decodificados
    secuenciaBinariaB resb 24

section	.text

main:
    mov rbp, rsp; for correct debugging

; rsi apunta al origen, es decir, a la cadena imprimible
; rdi apunta al destino, es decir, al lugar donde se almacenarán los 
; bytes codificados

    lea rsi, [rel secuenciaImprimibleB] 
    lea rdi, [rel secuenciaBinariaB]
    lea rbx, [rel TablaConversion]
    
    ; Acumulador, donde se juntan las posiciones de los 4 caracteres
    xor eax, eax
    ; Contador que cuando llegue a 4, generars los 3 bytes
    xor edx, edx
    
    
recorrido_caracteres:

    push rax
    mov al, [rsi]
    xor ecx, ecx

  
busqueda_posicion:

    ; Comparo el caracter leido con la posicion actual de la tabla
    ; de conversion
    cmp al, [rbx + rcx]
    ; Si coincidieron, se encontró su posicion
    je posicion_encontrada
    ; Sino, avanza a la siguiente
    inc ecx 
    
    ; Compruebo si recorri los 64 caracteres
    cmp ecx, 64 ; Avisa si llegó al final del recorrido
    
    jne busqueda_posicion
    
    ; Si se llega hasta acá, es porque hay un caracter
    ; que no aparece en la tabla
    
    je caracter_invalido
     
     
posicion_encontrada: 
    ; Recibe la posicion del caracter obtenido y continua recorriendo al siguiente
    ; caracter.
    
   
   pop rax
   
   shl eax, 6
   or eax, ecx
   
   inc rsi
   ; Cuenta cuantos caracteres ya estan procesados dentro
   ; del grupo de 4
   inc edx
   
   ; dec me permite llevar la cuenta de cuantos caracteres imprimibles
   ; me queda por decodificar
   dec byte [largoSecuenciaB]
    
   cmp edx, 4
   
   ; Si se tienen las 4 posiciones, va a ir a generar los 3 bytes
   je generar_bytes
   
   ; Si aun faltan caracteres, sigue recorriendo
   jmp recorrido_caracteres
   
   
generar_bytes:

    ; 1er byte
    mov edx, eax
    shr edx, 16
    mov [rdi], dl
    
    ; 2do byte
    mov edx, eax
    shr edx, 8
    and edx, 0xFF
    mov [rdi + 1], dl
    
    ; 3er byte
    mov edx, eax
    and edx, 0xFF
    mov [rdi + 2], dl
    
    ; Avanza tres posiciones al destino, ya que se 
    ; almacenaron 3 bytes
    add rdi, 3
    
    ; Reinicio el contador y el acumulador
    ; para juntar las posiciones del siguiente grupo de
    ; 4 caracteres
    xor eax, eax
    xor edx, edx
    
    ; Compruebo si quedan caracteres
    cmp byte [largoSecuenciaB], 0
    
    jne recorrido_caracteres

    ret
    

caracter_invalido:
    ; Finaliza el programa indicando que hubo un error
    
    mov eax, 60
    mov edi, 1 
    syscall
    
    
    


    