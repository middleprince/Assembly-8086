; 实验14 访问 CMOS RAM
;get the massage from cmos ram and display the year/month/day hour/minet/second
assume cs:code

code segment

	jmp timestart
	timedata: db 0,0,'/',0,0,'/',0,0,' ',0,0,':',0,0,':',0,0,'$'


	timestart:mov di,0
		
	cicledistime:
		mov si,offset timedata
		mov ax,cs
		mov ds,ax

		
		mov ah,0
		mov al,9
		call get
		call tra
		call put

		mov al,8
		call get
		call tra
		call put

		mov al,7
		call get
		call tra
		call put

		mov al,4
		call get
		call tra
		call put

		mov al,2
		call get
		call tra
		call put

		mov al,0
		call get
		call tra
		call put

		;mov bh,ds:[15]
		;mov bl,ds:[16]
		;cmp bx,ax
		;jne judage
		
	;back:call put

		mov si,offset timedata
		call display
		
		jmp cicledistime
	    
	    stop:nop	
		
		mov ax,4c00h
		int 21h




	get:
		out 70h,al
		in al,71h
	    ret     

	tra:mov ah,al
		mov cl,4
		shr ah,cl
		and al,00001111b
		add ah,30h
		add al,30h
		ret


	put:mov byte ptr [si],ah
		mov byte ptr [si].1,al
		inc si
		inc si
		inc si
		ret

	;judage: cmp di,30
	;	je stop
	;	add di,1
	;	jmp back







display: 
            push ds 
            push di
            push es

            mov ax,cs
            mov ds,ax
            
            mov ax,0b800h
            mov es,ax
            mov di,160*4+40*2
           	mov ah,1

circlep:    mov al,ds:[si]
            cmp al,'$'
            je outprint
            mov word ptr es:[di],ax
            inc di
            inc di
            inc si
            jmp circlep

outprint:   pop es
            pop di
            pop ds
            ret

code ends
end timestart