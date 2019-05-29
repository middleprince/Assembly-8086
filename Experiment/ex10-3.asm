; 实验 10-3
;trasnfer numbers to ascii code to display on the screen .
;for example 64431 the number,display it  on screen.
;the data end with FFFFFFFFH
;and the display function end with '|' ascii 124

assume cs:code 

source segment
		dd  0,16,3,5
		dd 5937000,22,7,102,0ffffffffh		 ;use FFFF FFFFto sign the end os the input file ,but can't end it creoctly by this way,while i can't find some way
									         ;more efficient .please dot input ffff ffff for data. 
source ends

display segment
		db 20 dup(0)
display ends

data segment
		dw 8 dup(0)
data ends

code segment
		strat: mov ax,source
			   mov ds,ax
			   mov di,0
			  
			   mov bx,0
   bigcicle:   
   			   mov ax,ds:[bx]
               
   			   
   			   cmp ax,0ffffh
   			   je s1            ;end the souce input

		s2:    mov dx,ds:[bx].2    ;init the dividend and divisor 
			   mov cx,10
			   add bx,4
			   push bx 
			   push ds            ;store the pionter which locate the source
			   call trasnfer
			   pop ds
			   pop bx

			   jmp  bigcicle

			s1: cmp [bx].2,0ffffh
 	          je displayall 
 	          jmp s2

  displayall:   mov ax,0
  				mov es:[di].1,ax

     			mov dl,20		
				mov dh,40		;dl means the number of row, dh means the number of columns,cl means the code of color
				mov bx,0		; bx,to selecte the positon to start to show the strings or something else to show
				mov cl,4         
							 
				    			
				mov ax,display
				mov ds,ax
				
				
				call show_string

				
				mov ax,4c00h
				int 21h

	           
	 

	 trasnfer: 
			   mov bp,'|'		;to end inputing the data which in stack to display area
			   push bp
			   mov bp,','
			   sub bp,30h
			   push bp			;store the split tag

	 		    
	 		   mov bx,0 

	 		   cmp ax,0
               je outdiw

	   cicles: 
			   cmp dx,0
			   je  m1			;find number's end
		m2:	   mov cx,10 
			   call divdw     	
			   
			   push cx          ;stroe the spilt number in stack
			
			   jmp short cicles
		 m1:   cmp ax,0
			   je over
			   jmp m2 
		outdiw:push ax
		       jmp over		

		divdw:	mov bx,data
				mov ds,bx
				mov ds:[0],ax	;store the low part of the 
				mov ax,dx
				mov dx,0h
				div cx          
				mov ds:[2],dx	;store the remiander of high int
				mov ds:[4],ax

				mov dx,ds:[2]
				mov ax,ds:[0]


				div cx			;calculate [em(h/n)*65535+l]/n part

				mov cx,dx
				mov dx,ds:[4]  	;store the quotient hingh part in dx,low part in ax,and reaminder in cx.

				ret				;return to caller divdw




		over:  mov cx,di
			         		;store the code to display segment
			   
			   mov ax,display
			   mov es,ax
	  store:   pop ax
	  		   mov cl,al
	  		   mov ch,0
	  		   sub cx,124
	  		   jcxz outstore
	  		   add ax,30h		
			   mov es:[di],al
			   inc di
			   jmp store
			  
   outstore:   ret                 ;return to caller trasnfer


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
end strat