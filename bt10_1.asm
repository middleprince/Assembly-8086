;print the content on scren,and also you can chose the rows and columns of the display areae to print the content. 

assume cs:code

data segment
		db'Welcom to masm!','|'
data ends

code segment

start:	
        mov dl,20	
		mov dh,40		;dl means the number of row, dh means the number of columns,cl means the code of color
		mov bx,6		; bx,to selecte the positon to start to show the strings or something else to show
		mov cl,4         
					 
		    

		
		mov ax,data
		mov ds,ax
		
		
		call show_string

		
		mov ax,4c00h
		int 21h

show_string: push si
			 
			 mov ch,0
			 push cx		;store the color
			 push bx		;store the positon to show the content

			 mov ax,0b800h	;set the position of vram
			 mov es,ax
			 
			 
			 mov bx,00a0h 
			 mov al,dl
			 mov ah,0
			 mul bx    		;calculate the rows address in vram.which vram conclude 25row and 80columns
			 
			 mov si,ax
			 
			 mov bl,2
			 mov al,dh
			 mov ah,0
			 sub ax,1
			 mul bl			;calcaulate the columns
			 add si,ax      ;the final position in vram to write content
			 
			 
			 pop bx
			 pop dx
circle:		 mov cl,[bx]
			 mov ch,0
			 sub cx,124
			 jcxz wordend		;end the draw and return it to caller
			 
			 
             mov al,[bx]
             mov ah,dl
			 mov es:[si],ax
			 add si,2
			 inc bx
			
			 jmp short circle
             
wordend:    pop si        
			ret
			 
code ends 
end start			 
		



