assume cs:test3
test3 segment
mov ax,0ffffh
mov ds,ax
mov bx,0
mov ax,0020h
mov es,ax

mov cx,8
s: mov al,ds:[bx]
   mov ah,0
   add ax,ax
   mov es:[bx],ax
   inc bx
   loop s
   mov ax,4c00h
   int 21h
tset3 ends
end
