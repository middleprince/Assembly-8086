; 第五章 5.5 利用loop 改进程序。
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
start: mov cx,8
       mov bx,0
s:     mov ax,ds:[bx+100h]
       mov dx,ds:[bx+110h]
       add ax,dx
       mov ds:[bx+120h],ax
       inc bx
       loop s

       mov ax,4c00h
       int 21h
code ends
end start
       
