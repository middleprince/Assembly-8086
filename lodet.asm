;test load function

assume cs:code
	
			start:
		    rwflappybegain:
		    push dx								;load the code in flappy
		    push ax
		    push es
		    push bx

		    mov dx,4
		    mov ax,offset changeint9
		    mov es,ax
		    mov bx,0

		    mov ah,3
		    mov al,8						; unmber of selecter change it later 
		    mov dl,0
		    mov dh,0
		    mov cl,1
		    mov ch,0

		    int 13h

		    pop bx
		    pop es
		    pop ax
		    pop dx
code ends 
end start		    