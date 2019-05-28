;sovle the problem about overfloating in dividing. 

assume cs:code

data segment
	dw 8 dup(0)
data ends

code segment			 ;m/n = int(h/n)*65536 + (em(h/n)*65536+l)/n

start:	mov ax,4240h     ;ax store the low part of the dividend,and the dx store the high .
	mov dx,000fh         
	mov cx,000ah   		 ;cx,store the divisor.
	call divdw			 ;!the final anwser,whuich the high part of quotient is stored in dx,low part of in ax,and the remainder will stroe in cx.
	
	
	mov ax,4c00h
	int 21h
	
divdw:	mov bx,data
	mov ds,bx
	mov ds:[0],ax	;store the low part of the 
	mov ax,dx
	mov dx,0h
	div cx          
	mov ds:[2],dx	;store the remiander of high int
	mov ds:[4],ax
	

	mov dx,ds:[2]
	mov ax,ds:[0]
	
	
	div cx			;calculate [em(h/n)*65535+l]/n part
	
	mov cx,dx
	mov dx,ds:[4]  	;store the quotient hingh part in dx,low part in ax,and reaminder in cx.
	
	ret	
	
code ends	
end start