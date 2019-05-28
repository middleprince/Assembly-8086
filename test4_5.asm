assume cs:code

data segment
     db 'welcome to masm!'
data ends

code segment
 start:   mov ax,0b800h
    mov ds,ax
    mov bx,6h
    
    mov ax,data
    mov es,ax
    mov di,0
    mov cx,16
    
s:  mov al,es:[di]  
    mov [bx],al
    
    inc di
    add bx,2
    loop s
    
    mov cx,100
    
c:  mov dx,cx
    mov cx,16
    mov bx,6

    
s1: mov al,10
    mov [bx].1,al
    add bx,2
    loop s1
    

    mov cx,0ffffh
d:  add cx,0
    loop d
    
    
    mov cx,16
    mov bx,6    

s2: mov al,12
    mov [bx].1,al
    add bx,2
    loop s2
    
    
    mov cx,0ffffh
d1:  add cx,0
    loop d1
    	
    mov cx,dx
    
    loop c 
    
    mov ax,4c00h
    int 21h
 code ends
 end start   