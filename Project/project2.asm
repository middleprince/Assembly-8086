; 课程设计 2 
; 通过BIOS 实现基本的读写，实现以下功能：
; (1).the functoins list
;  1. reboot system
;  2. boot system
;  3. clock
;  4. set clock
; (2) when user input "1", reboot system.
; (3) when user input "2" boot the system.
; (4) when user input "3" display the time on system.

code segment
assume cs:code
			start:

		    mov bx,loadcode
		    mov es,bx
		    mov bx,0

		    mov ah,3
		    mov al,1						; unmber of selecter change it later 
		    mov dl,0
		    mov dh,0
		    mov cl,1
		    mov ch,0

		    int 13h
   
		    mov bx,functionmain		;load the functon code into flopy where the cl from 2-16
		    mov es,bx
		    mov bx,0

		    mov ah,3
		    mov al,18						; unmber of selecter change it later 
		    mov dl,0
		    mov dh,1
		    mov cl,1
		    mov ch,1

		    int 13h

		    mov ax,4c00h
		    int 21h

code ends

loadcode segment
assume cs:loadcode

			mov bx,0h							;load the functon code into flopy where the cl from 2-16
		    mov ax,2000h						;set the address to run the function code
		    mov es,ax
		
		    mov ah,2
		    mov al,18						; unmber of selecter change it later 
		    mov dl,0
		    mov dh,1
		    mov cl,1
		    mov ch,1

		    int 13h

		    mov ax,2000h
		    push ax
			mov ax,0
			push ax
			retf
	    
loadcode ends

;=====================================the main menue============================
functionmain segment
assume cs:functionmain
main:
		
		jmp maincodestart
		dis:	db 'input the NUMBER to select the function and prees ENTER to  run it','$'
		dis1:	db '1) reset pc.','$'
		dis2:	db '2) start system.','$'
		dis3:	db '3) show system time.','$'
		dis4:	db '4) reset clock.','$'
		range:	dw 	offset dis1,offset dis2 ,offset dis3 ,offset dis4  
		maincodestart:

				mov ax,cs
				mov ds,ax

				mov bx,offset range
				
				mov si,offset dis
				mov dh,1
				mov dl,2
				mov ah,2					;brground blue ,forground white
				call display 						;display menue

				mov dh,4
				mov dl,5
				mov ah,2
				mov cx,4
		maincircle:
				mov si,[bx]
				call display
				inc bx
				inc bx
				inc dh
				loop maincircle

				mov ax,offset datastack
				call cleandatastack
				
				mov ax,offset dataflush
				call cleandatastack
				
				nextstep:
				call echostr	  				;using echostr to select the function
				mov ah,ds:[bx]
				
				cmp ah,'1'
				jb gomain

				cmp ah,'4'
				ja gomain


				cmp ah,'1'
				je resetpc
				cmp ah,'2'
				je startsystem
				cmp ah,'3'
				je clock
				cmp ah,'4'
				je hub
		hub:	jmp setclock
				
		gomain:jmp main						
				
				

;===========================reboot pc========================================================

resetpc:
				mov ax,0ffffh
				push ax
				mov ax,0
				push ax
				retf
			
;================================boot system from hard diskc=========================
startsystem:
		
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

				mov ax,0
				push ax
				mov ax,7c00h
				push ax
				retf

	
;==========================================display system clock====================================	
clock:

			jmp timestart
			massge: db 'you can prees F1 to change the color or  Esc to back to main menue. the TIME is:','$'
			timedata: db 0,0,'/',0,0,'/',0,0,' ',0,0,':',0,0,':',0,0,'$'
			colordata:	db 2
		
			
			timestart:mov di,0
				call clean
				
				mov dh,4
				mov dl,1
				mov si ,offset massge
				mov ah,2
				call display
			
			circledistime:
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

				
				mov bx,offset colordata
				mov ah,ds:[bx]

				mov si,offset timedata
				mov dh,6
				mov dl,20
			
				call display
				
				call isescf1

				
				jmp circledistime
		
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
		
	displaydata:	db 'please set the time as the format YEAR/MONTH/DAY HOUR/MINUTE/SECONED.and please input thne right time','$'	
	setdonedata:	db 'press ESC to back main menue, F1 chenge color.the time has benn changed,and the time you hava just modified is :','$'	
		
		setclockstart:
				call clean
				mov ax,offset datastack
				call cleandatastack
				mov ax,offset dataflush
				call cleandatastack

				mov si,offset displaydata
				mov dh,4
				mov dl,3
				mov ah,2
				call display

				;call isescf1
				

				call echostr2
				

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
				mov dl,3
				mov ah,2
				call display
				mov si,offset datastack2						;display the time user modified
				mov dh,8
				mov dl,20
				mov ah,7
				
	wait1:		call display
	   			
	   			call isescf1
	   
				jmp short wait1
							


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
 				
				mov ah,1						;is content in keyboard buffer,return one content code
				int 16h
				cmp al,1bh						;is esc
				je backmain
				cmp ah,3bh						; is f1
				je colorchange
				cmp ah,1
				je backit
				mov ah,0
				int 16h
		
		backit:	
				
				ret


	backmain:	mov ah,0
			    int 16h
				call clean
				
				jmp main

	colorchange:call colorchanges
				mov ah,0
				int 16h
				
				jmp backit

colorchanges:	push ax
				push bx
				push ds
				push es
				push di
				push cx

				mov cx,4000
				mov ax,0b800h
				mov es,ax
				mov di,1
				
	resetal:	mov byte ptr es:[di],1
			circle1:
				cmp byte ptr es:[di],7
				ja resetal

				inc byte ptr es:[di]
				inc di
				inc di
				loop circle1
				
				mov ax,cs
				mov ds,ax
				mov cl,es:[di-2]
				mov bx,offset colordata
				mov byte ptr ds:[bx],cl
				
				pop cx
				pop di
				pop es
				pop ds
				pop bx
				pop ax
			
				ret

;========================delay=====================================

delay:			push ax
				push bx
				push dx

				mov ax,0ff0fh
				mov bx,0ff0fh
				mov dx,0fffh
	delayc1:	dec ax
				cmp ax,0
				je delayc2
				jmp delayc1

	delayc2:	dec bx
				cmp bx,0
				je delayc3
				jmp delayc2

	delayc3:	dec dx
				cmp dx,0
				je enddelay
				jmp delayc2

	enddelay:	pop dx
				pop bx
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
              	mov al,' '
              	mov ah,7
              	mov cx,4000

	cleanloop:  
	            mov word ptr es:[di],ax
	            inc di
	            inc di
	            
	            loop cleanloop

				pop es
	            pop di
	            pop ds
	            ret		

;========================================clean datastack=============================================

cleandatastack:	
				push cx
				push ax
				push ds
				push si
				push ax

				mov ax,cs
				mov ds,ax
				pop si
				
				mov cx,64

				cleandatastackcicle:
				mov byte ptr ds:[si],0
				inc si
				loop cleandatastackcicle
				

				pop si 
				pop ds
				pop	ax
				pop	cx
				ret


;=========================================display functoin,using si to set position of the content======================
display: 		push dx
	            push ds 
	            push di
	            push es
	            
	            push ax							;stroe the color
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

	            pop ax
	            
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
	            pop dx
	            ret

;====================================echo string functoin========================================================

    charstack:	jmp charstart

    	top dw offset datastack
    	datastack: db 64 dup(0)

    charstart: 
    			push bx
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

    charpush:   cmp top,offset datastack+64
    			je resettop
    			mov bx,top
                mov ds:[bx],al
                inc top
                jmp sret

    resettop:	mov top,offset datastack
    			jmp charpush         

    charpop:    cmp top,offset datastack
                je sret
                dec top
                mov bx,top
                mov al,[bx]
                mov byte ptr [bx],0
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

    sret:      
    			pop es
                pop di
                pop dx
                pop bx
                ret

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
                mov top,offset datastack
                mov bx,offset datastack
                ret        								;return the echostr caller!!!!!!!

;====================================set time echo string functoin========================================================

    charstack2:	jmp charstart2

    	top2 dw offset dataflush
    	datastack2: db ' ',' ','/',' ',' ','/',' ',' ',' ',' ',' ',':',' ',' ',':',' ',' ','$'
        datafomat:  db ' ',' ','/',' ',' ','/',' ',' ',' ',' ',' ',':',' ',' ',':',' ',' ','$'
        dataflush:  db 64 dup(0)
    
    charstart2: 
    			push bx
                push dx
                push si
                push es

                push ax
                mov ax,cs
                mov ds,ax
                pop ax

                cmp ah,2
                ja sret2
                
                cmp ah,0
                je charpush2
                cmp ah,1
                je charpop2
                cmp ah,2
                je charshow2

    charpush2:  mov bx,top2
                mov ds:[bx],al
                inc top2
                jmp sret2

    charpop2:   cmp top2,offset dataflush
                je sret2
                dec top2
                mov bx,top2
                mov al,[bx]
                mov word ptr [bx],0

                mov di,offset datafomat
                mov bx,offset datastack2
                mov cx,18
    format:     mov al,ds:[di]
                mov ds:[bx],al
                
                inc bx
                inc di
                loop format   
                jmp sret2
               
    charshow2:  mov si,offset datastack2

                mov bx,offset dataflush
        
    charshows2: mov cx,6
                cmp bx,top2
                jne noempty2
                jmp sret2
                
    noempty2:   mov al,ds:[bx]
                mov ds:[si],al
                inc bx
                inc si
                
                mov al,ds:[bx]
                mov ds:[si],al
                inc si
                inc si
                inc bx

                loop noempty2
               
                mov ah,2
                mov si,offset datastack2
                call display

    sret2:      
    			pop es
                pop di
                pop dx
                pop bx
                ret
echostr2:  
    getstr2:    mov di,offset datafomat
                mov bx,offset datastack2				;clean format
                mov cx,18
    format2:    mov al,ds:[di]
                mov ds:[bx],al
                
                inc bx
                inc di
                loop format2   

    			push ax
                mov ah,2
                mov dh,8
                mov ah,5
                mov si,offset datastack2
                call display
    
                ;call isescf1

    getstrs2:   mov ah,0
                int 16h			
                cmp al,20h							;judage is a char
                jb nochar2 
                mov ah,0
                call charstack2   					  ;push into stack
                mov ah,2
                mov dh,8
                mov dl,5
                call charstack2    					    ;echo the str
                jmp getstrs2
                
    nochar2:    cmp ah,0eh        						  ;is backspace
                je backspace2
                cmp ah,1ch
                je enter2            						;is enter
                jmp getstrs2
                
    backspace2: mov ah,1
                call charstack2
                mov ah,2
                mov dh,8
                mov dl,5
                call charstack2
                jmp getstrs2

    enter2:     mov al,'$'
                mov ah,0
                call charstack2
                mov ah,2
                mov dh,8
                mov dl,5
                
                call charstack2
                pop ax
                mov top2,offset dataflush
                mov bx,offset dataflush
                ret        								;return the echostr caller!!!!!!!
    
functionmain ends               
end start                