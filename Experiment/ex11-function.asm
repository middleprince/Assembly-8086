; 实验 11-function 
; 功能测试模块，通过普通操作实现标志寄存器的置位
;user normal calculate to set the SF=1  OF=0  CF=1 
;user normal calculate to set the SF=1  OF=1 CF=1 

assume cs:code
code segment
	  start: ;mov ax,0000000010000000b       		;first 1 0 1 using divied ,that's meaning using a negtive number be divide,and a smaller positiv divisor
		  	;push ax					;-80/4
		  	;popf
		  	sub al,al
		  	mov al,11111110b  	;a big negtive number sub a smaller positive number
		  	sub al,00000001b

			mov al,11000000b	;two big enough number add each other.
			add al,01000000b  	
		  	
		  	mov ax,4c00h
		  	int 21h
code ends
end start
