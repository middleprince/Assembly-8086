
assume cs:code
code segment



setclock:   jmp setclockstart
        
    displaydata:    db 'please set the time as the format YEAR/MONTH/DAY HOUR/MINUTE/SECONED.and please input thne right time','$'  
    setdonedata:    db 'press ESC to back main menue, F1 chenge color.the time has benn changed,and the time you hava just modified is :','$'   
        
        setclockstart:
                ;call clean
                ;call cleandatastack

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
                sub al,30h                                  ;write new data into cmos
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


    endinput:   ;call clean
                mov si,offset setdonedata
                mov dh,6
                mov dl,3
                mov ah,2
                call display
                mov si,offset datastack2                     ;display the time user modified
                mov dh,8
                mov dl,20
                mov ah,7
                
    wait1:      call display
                
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
                shl ah,cl                ;the hight part        
                add ah,dl                 ;store in al
                mov al,ah
                pop cx
                pop dx   
                ret
        

        writeto71:
                push dx
                mov dl,al
                mov al,ah
                out 70h,al
                mov al,dl                       ;al set the port
                out 71h,al
                pop dx                      ;ah to store the bcd to write
                ret     




;====================================echo string functoin========================================================

            
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
    getstr2:    push ax
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
    

;======================display==============================



    display:    push dx
                push ds 
                push di
                push es
                push ax                         ;stroe the color
                mov ax,cs
                mov ds,ax
                
                mov ax,0b800h
                mov es,ax
    
                       
                mov al,dh                   ;dh set row
                mov dh,160                  ;dl set cloumn
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
       

;=================================is esc f1======================
 isescf1:       
                
                mov ah,1                        ;is content in keyboard buffer,return one content code
                int 16h
                cmp al,1bh                      ;is esc
                je backmain
                cmp ah,3bh                      ; is f1
                je colorchange
                cmp ah,1
                je backit
                mov ah,0
                int 16h
        backit: 
                
                ret



    backmain:   mov ah,0
                int 16h
                ;call clean
            
                mov ax,4c00h
                int 21h

    colorchange: call colorchanges
                mov ah,0
                int 16h
                mov ah,dl
                jmp backit


colorchanges:
                push cx
                push es
                push di
                

                mov cx,4000
                mov ax,0b800h
                mov es,ax
                mov di,1
                
    resetal:    mov byte ptr es:[di],1
            circle1:
                cmp byte ptr es:[di],7
                ja resetal

                inc byte ptr es:[di]
                inc di
                inc di
                loop circle1
                mov dl,es:[si]
                pop di
                pop es
                pop cx
                

                ret


code ends
end setclock                
    