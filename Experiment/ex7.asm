; 实验 7
assume cs:codeseg

data segment
  db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
  db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
  db '1993','1994','1995'
  
  dd 16,22,383,1356,2390,8000,16000,24486,50065,97479,140417,197514
  dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
  
  dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,86
  dw 1511,14430,15257,17800
  
data ends

table segment
  
  db 21 dup('year sumn ne ?? ')

table ends

codeseg segment

  start: mov ax,data
         mov es,ax
         mov ax,table
         mov ds,ax
         
        
         
         mov bx,0
         mov si,0
         mov di,0
         mov cx,21 
         mov ax,0
        
s:       add bx,ax
               
         mov ax,es:[si]
         mov [bx].0,ax  ;放年份
         mov ax,es:[si].2
         mov [bx].2,ax ;放入年份高位
         
         mov ax,es:[di].168
         mov [bx].10,ax  ;放雇员
         
         mov ax,es:[si].84
         mov [bx].5,ax  ;放收入，低位
         
         mov dx,es:[si].86
         mov [bx].7,dx    ;放收入，高位
         
         div word ptr [bx].0ah ;算人均收入
         
         mov [bx].0dh,ax  ;放入收入
         
         add si,4
         add di,2
         mov ax,10h
        loop s
        
        mov ax,4c00h
        int 21h
             
codeseg ends
end start     
         
         
         