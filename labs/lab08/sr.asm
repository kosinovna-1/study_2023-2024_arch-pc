%include 'in_out.asm'

SECTION .data
	msg0 db "Вариант I",0
	msg1 db "Функция: f(x) = 2x+15 ",0
	msg2 db "Результат: ",0

SECTION .text
	global _start

_start:
	; ------- Выод приглашающих сообщений
	mov eax, msg0
	call sprintLF
	mov eax, msg1
	call sprintLF
	
	; ------- Подготовка стека аргументов и буфера для хранения промежуточных сумм
	pop ecx 	
	pop edx 	
	sub ecx,1 	
	mov esi, 0 	
	
	; ------- Проверяем, есть ли аргументы
	cmp ecx,0h
	jz _end

	; ------- Считаем в цикле f(x) и прибавляем к буферу esi
next:
	pop eax 	; извлекаем следующий аргумент из стека
	call atoi 	; преобразуем символ в число
	mov ebx, 2
	mul ebx
	add eax, 15
	add esi, eax
	loop next 	; переход к обработке следующего аргумента
	
	; ------- Вывод результата работы программы
_end:
	mov eax, msg2 	; вывод сообщения "Результат: "
	call sprint
	mov eax, esi 	; записываем произведение в регистр `eax`
	call iprintLF 	; печать результата
	call quit 	; завершение программы
