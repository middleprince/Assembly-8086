assume cs:exam
exam segment

    mov ax,0020h
    mov ds,ax

    mov ax,0029h
    mov ss,ax
    mov sp,0010h
    mov cx,8h
s:  push cx
    mov cx,0fh
    mov bx,0h
    mov al,0h
s1: mov ds:[bx],al
    inc bx
    loop s1

    mov ax,ds
    sub ax,0020h

    mov bx,0007h
    sub bx,ax

    add ax,0001h
    add ax,ax
    sub ax,1
    mov cx,ax
    mov al,2ah
s2: mov ds:[bx],al
    inc bx
    loop s2

    mov ax,ds
    add ax,1
    mov ds,ax
    pop cx

    mov ax,4c00h
    int 21h
exam ends
end
