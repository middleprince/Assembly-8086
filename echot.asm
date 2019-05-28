;using int16h to display the ceontent you intputed to the screen 
assume cs:code

code segment
    start:jmp rstart
    test1: db 0,0,'$'
    rstart:call getstr
    call getinput
    push ax
    mov ax,offset test1
    mov si,ax
    pop ax
    mov cs:[si],al
    call getinput
    mov cs:[si].1,al
    mov si,offset test1
endi:
    call display



                mov ax,4c00h
                int 21h

           


    getstr:     push ax
                
    getstrs:    mov ah,0
                int 16h
                cmp al,20h        ;judage is a char
                jb nochar 
                mov ah,0
                call charstack      ;push into stack
                mov ah,2
                mov dh,4
                mov dl,1
                call charstack        ;echo the str
                jmp getstrs
                
    nochar:     cmp ah,0eh          ;is backspace
                je backspace
                cmp ah,1ch
                je enter            ;is enter
                jmp getstrs
                
    backspace:  mov ah,1
                call charstack
                mov ah,2
                mov dh,4
                mov dl,1
                call charstack
                jmp getstrs

    enter:      mov al,'$'
                mov ah,0
                call charstack
                mov ah,2
                mov dh,4
                mov dl,1
                call charstack
                mov ax,offset datastack
                mov bx,ax
                pop ax
                
                ret
                
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
 


 display: 
            push ds 
            push di
            push es

            mov ax,cs
            mov ds,ax
            
            mov ax,0b800h
            mov es,ax
            mov di,160*4+40*2
            mov ah,1

circlep:     mov al,ds:[si]
            cmp al,'$'
            je outprint
            mov es:[di],ax
            inc di
            inc di
            inc si
            jmp circlep

outprint:   pop es
            pop di
            pop ds
            ret

          getinput:
                mov al,ds:[bx]
                inc bx
                cmp al,'$'
                je endinput
                cmp al,30h

                jb getinput
                
                ret
                endinput:jmp endi
                
      
                
code ends
end start
