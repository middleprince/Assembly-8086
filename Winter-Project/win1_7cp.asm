assume cs:code  
  
data segment  
    db '.....*........*.......'  
    db '....*..*.....*.*......'    
    db '.....*..*....*..*.....'    
    db '......*..*..*.*.*.....'    
    db '.....*.........*......'    
    db '...*.............*....'    
    db '..*...............*...'  
    db '.*.................*..'    
    db '*...................*.'    
    db '*...................*.'    
    db '*.....*.......*.....*.'    
    db '*...................*.'    
    db '*...@.....U.....@...*.'    
    db '.*.................*..'    
    db '..**.............**...' ;15��22��  
data ends  
  
stack segment  
    dw 0,0,0,0,0,0,0,0  
stack ends  
  
code segment  
start:  
    mov ax, data  
    mov ds, ax  
    mov bx, 0  
  
    mov ax, 0b800h  
    mov es, ax  
    mov bp, 140h  
    mov si, 0  
  
    mov ax, stack  
    mov ss, ax  
    mov sp, 10h  
  
    mov cx, 15 ;���Ƚ�ͼ��������ȥ  
l1:  
    push cx  
    mov cx, 22  
    mov si, 0  
    add bp, 0a0h  
l2:  
    mov al, [bx]  
    mov ah, 00000111b  
    mov es:[bp + si], ax  
    add si, 2  
    inc bx  
    loop l2  
    pop cx  
    loop l1       
  
blink:          ;���ƻ��Ƶ�ͼ����˸  
    mov dh, 00000001b ;�����ַ������ԣ���ѭ�������н������ε���  
    mov cx, 5 ;��ɫ5�α仯һ���ֻ�  
l3:  
    push cx  
    mov bx, 1  
    mov bp, 140h  
    mov cx, 15  
l4:  
    push cx  
    add bp, 0a0h  
    mov si, 1  
    mov cx, 22  
l5:  
    push cx  
    mov es:[bp + si], dh  
    add si, 2  
    pop cx  
    loop l5  
    pop cx  
    loop l4  
    call sleep  
    inc dh  
    pop cx  
    loop l3  
    jmp blink  
  
    mov ax, 4c00h  
    int 21h  
  
sleep:  
    mov cx,0fffh  ;ע�⣺�ı��cxֵ�ɸı���ʱ��ʱ�䳤��  
s0: push cx  
    mov cx,000ffh  
s1: loop s1  
    pop cx  
    loop s0  
    ret  
  
code ends  
end start  