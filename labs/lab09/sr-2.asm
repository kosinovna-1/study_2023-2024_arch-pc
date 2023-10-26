%include 'in_out.asm'

SECTION .data
	div: DB 'Результат: ',0

SECTION .text
	GLOBAL _start

_start:
	; ---- Вычисление выражения (3+2)*4+5
	mov ebx,3
	mov eax,2
	add eax,ebx 	; Меняем местами регистры eax и ebx 
	mov ecx,4
	mul ecx
	add eax,5 	; Хранение промежуточного результата сейчас в eax
	mov edi,eax
	
	; ---- Вывод результата на экран
	mov eax,div
	call sprint
	mov eax,edi
	call iprintLF
	call quit
