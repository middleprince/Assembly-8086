assume cs:code

Cryptography segment
        db 'tqsfbe!zpvs!xjoht'
        db '!!cf!zpvs!nbtufs!'
Cryptography ends

PlainText segment
        db 34 dup (' ')
PlainText ends

code segment

 start: mov ax,Cryptography
 		mov ds,ax
 		mov ax,PlainText
 		mov es,ax
 		mov bx,0
 		mov cx,34

 s1:    mov al,[bx]
 	 	sub al,1  
 	 	mov es:[bx],al   ;decryption
 	 	inc bx     
 	 	loop s1	
 		mov cx,34
 		mov ax,0b800h
 		mov ds,ax
 		
 		mov bx,148h
 		mov si,0h

 s2:	mov ah,71h
        mov al,es:[si]	 	
 		mov [bx],ax
 		inc si
 	    add bx,2
 		loop s2
 		
 		mov ax,4c00h
 		int 21h
 code ends
 
 end start