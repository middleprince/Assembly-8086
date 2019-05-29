; 课程实验项目 4-2 
; 找到屏幕中的字符 “a”将其改成闪烁红底黑字
assume cs:code

code segment     
          mov ax,0b800h
          mov ds,ax
     
          mov bx,0000h
          mov cx,84fh   ;1page
          
s:        mov dx,cx
          mov al,61h
          sub al,[bx]   ;is a
          mov ah,0
          
          mov cx,ax
          jcxz s1
          jmp s2
s1:		  mov al,84h
          mov [bx+1],al
         
          mov cx,dx
         
s2:       add bx,2
          loop s   

     mov ax,4c00h
     int 21h

code ends
end 
