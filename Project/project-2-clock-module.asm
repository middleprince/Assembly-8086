; 项目 2 ，时种显示模块 system Clock Display and Set module
; 
assume		cs:code

code segment
start:

setclock:	jmp setclockstart
	displaydata:	db'please set the time as the format year/month/day hour/minute/seconed.and year arry from 0 to 99.','$'	
	setdonedata:	db 'the time has benn changed,the new time is :','$'	
		
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
				sub al,30h
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

	endinput:	mov si,offset setdonedata
				mov dh,6
				mov dl,1
				call display
				mov si,offset datastack
				mov dh,8
				mov dl,20
				call display
				
				mov ax,4c00h
				int 21h
				
		getinput:
				mov al,ds:[bx]
				
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
		
display: 
            push ds 
            push di
            push es
            
            mov ax,cs
            mov ds,ax 
            mov ax,0b800h
            mov es,ax
                       
          	mov al,dh
          	mov dh,160					;cloumn
          	mul dh
          	mov dh,0
          	add dx,dx

           	mov di,ax 
            add di,dx
             

circlep:     mov al,ds:[si]
            cmp al,'$'
            je outprint
            mov es:[di],ax
            inc di
            inc di
            inc si
            jmp circlep

outprint:   
			pop es
            pop di
            pop ds
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
                mov dh,7
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
                mov dh,7
                mov dl,1
                call charstack
                jmp getstrs

    enter:      mov al,'$'
                mov ah,0
                call charstack
                mov ah,2
                mov dh,7
                mov dl,1
                call charstack

                mov ax,cs
                mov ds,ax
                mov bx,offset datastack
                pop ax

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