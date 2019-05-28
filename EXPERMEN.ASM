assume cs:code

a segment
    db 1,2,3,4,5,6,7,8
a ends

b segment
    db 1,2,3,4,5,6,7,8
b ends

c segment
    db 0,0,0,0,0,0,0,0
c ends

code segment
start: mov cx,8h
       mov bx,0h

s:     mov ax,ds:[bx+10h]
       mov dx,ds:[10h+bx]
       add ax,dx
       mov ds:[bx+10h],ax
       inc bx
       
       loop s

    mov ax,4c00h
    int 21h

code ends
end start
