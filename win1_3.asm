assume cs:code

Calculate segment
        db '1. 3/1=         '
        db '2. 5+3=         '
        db '3. 9-3=         '
        db '4. 4+5=         '
Calculate ends
	
	code segment

start:	mov ax,Calculate
	    mov ds,ax
		mov bx,4
	
		mov al,[bx]
		sub al,47
		mov ah,0
		mov cx,ax
	
	jcxz divtion
step1:	
	add bx,10h
	mov al,[bx]
	mov ah,0
	sub al,43
	mov cx,ax
	
	jcxz addition
step2:	
	add bx,10h
	mov al,[bx]
	mov ah,0
	sub al,45
	mov cx,ax
	
	jcxz subtion
step3:	
	add bx,10h
	mov al,[bx]
	mov ah,0
	sub al,43
	mov cx,ax
	
	jcxz addtion2
	
divtion: 	mov ax,2e31h
			mov [bx].3,ax
			mov ax,3320h
			mov [bx].5,ax
			jmp step1

addition:	mov ax,	2e35h
			mov [bx].3,ax
			mov ax,	3820h
			mov [bx].5,ax
			jmp step2

subtion:	mov ax,	2e30h
			mov [bx].3,ax
			mov ax,	3920h
			mov [bx].5,ax	
			jmp step3
				
addtion2:	mov ax,	2e39h
			mov [bx].3,ax
			mov ax,	3420h
			mov [bx].5,ax				
			
			mov cx,64		
 			mov ax,0b800h
			mov es,ax
			mov bx,0
			mov si,0

circle:		mov ah,71h
			mov al,[bx]
			mov es:[si].148h,ax
            add si,2
			inc bx
			loop circle
			
			mov ax,4c00h
			int 21h
code ends
end start			