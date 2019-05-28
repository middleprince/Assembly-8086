assume cs:code

code segment		
	start:
	mov dl,12
	incicle:
			
			mov ah,2
			mov bh,0
			mov dh,4
			
			int 10h	
			
			mov ah,9
			mov al,'a'					;show the remainder masseage use int10\
			mov bl,4
			mov bh,0
			mov cx,1
			int 10h
			

			inc dl
			jmp incicle


			mov ax,4c00h
			int 21h

code ends
end start