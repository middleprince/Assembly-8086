;trasnfer numbers to ascii code to display on the screen .
;show the data in source segment .
;the data end with "|"
;and the display function end with 0   


assume cs:code 

source segment
		dd 1975,34,3,5
		dd 1976,22,7,3
		dd 1977,383,7,5
		dd 1977,382,9,42
		dd 1978,1356,13,104
		dd 1979,2390,28,85
		dd 1980,8000,38,210
		dd 1981,16000,130,123
		dd 1982,24486,220,111
		dd 1983,50056,476,105
		dd 1984,97479,778,125
		dd 1985,140417,1001,140
		dd 1986,197514,1442,136
		dd 1987,355980,2258,153      ;use FFFF FFFFto sign the end os the input file ,but can't end it creoctly by this way,while i can't find some way
		dd 1988,590827,2793,211		 ;more efficient .please dot input ffff ffff for data. 
		dd 1989,803530,4037,199
		dd 1990,1183000,5635,209
		dd 1991,1843000,8226,224
		dd 1992,2759000,11542,239
		dd 1993,3753000,14430,260
		dd 1994,4649000,153257,304
		dd 1995,5937000,178000,333,0FFFFFFFFH  

source ends

display segment
		db 3360 dup(' ')
display ends

data segment
		dw 10 dup(0)
data ends

code segment
		strat: mov ax,source
			   mov ds,ax
			   mov di,0
			  
			   mov bx,0
   bigcicle:   
   			   mov ax,[bx]
               
   			   cmp ax,0ffffh 
   			   je s1          ;end the souce input

		s2:    mov dx,ds:[bx].2    ;init the dividend and divisor 
			   mov cx,10
			   add bx,4
			   push bx 
			   push ds            ;store the pionter which locate the source
			   call trasnfer
			   add di,20          ;change the position,each element have 20 byes intervals.!
			   pop ds
			   pop bx

			   jmp  bigcicle
 			
 			s1:cmp ds:[bx].2,0ffffh
 				je displayall
 				jmp s2

  displayall:   mov ax,0		;end the every element stored in dispaly segment
  				mov es:[di].1,ax

  				mov dl,0		
				mov dh,0		;dl means the number of row, dh means the number of columns,cl means the code of color
				mov bx,0		; bx,to selecte the positon to start to show the strings or something else to show
				mov cl,4         
							 
				    			
				mov ax,display
				mov ds,ax
				
				
				call show_string

				
				mov ax,4c00h
				int 21h

	           
	 

	 trasnfer: 
			   mov bp,'|'		;end the sigle element
			   push bp 
			   mov bp,0 		;store the split tag
		   	

	 		    
	 		   mov bx,0 
	 		   cmp ax,0
	 		   je outdiw

	   cicles: cmp dx,0
	   		   je m1   	; end end numbr's divition
		m2:	   mov cx,10 
			   call divdw     	
				   
			   push cx          ;stroe the spilt number in stack
			   jmp short cicles
  	     
  	     m1:	cmp ax,0
  	     		je over	
  	     		jmp m2
		
		outdiw: jmp over
		
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




		over:  mov cx,di    ;the numbers of loop
			         		;store the code to display segment
			   
			   mov ax,display
			   mov es,ax
	  store:   pop ax
	  		   mov cx,ax
	  		   mov ch,0
	  		   sub cx,124
	  		   jcxz outstore
	  		   add ax,30h		
			   mov es:[di],al
			   inc di
			   inc bp
			   jmp store
			  
   outstore:   sub di,bp
   				ret                 ;return to caller trasnfer


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