assume cs:code 
code segment 
start: 
	
	jmp s
	s:
	jmp k
	k:
	
	mov ax,4c00h
	int 21
code ends	
end start
