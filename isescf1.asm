
;int 16h ah=0 ah=1
    isescf1:
				mov ah,1
				cmp al,1bh						;is esc
				je backmain
				cmp ah,3bh						; is f1
				je colorchange
		backit:		
				ret



	backmain:	mov ah,0
				int 16h
				jmp main

	colorchange: call colorchange
				mov ah,0
				int 16h
				jmp backit


colorchange:
				push ax
				push cx
				push es
				push di
				
				mov cx,4000
				mov ax,0b800h
				mov es,ax
				mov di,1
			
			circle1:
				inc byte ptr es:[di]
				inc di
				inc di
				loop circle1

				pop di
				pop es
				pop cx
				pop ax

				ret






				
				mov bx,0ffffh
				mov ax,0ffffh
		incircle1:
				cmp ax,0
				je incicle2
				dec ax
				jmp short incircle1
		incicle2:
				cmp bx,0
				je backmains
				dec bx
				jmp incicle2

		backmains: jmp main
