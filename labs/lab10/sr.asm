%include 'in_out.asm'

SECTION .data
	filename db 'name.txt', 0h 
	invite db 'Как Вас зовут?', 0h 
	msg db 'Меня зовут ', 0h

SECTION .bss
	name resb 255 	; переменная для вводимой строки
	buf resb 255 	; переменная для работы подпрограммы

SECTION .text
	global _start

_start:
	; --- Печать приглашающего сообщения
	mov eax,invite
	call sprintLF
	
	; --- Запись фамилии и имени пользователя
	mov ecx, name
	mov edx, 255
	call sread
	
	; --- Создание файла данных
	mov ecx, 0777o
	mov ebx, filename
	mov eax, 8
	int 80h
	
	; --- Запись дескриптора файла в `esi`
	mov esi, eax
	
	; --- Запись в файл
	mov eax, msg
	call _fileprint
	mov eax, name
	call _fileprint
	
	; --- Закрыите файла
	mov ebx, esi
	mov eax, 6
	int 80h
	call quit
	
	; --- Подпрограмма записи в файл
	_fileprint:
		mov ecx, eax
		call slen
		mov edx, eax
		mov ebx, esi
		mov eax, 4
		int 80h
		ret
