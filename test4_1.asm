assume cs:code

a segment
	dd 0123h,0456h,0789h,0abch
a ends

b segment
	dw 10h,20h,10h,20h
b ends

c segment
	dw 0,0,0,0
c ends

code segment
s:
start: mov ax,a
       mov ds,ax
       
       mov ax,b
       mov es,ax
       
       mov ax,c
       mov ss,ax
       
       mov bx,0
       ;mov di,0
       ;mov bp,0
       
       mov cx,4
       
       mov ax,[bx]
       mov dx,[bx].2 
       
       div word ptr,es:[bx]
       mov ss:[bx],ax
       inc bx
       
       loop s
       
       mov ax,4c00h
       int 21h

code ends
end start    