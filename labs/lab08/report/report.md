---
## Front matter
title: "РУДН. Архитектура компьютеров"
subtitle: "Отчёт по лабораторной работе №8"
author: "Косинов Никита Андреевич, НПМбв-02-20"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase,Scale=0.9
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Многие логики программ требуют повторять одну и ту же оперцию несколько раз: фиксированное, либо зависящее от параметров, заданных пользователем. В любом случае, в Ассемблере предусмотрена такая возможность. 

Цель данной работы - научиться писать программы, использующие логику циклов, а также познакомиться со структорой стека.

# Ход работы

Лабораторная работа выполнена с использованием консоли **OC Linux** и языка программирования ассемблера **NASM**.

1. Реализация цикла фиксированной длины;

2. Реализация цикла, зависящего от аргументов;

3. Работа с аргументами.

В конце выполнена самостоятельная работа.

# Реализация цикла фиксированной длины

Чтобы организовать цикл в **NASM**, можно использовать инструкцию **loop**. Она уменьшает значение, хранящееся в регистре **ecx** на 1, и, если получает не ноль, переходит на указанную метку. Таким образом, метка указанная над командой **loop** возвращает нас на несколько шагов назад, но с новым значением **ecx**. Так мы получаем цикл на **ecx** операций.

1. Создаём рабочий файл.

![Создание файла](./image/1.png){#fig:fig1 width=70%}

2. Пишем код с использованием цикла длины **N**, где последний вводится пользователем.

![Код программы lab8-1](./image/2.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'
SECTION .data
	msg1 db 'Введите N: ',0h

SECTION .bss
	N: resb 10

SECTION .text
	global _start

_start:
	; ----- Вывод сообщения 'Введите N: '
	mov eax,msg1
	call sprint
	
	; ----- Ввод 'N'
	mov ecx, N
	mov edx, 10
	call sread
	
	; ----- Преобразование 'N' из символа в число
	mov eax,N
	call atoi
	mov [N],eax
	
	; ------ Организация цикла
	mov ecx,[N] 	; Счетчик цикла, `ecx=N`
	label:
		mov [N],ecx
		mov eax,[N]
		call iprintLF 	; Вывод значения `N`
		loop label 	; `ecx=ecx-1` и если `ecx` не '0'
				; переход на `label`
	call quit
```

3. Компилируем и запускаем. Изначально в **ecx** записывает число 5, далее каждую итерацию мы выводим его на экран и уменьшаем на 1. По достижении 0 программа завершает работу

![Исполнение lab8-1](./image/3.png){#fig:fig1 width=70%}

4. Изменим работу программы, добавив уменьшение **ecx** на 1 вручную.

![Код программы lab8-1-1](./image/4.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'
SECTION .data
	msg1 db 'Введите N: ',0h

SECTION .bss
	N: resb 10

SECTION .text
	global _start

_start:
	; ----- Вывод сообщения 'Введите N: '
	mov eax,msg1
	call sprint
	
	; ----- Ввод 'N'
	mov ecx, N
	mov edx, 10
	call sread
	
	; ----- Преобразование 'N' из символа в число
	mov eax,N
	call atoi
	mov [N],eax
	
	; ------ Организация цикла
	mov ecx,[N] 	; Счетчик цикла, `ecx=N`
	label:
	sub ecx,1
	mov [N],ecx
	mov eax,[N]
	call iprintLF 	; Вывод значения `N`
	loop label 	; `ecx=ecx-1` и если `ecx` не '0'
			; переход на `label`
	call quit
```

5. Запустим, попробовав **N=7** и **N=6**. Во втором случае видно, что выводятся числа с шагом 2. Действительно, **ecx** уменьшается дважды на 1 за одну итерацию: нами и инструкцией **loop**. В первом случае же, раз **N** нечётно, после 1 мы получим -1, т.е. не 0, и программы продолжит работу. При этом, -1 в **ecx** - это самое большое число, поэтому мы видим такой результат.

![Исполнение lab8-1-1](./image/5.png){#fig:fig1 width=70%}

6. Для исправления такого рода недочёта, можно перед изменением значения **ecx** его сохранить, например, в стек. А перед концом шага цикла достать обратно.

![Код программы lab8-1-2](./image/6.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'
SECTION .data
	msg1 db 'Введите N: ',0h

SECTION .bss
	N: resb 10

SECTION .text
	global _start

_start:
	; ----- Вывод сообщения 'Введите N: '
	mov eax,msg1
	call sprint
	
	; ----- Ввод 'N'
	mov ecx, N
	mov edx, 10
	call sread
	
	; ----- Преобразование 'N' из символа в число
	mov eax,N
	call atoi
	mov [N],eax
	
	; ------ Организация цикла
	mov ecx,[N] 	; Счетчик цикла, `ecx=N`
	label:
		push ecx
		sub ecx,1
		mov [N],ecx
		mov eax,[N]
		call iprintLF 	; Вывод значения `N`
		pop ecx
		loop label 	; `ecx=ecx-1` и если `ecx` не '0'
				; переход на `label`
	call quit
```

7. Компилируем и запустим. Получим значения **ecx**, уменьшенные на 1.

![Исполнение lab8-1-2](./image/7.png){#fig:fig1 width=70%}

# Реализация цикла, зависящего от аргументов

При запуске программы есьт возможность указать какие-либо аргументы, которые программа может использовать. Попробуем написать код, который работате с введёнными с клавиатуры аргументами.

1. Пишем код программы: вывести указанные аргументы, каждый на новой строке. Количество аргументов при этом можно взять из стека аргументов, пропуская при этом название программы, также записанное в стек.

![Код программы lab8-2](./image/8.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'

SECTION .text
	global _start

_start:
	pop ecx 	; Извлекаем из стека в `ecx` количество
			; аргументов (первое значение в стеке)
	pop edx 	; Извлекаем из стека в `edx` имя программы
			; (второе значение в стеке)
	sub ecx, 1 	; Уменьшаем `ecx` на 1 (количество
			; аргументов без названия программы)
	
next:
	cmp ecx, 0 	; проверяем, есть ли еще аргументы
	jz _end 	; если аргументов нет выходим из цикла
			; (переход на метку `_end`)
	pop eax 	; иначе извлекаем аргумент из стека
	call sprintLF 	; вызываем функцию печати
	loop next 	; переход к обработке следующего
			; аргумента (переход на метку `next`)
	
_end:
	call quit
```

2. Компилируем и запускаем.

![Исполнение lab8-2](./image/9.png){#fig:fig1 width=70%}

# Работа с аргументами

1. Попробуем сдлеать с аргументами что-то дополнительно, например, посчитать их сумму. 

![Код программы lab8-3](./image/11.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'

SECTION .data
	msg db "Результат: ",0

SECTION .text
	global _start

_start:
	pop ecx 	; Извлекаем из стека в `ecx` количество
			; аргументов (первое значение в стеке)
	pop edx 	; Извлекаем из стека в `edx` имя программы
			; (второе значение в стеке)
	sub ecx,1 	; Уменьшаем `ecx` на 1 (количество
			; аргументов без названия программы)
	mov esi, 0 	; Используем `esi` для хранения
			; промежуточных сумм
	
next:
	cmp ecx,0h 	; проверяем, есть ли еще аргументы
	jz _end 	; если аргументов нет выходим из цикла
			; (переход на метку `_end`)
	pop eax 	; иначе извлекаем следующий аргумент из стека
	call atoi 	; преобразуем символ в число
	add esi,eax 	; добавляем к промежуточной сумме
			; след. аргумент `esi=esi+eax`
	loop next 	; переход к обработке следующего аргумента
	
_end:
	mov eax, msg 	; вывод сообщения "Результат: "
	call sprint
	mov eax, esi 	; записываем сумму в регистр `eax`
	call iprintLF 	; печать результата
	call quit 	; завершение программы
```

2. Компилируем и запускаем. Программа работает корректно: $1+2+3+...+10 = \dfrac{11\times 10}{2}=55$.

![Исполнение lab8-3](./image/10.png){#fig:fig1 width=70%}

3. Изменим программу, чтобы она считала произведение чисел. Не забываем "обнулить" регистр **esi** единицей.

![Код программы lab8-3-1](./image/13.png){#fig:fig1 width=70%}

```
%include 'in_out.asm'

SECTION .data
	msg db "Результат: ",0

SECTION .text
	global _start

_start:
	pop ecx 	; Извлекаем из стека в `ecx` количество
			; аргументов (первое значение в стеке)
	pop edx 	; Извлекаем из стека в `edx` имя программы
			; (второе значение в стеке)
	sub ecx,1 	; Уменьшаем `ecx` на 1 (количество
			; аргументов без названия программы)
	mov esi, 1 	; Используем `esi` для хранения
			; промежуточных произведений
	
next:
	cmp ecx,0h 	; проверяем, есть ли еще аргументы
	jz _end 	; если аргументов нет выходим из цикла
			; (переход на метку `_end`)
	pop eax 	; иначе извлекаем следующий аргумент из стека
	call atoi 	; преобразуем символ в число
	mul esi		; умножаем число на промежуточное произведение
	mov esi,eax	; сохраняем произведение
	loop next 	; переход к обработке следующего аргумента
	
_end:
	mov eax, msg 	; вывод сообщения "Результат: "
	call sprint
	mov eax, esi 	; записываем произведение в регистр `eax`
	call iprintLF 	; печать результата
	call quit 	; завершение программы
```

4. Запустим и посчитаем, например $6! = 720$.

![Исполнение lab8-3-1](./image/12.png){#fig:fig1 width=70%}

# Самостоятельная работа

В самостоятельной работе предлагается взять функцию $f(x)=2x+15$ и посчитать сумму значений этой функции от введённых аргументов. 

1. Напишем код с комментариями.

![Код программы sr](./image/15.png){#fig:fig1 width=70%}

![Код программы sr](./image/16.png){#fig:fig1 width=70%}

```
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
```

2. Скомпилируем и запустим несколько раз, указывая разные наборы аргументов. Убедимся, что во всех случаях программа работает корректно, в том числе, если аргументы не указаны.

![Исполнение sr](./image/14.png){#fig:fig1 width=70%}

# Выводы

В ходе данной лабораторной работы мы познакомились со структурой стека, научились брать из автоматически созданного стека аргументы и их количество, реализовали работу с аргументами с использованием циклической структуры.


::: {#refs}
:::
