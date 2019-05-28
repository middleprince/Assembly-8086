;use int 21h 9 function to show strings
assume cs:code

code segment
	s1: db'Good,Better,best,','$'
	s2:	db 'Never let it rest','$'
	s3: db 'Till good is better','$'
	s4:	db 'And better is best','$'
	s:	dw offset s1,offset s2,offset s3,offset s4
	row:db 2,4,6,8


	start:mov ax,cs
	mov ds,ax
	mov bx,offset s
	mov si,offset row			
	mov cx,4

	circle:mov bh,0
	mov dh,[si]
	mov dl,0
	mov ah,2		;set the position of the cursor in vram
	int 10h
    
    mov dx,[bx]		;use the 9 function of int21h to print the content at where the ds:dx pointed  
    mov ah,9
    int 21h
    
    add bx,2
    inc si
	
	loop circle

	mov ax,4c00h
	int 21h	
code ends
end start