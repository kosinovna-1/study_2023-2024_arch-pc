%include 'in_out.asm'

SECTION .data
	polynom: DB 'Вариант1. f(x)=(10+2x)/3',0
	zapros: DB 'Введите x: ',0
	rez: DB 'f(x) = ',0

SECTION .bss
	x: RESB 80

SECTION .text
	GLOBAL _start

_start:
	mov eax, polynom
	call sprintLF 		; Вывод формулы
	
	mov eax, zapros
	call sprint 		; Запрос переменной
	
	mov ecx, x
	mov edx, 80
	call sread 		; Ввод аргумента
	
	mov eax,x 
	call atoi 		; Преобразование аргумента в число
	
	mov ebx, 2
	mul ebx		
	add eax, 10		
	xor edx, edx
	mov ebx,3		
	div ebx 		; Подсчёт выражения
	mov edx, eax
	
	mov eax, rez
	call sprint		; Вывод сообщения
	
	mov eax,edx
	call iprintLF		; Вывод результата
	
	call quit		; Выход
