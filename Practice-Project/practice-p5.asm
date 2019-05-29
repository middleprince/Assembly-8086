; 实践项目 5 
; 缩放显示菱形
assume cs:code 

;data segment
	;db 5 dup ('*')
;data ends

code segment
		start: mov ax,0b8a0h
		mov ds,ax

		mov bx,0040h
		;mov ax,data
		;mov es,ax

		mov al,'*'
		mov ah,4
		
		mov cx,2

	s1:	push cx
		mov si,0040h
		mov di,0040h
		call dis	
		call clean
		
		mov si,0042h
		mov di,0044h
		call dis
		call clean

		mov si,0044h
		mov di,0046h
		call dis
		call clean

		mov si,0046h
		mov di,0048h
		call dis
		call clean

		mov si,0044h
		mov di,0046h
		call dis
		call clean

		mov si,0042h
		mov di,0044h
		call dis
		call clean

		mov si,0040h
		mov di,0040h
		call dis
		call clean

		pop cx
		loop s1

		  mov ax,4c00h
		  int 21h

	dis: mov ah,4
	clea:mov [bx],ax
		 mov 0a0h.[si],ax
		 mov 1e0h.[si],ax
		 ;push si
		 mov bp,si
		 mov si,bx
		 add si,si
		 sub si,bp

		 mov 0a0h.[si],ax
		 mov 1e0h.[si],ax
		 
		 mov 140h.[di],ax
		; push di
		 mov bp,di
		 mov di,bx
		 add di,di
		 sub di,bp

		 mov 140h.[di],ax
		 mov [bx].280h,ax

		 ret

	clean: 

	 	  mov cx,0fffh
	    s: push cx
	    	mov cx,0ffh
	    s2:	nop
		  loop s2
		  pop cx
		  loop s

		  mov ah,0
		  call clea
		  
		  ret
	   

code ends
end start
