;the test function of new keyboard interruption to deploy the f1 and esc function

assume cs:code

code segment
start:

changeint9:								;the new keyboard interruption !!!!!!!!!!!
			
			mov ax,0
			mov es,ax
			mov ax,cs
			mov ds,ax 

			mov si,offset newint9h 
			mov di,204h
			mov cx,offset newint9hend-offset newint9h
			cld
			rep movsb

			mov ax,es:[9*4]
			mov es:[200h],ax						
			mov ax,es:[9*4+2]
			mov es:[202h],ax					;store orginal vertol in 0:200h 

			cli     							;set if =1
			mov word ptr es:[9*4],204h
			mov word ptr es:[9*4+2],0			;modify the table
			sti



			mov ax,4c00h
			int 21h

		newint9h:
			
			
			in al,60h
			pushf
			call dword ptr cs:[200h]		;call orginal keyboard interruption
			
			cmp al,3bh
			je f1func
			cmp al,81h
			je esc1
			

		over:nop
			iret


		esc1:mov ax,4c00h
			int 21h
		
			jmp over

		f1func:	
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

			jmp over

			

		

		newint9hend:nop


code ends
end start		
