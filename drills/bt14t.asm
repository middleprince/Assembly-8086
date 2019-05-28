assume cs:code

code segment
	start:mov al,9
	out 70h,al
	in al,71h

	mov ax,4c00h
	int 21h
code ends
end start