assume cs:exam
exam segment
   mov ax,0020h
   mov ds,ax
   mov cx,8h

s: mov dx,cx
   mov ax,ds
   sub ax,0020h

   mov bx,7h
   sub bx,ax

   add ax,1h
   add ax,ax
   sub ax,1h
   mov cx,ax

s1: mov ax,2ah
    mov ds:[bx],ax
    inc bx
    loop s1

   mov ax,ds
   add ax,1
   mov ds,ax
   mov cx,dx
   loop s

   mov ax,4c00h
   int 21h
exam ends
end
