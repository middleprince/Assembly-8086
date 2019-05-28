assume cs:code
code segment
    
     mov bx,0001h   
     loop s
     mov bx,0002h
     

     
  s:  mov ax,4c00h
     int 21h



code ends
end
