; 书中问题 7.9
; 实现大小写转换
assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
  dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
    db '1. HeBEInOn     '
    db '2. GYeDAxUe     '
    db '3. DAAsSemB     '
    db '4. LylaNGuAGE   '
datasg ends

codesg segment
   start: mov ax,stacksg
          mov ss,ax
          mov sp,16
          mov ax,datasg
          mov ds,ax
          mov bx,0

          mov cx,4
s0:       push cx
          mov si,3
          mov cx,10

          

s:       push cx

         mov al,[bx+si]
         and al,00100000b
         mov ah,0h
         add ax,1h
         mov cx,ax ;char n,capital 1



         mov al,[bx+si]
         and al,11011111b ;char to capital
        
         loop s1
         or al,00100000b ;capital t0 char  
         
  s1:    mov [bx+si],al
         inc si
         pop cx
         loop s

          add bx,16
          pop cx
          loop s0

         mov ax,4c00h
         int 21h
codesg ends
end start
