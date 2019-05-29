assume cs:exam
exam segment
  mov ax,0020h
  mov ds,ax
  mov cx,8h

 s: mov dx,cx
    mov ax,0fh

    mov cx,ax

    mov ax,0h
    mov bx,ax

s1: mov ds:[bx],ax
    inc bx
    loop s1

    mov ax,ds
    sub ax,0020h
    mov bx,7h
    sub bx,ax
    add ax,1
    add ax,ax
    sub ax,1
    mov cx,ax
    mov ax,2ah

s2: mov ds:[bx],ax
    inc bx
    loop s2

    mov ax,ds
    add ax,1
    mov ds,ax
    mov cx,dx
loop s
    mov ax,4c00h
    int 21h
exam ends
end

