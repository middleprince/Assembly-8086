; 实验 16  测试代码。
;input the function number to selecte the function,the number vary form 0 to 3,and the proreties vary from 1-7.and call the customized int7ch to active the function 

assume cs:code

code segment	
	dis:	db	'please first input the number of dunction the input the propeties.function 0-4 stand for clean,change forground color,background color,row upward','$'
	ds0:	db	'you have selected the 0 function to clean the screen','$'
	ds1:	db 	'you have selected the 1 function now input the color number you want to change','$'
	ds2:	db 	'you have selected the 2 function now input the color number you want to change','$'
	ds3:	db	'you have selected the 3 function the row the lines','$'
	s:		dw 	offset dis,offset ds0,offset ds1,offset ds2,offset ds3

start:

	mov ax,cs
	mov ds,ax
	mov bx,offset s
	call dispaly

	in1:mov bx,offset s     ;initiate the pramaters to show the massage call dispaly
	
	;call setcursor
	;call showmassage

	call delay

	in al,60h
	mov ah,al
	
	cmp ah,8Bh
	jne others
	
	add bx,2
	call dispaly
	;call setcursor
	;call showmassage

	mov ah,0
	int 7ch
	jmp in1

others:
	call delay

	cmp ah,82h
	je fc

	cmp ah,83h
	je fc

	cmp ah,84h
	je fc
	jmp in1

fc:	sub ah,81h
	
	cmp ah,1
	je s1

	cmp ah,2
	je s2

	cmp ah,3
	je s3

	s1:add bx,4
	call dispaly
	;call setcursor					;show finction massage
	;call showmassage
	jmp fc1

	s2:add bx,6
	call dispaly
	;call setcursor
	;call showmassage
	jmp fc1

	s3:add bx,8
	call dispaly
	;call setcursor
	;call showmassage
	jmp fc1

fc1:in al,60h
	
	mov bl,al
	sub bl,02h
	cmp bl,06h
	jnb fc1
	sub al,01h
	int 7ch

	jmp in1

delay:push ax
	push bx
	mov ax,0ffffh
	mov bx,0fffh
	c1:dec ax
	cmp ax,0
	jne c1
	c2:dec bx
	cmp bx,0
	jne c2
	pop bx
	pop ax
	ret

dispaly:push ax
	push es
	push di
	push bx

	mov ax,0b800h
	mov es,ax
	mov di,160*2+4
	mov ax,[bx]
	mov bx,ax

indis:cmp byte ptr [bx],'$'
	je outside
	mov al,[bx]
	mov ah,4
	mov es:[di],ax

	inc bx
	add di,2
	jmp short indis

outside:nop
	pop bx
	pop di
	pop es
	pop ax 
	ret

setcursor:push bx
	push dx
	push ax
	mov bh,0
	mov bl,00101100b			;set the cursor the dispaly the massage
	mov dl,10
	mov dh,2
	mov ah,2
	int 10h
	pop ax
	pop ax
	pop bx
	ret

showmassage:push dx
	push ax
	mov dx,[bx]		;using 21h to dispaly them
	mov ah,9
	int 21h
	pop ax
	pop dx
	ret

	mov ax,4c00h
	int 21h

code ends
end start
