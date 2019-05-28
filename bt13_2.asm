;use int 7ch to act as loop function
;usu cx to contronl the loop times,bx to show the distance
assume cs:code

code segment
	start:mov ax,cs
	mov ds,ax
	mov si,offset loopbe

	mov ax,0
	mov es,ax
	mov di,0200h

	cld 
	mov cx,offset looped-offset loopbe 
	rep movsb

	mov al,7ch
	mov bl,4
	mul bl
	mov bx,ax
	
	mov word ptr es:[bx],0200h				;write the int 7ch position into vector table
	mov word ptr es:[bx].2,0000h

	mov ax,4c00h
	int 21h

	loopbe:push bp
	mov bp,sp
	jcxz outside
	dec cx
	add [bp+2],bx

	outside:pop bp						;why i should add a nop insteaf of looped:iret
    	iret
    looped:nop

code ends
end start