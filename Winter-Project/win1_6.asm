assume cs:code  
  
data segment  
     DB  000H,000H,000H,000H,030H,000H,000H,03CH,000H,000H,038H,000H,000H,038H,000H,000H  
     DB  038H,000H,038H,038H,01CH,03FH,0FFH,0FCH,018H,038H,038H,018H,038H,038H,018H,038H  
     DB  038H,018H,038H,038H,018H,038H,038H,018H,038H,038H,03FH,0FFH,0F8H,038H,038H,038H  
     DB  000H,038H,000H,000H,038H,000H,000H,038H,000H,000H,038H,000H,000H,038H,000H,000H  
     DB  038H,000H,000H,038H,000H,000H,000H,000H   
  
     DB  000H,000H,000H,000H,008H,000H,003H,08EH,000H,003H,0CCH,018H,007H,00CH,03CH,00EH  
     DB  00CH,0FCH,00FH,00DH,0E0H,01FH,00FH,080H,03FH,00EH,00CH,077H,03CH,00CH,067H,0ECH  
     DB  00EH,007H,08CH,00EH,007H,00FH,0FEH,007H,038H,000H,000H,03CH,000H,000H,038H,00CH  
     DB  0FFH,0FFH,0FEH,000H,038H,003H,000H,038H,000H,000H,038H,000H,000H,038H,000H,000H  
     DB  038H,000H,000H,038H,000H,000H,000H,000H  
data ends  
  
stack segment  
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  
stack ends  
  
code segment  
start:  
    mov ax, data  
    mov ds, ax  
    mov bx, 0  
  
    mov ax, stack  
    mov ss, ax  
    mov sp, 40h  
  
    mov ax, 0b800h  
    mov es, ax  
    mov bp, 140h  
    mov si, 0  
      
    ;打印“中”,注意点阵是24*24，所以应该是6个字节，但是最外层的循环还是24  
    mov cx, 24  
l1:  
    push cx  
    mov si, 0  
    mov cx, 3  
l2:  
    push cx  
    mov al, [bx]  
    mov ah, 0  
    mov di, 0  
    call printByte ;打印ax中的一个字节内容，注意先化成二进制  
    inc bx  
    pop cx  
    loop l2  
    add bp, 0a0h ;换行  
    pop cx  
    loop l1  
  
    ;打印“华”  
    mov bp, 140h  
    mov cx, 24  
l5:  
    push cx  
    mov si, 50  
    mov cx, 3  
l6:  
    push cx  
    mov al, [bx]  
    mov ah, 0  
    mov di, 0  
    call printByte ;打印ax中的一个字节内容，注意先化成二进制  
    inc bx  
    pop cx  
    loop l6  
    add bp, 0a0h ;换行  
    pop cx  
    loop l5  
  
      
    mov ax, 4c00h  
    int 21h  
  
printByte:  
    mov cx, 8  
l3:  
    mov dl, 2  
    div dl  
    mov dl, al  
    mov dh, 0  
    mov al, ah  
    mov ah, 0  
    push ax  
    mov ax, dx  
    loop l3  
  
    mov cx, 8   ;先解码成8位二进制数字  
l4:  
    pop ax  
    call printBit  
    loop l4  
    ret  
  
printBit:  
    cmp ax, 1  
    je ok  
    mov dl, 20h  
    mov dh, 04h  
    jmp exit  
ok: mov dl, 2ah  
    mov dh, 04h  
exit:  
    mov es:[bp + si], dx  
    add si, 2  
    ret  
code ends  
end start  