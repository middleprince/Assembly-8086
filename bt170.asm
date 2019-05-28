;17 charpter test use int13h to write or read the solft disk
assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
    start:mov ax,stack
    mov ss,ax
    mov sp,128

    push cs
    pop ds 

    mov ax,0
    mov es,ax
    
    mov si,offset rwflappybegain
    mov di,204h
    mov cx,offset rwflappyend-offset rwflappybegain
    cld
    rep movsb



    cli                                 ;set if =1
    mov word ptr es:[7ch*4],204h
    mov word ptr es:[7ch*4].2,0
    sti


    mov ax,4c00h
    int 21h

    rwflappybegain:push dx
    push ax
    push es
    push bx

    mov dx,4
    mov ax,0b8ffh
    mov es,ax
    mov bx,0

    call trasfer
    mov ah,2
    mov al,8
    mov dl,0
    int 13h

    pop bx
    pop es
    pop ax
    pop dx

   iret
trasfer:push ax
     

    mov ax,dx                 ;logic section 
    mov dx,0
    mov cx,1440
    div cx
    mov dh,al               ;面号

    mov ax,dx
    mov cl,18
    div cl                  ;磁道号
    mov ch,al

    add ah,1
    mov cl,ah               ;扇区号 

   
    pop ax

    ret

rwflappyend:nop  

code ends
end start