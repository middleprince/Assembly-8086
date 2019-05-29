assume cs:code  
data segment  
    db 'h12E332l@L#O*&^!88nI@cE$% %$T1O m33E44E55t y77O88u!()'  
    db '?'  
data ends  
  
code segment  
start:  
    mov ax, data  
    mov ds, ax  
    mov ax, 0b800h  
    mov es, ax  
    mov bx, 0  
    mov bp, 140h        ;ds:[bx], es:[bp]  
    mov si, 0  
    mov cx, 1       ;cx=1代表需要转换成大写  
mainLoop:  
    mov al, [bx]  
    mov ah, 0  
    cmp ax, '?'  
    je break  
  
    cmp ax, '!'  
    je reset        ;如果是！，需要重新将cx置为1  
    cmp ax, ' '  
    je moveData  
  
    cmp ax, 'A'  
    jb clearData  
    cmp ax, 'Z'  
    ja judgeSmall  
    jcxz toSmall  
    jmp next  
toSmall:  
    add ax, 20h  
next:  
    mov cx, 0  
    jmp moveData  
judgeSmall:  
    cmp ax, 'a'  
    jb clearData  
    cmp ax, 'z'  
    ja clearData  
    jcxz no  
    sub ax, 20h  
    mov cx, 0  
no: jmp moveData  
  
    inc bx  
    jmp mainLoop  
break:  
    mov ax, 4c00h  
    int 21h  
  
reset:  
    mov cx, 1  
    jmp moveData  
moveData:  
    mov byte ptr [bx], 0  
    mov byte ptr ds:[si], al  
    mov ah, 01110001b  
    call print  
    inc bx  
    inc si  
    jmp mainLoop  
clearData:  
    mov byte ptr [bx], 0  
    inc bx  
    jmp mainLoop  
print:  
    mov es:[bp], ax  
    add bp, 2  
    ret  
  
code ends  
end start  