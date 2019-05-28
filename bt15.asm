;using the int9h to attain a function which wehn you press A there is nothing showing in screen ,but once you release the key dispaly all A in screen

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

	mov si,offset show 
	mov di,204h
	mov cx,offset showend-offset show
	cld
	rep movsb

	push es:[9*4]
	pop es:[200h]
	push es:[9*4+2]
	pop es:[202h]						;store in vertol table

	cli     							;set if =1
	mov word ptr es:[9*4],204h
	mov word ptr es:[9*4+2],0
	sti



	mov ax,4c00h
	int 21h

show:push es
	push cx	
	push ax
	mov di,0
	mov ax,0b800h 
	mov es,ax
	call key
	
	mov cx,4000
	cmp al,9eh      
	jne showout
cicle:mov al,'A'
	
	mov byte ptr es:[di],al
	inc di
	inc di
	loop cicle

showout:pop ax
	pop cx
	pop es
	iret

key:in al,60h

	pushf
	call dword ptr cs:[200h]
	ret


showend:nop


code ends
end start
