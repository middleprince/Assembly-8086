; 实践课程 4-4
; 解决(1+2+3+4+...+n)>122 时的第一个 n 是多少?
assume cs:code

data segment
dw 0,0
data ends 

code segment
start:	mov ax,data
        mov ds,ax
    
        
        mov ax,0001h
		mov cx,100
        
        mov bp,ax
s:		mov dx,cx
        add bp,0001h
        add ax,bp	;SUM	

        mov bx,ax
        sub bx,122
        and bx,1111111111111111b
        mov bl,0
        
        mov cx,bx
        jcxz o
        mov cx,dx
        loop s

o:      mov ds:[0],bp
        mov ds:[2],ax               

		mov ax,4c00h
		int 21h
		
code ends
end start 