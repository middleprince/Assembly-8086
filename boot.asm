;boot system form local 
				jmp bootstart
	bootdata:	dw 0,0	
	bootstart:	mov ax,0
				mov es,ax
				mov ax,7c00h
				mov bx,ax

				mov al,1
				mov ch,0
				mov cl,1
				mov dh,0
				mov dl,80h

				mov ah,2
				int 13h

				mov ax,cs
				mov ds,ax
				mov bx,offset bootdata
				mov [bx],7c00h
				mov [bx].2,0
				call dword ptr [bx]
				 
