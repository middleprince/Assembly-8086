assume cs:code
code segment

   mov ax,0b890h
   mov ds,ax  
   mov bx,0198h
   mov ax,0020h
   mov ss,ax
   mov sp,0010h
   mov cx,008fh

s: push cx
   mov ax,0a41h
   mov ds:[bx],ax

   mov cx,0500h
   

s1: push cx
    mov ax,0h
    mov cx,00ffh
s2: mov ax,0h
    loop s2
    pop cx
    loop s1

    mov ds:[bx],ax
    sub bx,1h
    sub bx,1h
    pop cx
    loop s
    mov ax,0a41h
    mov ds:[bx],ax

    mov ax,4c00h
    int 21h

code ends
end   
          
