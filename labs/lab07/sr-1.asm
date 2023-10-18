%include 'in_out.asm'

SECTION .data
	msg1 db 'Минимальное число = ',0h
	msg2 db 'I вариант: A = 17, B = 23, C = 45',0h
	
	A dd '17'
	B dd '23'
	C dd '45'

SECTION .bss
	min resb 10

SECTION .text
	GLOBAL _start

_start:
	; ---------- Вывод сообщения
	mov eax, msg2
	call sprintLF
	mov eax, msg1
	call sprint
	
	; ---------- Преобразование A,B,C в числа
	mov eax,A
	call atoi 	
	mov [A],eax 
	mov eax,B
	call atoi
	mov [B],eax
	mov eax,C
	call atoi
	mov [C],eax	
	
	; ---------- Ищем максимум. На каждорм шаге если максимум больше, пропускаем следующие шаги
	mov ecx,[A]
	mov [min],ecx
	cmp ecx,[B]
	jl comp_C
	mov ecx,[B]
	mov [min],ecx
	comp_C:
		cmp ecx,[C]
		jl fin
		mov ecx,[C]
		mov [min],ecx
	
	; ---------- Вывод максимума
	fin:
		mov eax,[min]
		call iprintLF 
		call quit 
