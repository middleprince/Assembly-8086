; 实验 5-5
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
start: mov ax,a
       mov ds,ax
       mov ax,b
       mov es,ax
       mov ax,c
       mov ss,ax
       mov sp,8h
       mov bx,0h
       mov cx,4h
s:     mov al,ds:[bx]
       add al,es:[bx]
       inc bx
       mov ah,ds:[bx]
       add ah,es:[bx]
       push ax
       inc bx
       loop s
code ends
end start
       
