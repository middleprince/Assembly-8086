assume cs:code

data segment
	dw 0241h
data ends

code segment
	start: 
	 mov ax,data
	 mov ds,ax
	 mov ax,0b800h
	 mov es,ax
	 mov ax,ds:[0]
	 mov es:[0ah],ax
	 mov ax,4c00h
	int 21h
code ends

end start
	