assume cs:code

data segment

 dd 12345678
 dw 1234
data ends

code segment
start: mov ax,data
       mov ds,ax
       mov ax,ds:[0]
       mov dx,ds:[2]
       div word ptr ds:[4]

       mov ax,4c00h
       int 21h
 code ends
 end start

