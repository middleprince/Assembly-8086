; 实验 16 实现含有多个功能的子程序中断
; 功能： 1.清屏  2. 设置前景色 3. 设置背景色  4. 向上滚动一行
;bt16

assume cs:code

stack segment
	db 128 dup (0)
stack ends

code segment
start:mov ax,stack
	mov ss,ax
	mov sp,128

	push cs
	pop ds 

	mov ax,0
	mov es,ax

	mov si,offset subbegain
	mov di,204h
	mov cx,offset subend-offset subbegain
	cld
	rep movsb
	
	
	cli     							;set if =1
	mov word ptr es:[7ch*4],204h
	mov word ptr es:[7ch*4].2,0
	sti

	mov ax,4c00h
	int 21h

	subbegain:
	
	setscreen:jmp short set

	 dw  sub1-subbegain+0204h,sub2-subbegain+0204h,sub3-subbegain+0204h,sub4-subbegain+0204h

	set:push bx

		cmp ah,3
		ja sret
		 
		mov bl,ah
		mov bh,0
		add bx,bx

		call word ptr cs:[bx+206h]				
	sret:
		pop bx
		iret

	sub1:push bx
		 push cx
		 push es
		 mov bx,0b800h
		 mov es,bx
		 mov bx,0
		 mov cx,2000

	sub1s:mov byte ptr es:[bx],' '
		add bx,2
		loop sub1s
		pop es
		pop cx
		pop bx
		ret

	sub2:push bx
		 push cx
		 push es
		 
		 mov bx,0b800h
		 mov es,bx
		 mov bx,1
		 mov cx,2000

	sub2s:and byte ptr es:[bx],11111000b		;modify the forground color
		or es:[bx],al
		add bx,2
		loop sub2s

		pop es
		pop cx
		pop bx
		ret

	sub3:push bx
		push cx
		push es
		mov cl,4
		shl al,cl
		mov bx,0b800h
		mov es,bx
		mov bx,1
		mov cx,2000


	sub3s:and byte ptr es:[bx],10001111b
		or es:[bx],al
		add bx,2
		loop sub3s

		pop es
		pop cx
		pop bx
		ret

	sub4:push cx
		push si
		push di
		push es
		push ds

		mov si,0b800h
		mov es,si
		mov ds,si
		mov si,160
		mov di,0
		cld
		mov cx,24

	sub4s:push cx
		mov cx,160
		rep movsb
		pop cx
		loop sub4s

		mov cx,80
		mov  si,0

	sub4s1:mov byte ptr [160*24+si],' '
		add si,2
		loop sub4s1

		pop ds
		pop es
		pop di
		pop si
		pop cx
		ret

	subend:nop	

code ends
end start
