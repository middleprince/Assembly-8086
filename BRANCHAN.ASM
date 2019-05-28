assume cs:code
code segment

   mov cx,ax
   sub ax,1
   sub cx,ax

   mov bx,0001
   loop s
   mov bx,0002h
   s:  mov ax,4c00h
     int 21h
code ends
end
