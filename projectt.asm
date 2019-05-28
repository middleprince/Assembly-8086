

;----------------------------------------------------------------main menuns---------------------------
assume cs:code
code segment
main:
		start:
		jmp maincodestart
		dis1:	db '1) reset pc.','$'
		dis2:	db '2) start system.','$'
		dis3:	db '3) show system time.','$'
		dis4:	db '4)set clock.input the number to select the function.','$'
		maincodestart:


				mov ax,cs
				mov ds,ax
				mov si,offset dis1
				mov dh,4
				mov dl,1
				call display
				
				mov ax,cs
				mov ds,ax
				mov si,offset dis2
				mov dh,5
				mov dl,1
				call display
				
				mov ax,cs
				mov ds,ax
				mov si,offset dis3
				mov dh,6
				mov dl,1
				call display
				
				mov ax,cs
				mov ds,ax
				mov si,offset dis4
				mov dh,7
				mov dl,1
				call display
				
				nextstep:
				call echostr					;using echostr to select the function
				mov ah,ds:[bx]
				cmp ah,'1'
				je resetpc
				cmp ah,'2'
				je startsystem
				cmp ah,'3'
				je clock
				cmp ah,'4'
				je hub
		hub:	jmp setclock
				
												
				
				






;===========================reboot pc========================================================


resetpc:
		jmp rebootstart

 		rebootdata: dw 0,0

 		rebootstart:mov ax,cs
 				mov ds,ax
 				mov ax,offset rebootdata
 				mov bx,ax
 				mov word ptr [bx],0000h
 				mov word ptr [bx].2,0ffffh
 				call dword ptr [bx]


;================================boot system from hard diskc=========================
startsystem:
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
				mov word ptr [bx],7c00h
				mov word ptr [bx].2,0
				call dword ptr [bx]
	

;==========================================display system clock====================================	
clock:

			jmp timestart
			massge: db 'the time is: besides f1 can change the color,press Esc to back to main menue ','$'
			timedata: db 0,0,'/',0,0,'/',0,0,' ',0,0,':',0,0,':',0,0,'$'

		
			
			timestart:mov di,0
				call clean
				mov dh,4
				mov dl,2
				mov si ,offset massge
				call display
			cicledistime:
				mov si,offset timedata
				mov ax,cs
				mov ds,ax

				
				mov ah,0
				mov al,9
				call get
				call tra
				call put

				mov al,8
				call get
				call tra
				call put

				mov al,7
				call get
				call tra
				call put

				mov al,4
				call get
				call tra
				call put

				mov al,2
				call get
				call tra
				call put

				mov al,0
				call get
				call tra
				call put


				

				mov si,offset timedata
				mov dh,6
				mov dl,20
				call display
				
				call isescf1
				
				jmp cicledistime
			    

			    



			get:
				out 70h,al
				in al,71h
			    ret     

			tra:mov ah,al
				mov cl,4
				shr ah,cl
				and al,00001111b
				add ah,30h
				add al,30h
				ret


			put:mov byte ptr [si],ah
				mov byte ptr [si].1,al
				inc si
				inc si
				inc si
				ret
			
			
;===================================set system timestart=======================

setclock:	jmp setclockstart
		
	displaydata:	db 'please set the time as the format YEAR/MONTH/DAY HOUR/MINUTE/second.and please input thne right time','$'	
	setdonedata:	db 'press esc to back main menue,f1 chenge color.the time has benn changed,the time you hava just modified is :','$'	
		
		setclockstart:
			

				mov si,offset displaydata
				mov dh,4
				mov dl,1
				call display
				call echostr
				

				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h									;write new data into cmos
				call tratobcd
				mov ah,9
				call writeto71


				
				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h
				call tratobcd
				mov ah,8
				call writeto71



				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h
				call tratobcd
				mov ah,7
				call writeto71


				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h
				call tratobcd
				mov ah,4
				call writeto71
				


				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h
				call tratobcd
				mov ah,2
				call writeto71


				call getinput
				sub al,30h
				mov ah,al
				call getinput
				sub al,30h
				call tratobcd
				mov ah,0
				call writeto71


	endinput:	call clean
				mov si,offset setdonedata
				mov dh,6
				mov dl,1
				call display
				mov si,offset datastack						;display the time user modified
				mov dh,8
				mov dl,20
		wait:	call display
				call isescf1
				jmp short wait
				


		getinput:
				mov al,ds:[bx]
				inc bx
				cmp al,'$'
				je endinput
				cmp al,30h
				jb getinput
		 		
				ret
				
		
		tratobcd:push dx
				push cx
				
				mov dl,al

				mov cl,4
				shl ah,cl 				 ;the hight part		
				add ah,dl				  ;store in al
				mov al,ah
				pop cx
				pop dx	 
				ret
		

		writeto71:
				push dx
				mov dl,al
				mov al,ah
				out 70h,al
				mov al,dl						;al set the port
				out 71h,al
				pop dx						;ah to store the bcd to write
			    ret     


;=================================is esc f1======================
 isescf1:
				mov ah,1
				int 16h
				cmp al,1bh						;is esc
				je backmain
				cmp ah,3bh						; is f1
				je colorchange
		backit:		
				ret



	backmain:	mov ah,0
				int 16h
				call clean
				jmp main

	colorchange: call colorchanges
				mov ah,0
				int 16h
				jmp backit


colorchanges:
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



;==================================clean screen function===========================================================
clean:
 				push ds 
	            push di
	            push es

	          
	            
	            mov ax,0b800h
	            mov es,ax
 			
              	 mov di,0
              	 mov cx,4000

	cleanloop:  
	            mov byte ptr es:[di],' '
	            inc di
	            inc di
	            
	            loop cleanloop

				pop es
	            pop di
	            pop ds
	            ret		



		



;=========================================display functoin,using si to set position of the content======================
display: 
	            push ds 
	            push di
	            push es

	            mov ax,cs
	            mov ds,ax
	            
	            mov ax,0b800h
	            mov es,ax
 	
                       
	          	mov al,dh					;dh set row
	          	mov dh,160					;dl set cloumn
	          	mul dh
	          	mov dh,0
	          	add dx,dx

	           	mov di,ax 
	            add di,dx
	            mov ah,1

	circlep:    mov al,ds:[si]
	            cmp al,'$'
	            je outprint
	            mov word ptr es:[di],ax
	            inc di
	            inc di
	            inc si
	            jmp circlep

	outprint:   pop es
	            pop di
	            pop ds
	            ret



;====================================echo string functoin========================================================



echostr:
    getstr:     push ax
                
    getstrs:    mov ah,0
                int 16h			
                cmp al,20h							;judage is a char
                jb nochar 
                mov ah,0
                call charstack    					  ;push into stack
                mov ah,2
                mov dh,8
                mov dl,1
                call charstack    					    ;echo the str
                jmp getstrs
                
    nochar:     cmp ah,0eh        						  ;is backspace
                je backspace
                cmp ah,1ch
                je enter            						;is enter
                jmp getstrs
                
    backspace:  mov ah,1
                call charstack
                mov ah,2
                mov dh,8
                mov dl,1
                call charstack
                jmp getstrs

    enter:      mov al,'$'
                mov ah,0
                call charstack
                mov ah,2
                mov dh,8
                mov dl,1
                call charstack
                pop ax
                
                mov bx,offset datastack
                ret        								;return the echostr caller!!!!!!!

           
                
    charstack:  jmp  charstart
    
    top dw offset datastack

    datastack: db 128 dup(0)

    charstart:  push bx
                push dx
                push si
                push es

                
                
                push ax
                mov ax,cs
                mov ds,ax
                pop ax

                cmp ah,2
                ja sret
                
                cmp ah,0
                je charpush
                cmp ah,1
                je charpop
                cmp ah,2
                je charshow


    charpush:   mov bx,top
                mov ds:[bx],al
                inc top
                jmp sret

    charpop:    cmp top,offset datastack
                je sret
                dec top
                mov bx,top
                mov al,[bx]
                jmp sret

               

    charshow:   mov bx,0b800h
                mov es,bx
                mov al,160
                mov ah,0
                mul dh
                mov di,ax
                add dl,dl
                mov dh,0
                add di,dx

                mov bx,offset datastack
        
    charshows:  cmp bx,top
                jne noempty
                mov byte ptr es:[di],' '
                jmp sret
    noempty:    mov al,ds:[bx]
                mov es:[di],al 
                mov byte ptr es:[di+2],' '
                inc bx
                add di,2
                jmp charshows

    sret:       pop es
                pop di
                pop dx
                pop bx
                ret

code ends
end start                