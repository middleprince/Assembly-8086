;test code to show ! at every step
assume cs:code

code segment
	start:
		
		mov ax,2
		inc ax
		inc ax
		inc ax
		mov ax,4c00h
		int 21h

code ends
end start