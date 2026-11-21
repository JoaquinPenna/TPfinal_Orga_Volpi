global	main

section	.data
	secuenciaBinariaA	db	0xC4, 0x94, 0x37, 0x95, 0x63, 0xA2, 0x1D, 0x3C 
						db	0x86, 0xFC, 0x22, 0xA9, 0x3D, 0x7C, 0xA4, 0x51 
						db	0x63, 0x7C, 0x29, 0x04, 0x93, 0xBB, 0x65, 0x18 
	largoSecuenciaA		db	0x18 ; 24d

	TablaConversion		db	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	
section	.bss
	secuenciaImprimibleA	resb	32
	
section	.text
main:
		lea	rsi,	[rel secuenciaBinariaA]
		lea	rdi,	[rel secuenciaImprimibleA]

		; calculo la cantidad de iteraciones que tengo que hacer
		movzx	eax,	byte [rel largoSecuenciaA]
		xor	edx,	edx
		mov	ebx,	3
		div	ebx
		mov	ecx,	eax

		lea	rdx,	[rel TablaConversion]

loop_codificar:
		; cargo 3 bytes de la secuencia binaria en ebx
		; cargo un byte de rsi en la seccion de bits menos significativos de ebx (bl o byte low) y luego muevo el contenido del registro 8 bits a la izquierda, y repito 3 veces con los siguientes bytes de rsi
		movzx	ebx,	byte [rsi]
		shl	ebx,	8
		mov	bl,	[rsi + 1]
		shl	ebx,	8
		mov	bl,	[rsi + 2]
		; entonces tengo en ebx, del bit 0 al 7, basura, y luego los bytes

		; separo los grupos, los traduzco y los muevo a secuenciaImprimibleA
		;  
		; 1er grupo: bits 8 -> 13
		mov	eax,	ebx ; hago una copia de ebx
		shr	eax,	18 ; muevo los bits a la derecha hasta que el grupo de bits buscado este todo en el sector menos significativo
		and	eax,	0x3F ; aplico una mascara de bits al registro, como 0x3F = ...0000111111, entonces solo los ultimos 6 bits no quedan en estrictamente 0
		mov	al,	[rdx + rax] ; copia en `al` a lo almacenado en la direccion resultante de sumar la base de TablaConversion, que copiamos en rdx, y el desplazamiento calculado en rax
		mov	[rdi],	al ; escribo el caracter guardado en `al` en la direccion de secuenciaImprimibleA

		; 2do grupo: bits 14 -> 19
		mov	eax,	ebx
		shr	eax,	12
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 1],	al

		; 3er grupo: bits 20 -> 25
		mov	eax,	ebx
		shr	eax,	6
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 2],	al

		; 4to grupo: bits 26 -> 31
		mov	eax,	ebx
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 3],	al

		; avanzo los punteros a secuenciaBinariaA y secuenciaImprimibleA
		add	rsi,	3
		add	rdi,	4
		loop	loop_codificar

		ret
