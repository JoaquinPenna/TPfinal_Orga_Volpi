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
		movzx	ebx,	byte [rsi]
		shl	ebx,	8
		mov	bl,	[rsi + 1]
		shl	ebx,	8
		mov	bl,	[rsi + 2]

		; separo los grupos, los traduzco y los muevo a secuenciaImprimibleA
		; 1er grupo
		mov	eax,	ebx
		shr	eax,	18
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi],	al

		; 2do grupo
		mov	eax,	ebx
		shr	eax,	12
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 1],	al

		; 3er grupo
		mov	eax,	ebx
		shr	eax,	6
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 2],	al

		; 4to grupo
		mov	eax,	ebx
		and	eax,	0x3F
		mov	al,	[rdx + rax]
		mov	[rdi + 3],	al

		add	rsi,	3
		add	rdi,	4
		loop	loop_codificar

		ret
