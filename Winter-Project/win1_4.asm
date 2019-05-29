assume cs:code
data segment
		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0
data ends

code segment		
start:	mov ax,data
		mov ds,ax
		mov bx,0
        mov ax,0002h
		mov dx,0005h
		
		add ah,71h
		add al,30h
		mov [bx],ax
		
		mov di,715eh
		mov [bx].2,di
		
			
		mov dh,71h
		add dl,30h
		mov [bx].4,dx
		
		
		
		mov cx,3
s:		mov di,712dh
		mov [bx].6,di
		add bx,2
		loop s
	
		sub dl,31h
		mov dh,0
		mov cx,dx
		sub al,30h
		

circle:	add al,al
		loop circle
		
		mov dl,0ah
		mov ds:[18],dl
	    mov ah,0
	    div byte ptr ds:[18]
	    
	    add al,30h
	    
		mov ds:[20],ah
		mov ah,71h
		
		mov [bx].6,ax
		mov al,ds:[20]
		add al,30h
		mov [bx].8,ax
		mov ax,0b800h
		mov es,ax
		mov bx,0
		mov si,0190h
		mov cx,3
		
s1:		mov ax,[bx]
		mov es:[si],ax
		add bx,2
		add si,0a0h
	    loop s1
	    
	    mov cx,3

s2:	    mov ax,[bx]
	    mov es:[si],ax
	    add bx,2
	    add si,2
	    loop s2
		
		add si,0a0h
		sub si,6
		mov cx,2
s3:		mov ax,[bx]
		mov es:[si],ax
		add bx,2
		add si,2
		loop s3
		

		mov ax,4c00h
		int 21h

code ends

end start