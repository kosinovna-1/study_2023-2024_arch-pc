%include 'in_out.asm'

SECTION .data
	msg2 db 'Ответ = ',0h
	msg1 db 'I вариант',0h
	msgX db 'Введите X >> ',0h
	msgA db 'Введите A >> ',0h

SECTION .bss
	x RESB 10
	a RESB 10
	ans RESB 10
	
SECTION .text
	GLOBAL _start

_start:
	; ---------- Вывод сообщения
	mov eax, msg1
	call sprintLF
	; ---------- Ввод числа Х
	mov eax, msgX
	call sprint
	mov ecx, x
	mov edx, 80
	call sread 
	; ---------- Ввод числа А
	mov eax, msgA
	call sprint
	mov ecx, a
	mov edx, 80
	call sread
	; ---------- Преобразование Х и А в численный вид
	mov eax,x
	call atoi
	mov [x],eax
	mov eax,a
	call atoi
	mov [a],eax
	; ---------- Записываем в ответ 8. Если Х >= А, то переходим в конец
	mov ecx,8
	mov [ans],ecx
	mov ecx, [x]
	cmp ecx, [a]
	jge fin
	; ---------- Если Х < А, то считаем 2А-Х
	mov eax,[a]
	mov ebx,2
	mul ebx
	mov ecx,[x]
	sub eax,ecx
	mov [ans], eax
	; ---------- Вывод собщения "Ответ" и ответ
	fin:
		mov eax,msg2
		call sprint 
		mov eax,[ans]
		call iprintLF
		call quit 
