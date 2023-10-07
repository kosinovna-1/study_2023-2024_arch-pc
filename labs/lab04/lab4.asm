SECTION .data
	Id:      DB "Kosinov Nikita",10,"02-20 Group",10 
		
	IdLen:   EQU $ - Id
	
SECTION .text
	GLOBAL _start           

_start:                 
        mov eax, 4      
        mov ebx, 1    
        mov ecx, Id
        mov edx, IdLen
        int 80h        
	
	mov eax, 1       
        mov ebx, 0      
        int 80h        
