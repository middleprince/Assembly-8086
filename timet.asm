assume cs:code

code segment

clock:

            jmp timestart
            massge: db 'you can prees F1 to change the color or  Esc to back to main menue. the TIME is:','$'
            timedata: db 0,0,'/',0,0,'/',0,0,' ',0,0,':',0,0,':',0,0,'$'
            colordata:  db 2
        
            
            timestart:mov di,0
                ;call clean
                mov dh,4
                mov dl,1
                mov si ,offset massge
                mov ah,2
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


                
                mov bx,offset colordata
                mov ah,ds:[bx]

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
            
                ;jmp main
                mov ax,4c00h
                int 21h

    colorchange: call colorchanges
                mov ah,0
                int 16h
                
                
                jmp backit


colorchanges:   push bx
                push ds
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
                mov ax,cs
                mov ds,ax
                mov bx,offset colordata
                mov cl,es:[di-2]
                mov byte ptr ds:[bx],cl
               
                pop di
                pop es
                pop cx
                pop ds
                pop bx 
                

                ret




;=========================================display functoin,using si to set position of the content======================
display:        push dx
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



;========================delay=====================================

delay:          push ax
                push bx

                mov ax,0ff0fh
                mov bx,0ff0fh
    delayc1:    dec ax
                cmp ax,0
                je delayc2
                jmp delayc1

    delayc2:    dec bx
                cmp bx,0
                je enddelay
                jmp delayc2

    enddelay:   pop ax
                pop bx                      

                ret


code ends
end clock