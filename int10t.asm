assume cs:code
code segment	
start:
			jmp  maincodestart
		 data: db '1) reset pc. 2) start system. 3) clock. 4)set clock.	input the number to select the function.besides f1 can change the color,press Esc to back to main menue.when you set the time use the fotmat as year/month/day hour:minutes:seconed ','$'
		maincodestart:

			mov ax,cs
			mov ds,ax
			mov si,offset data
			
			mov dl,0
	incicle:cmp byte ptr ds:[si],'$'
			je nextstep
			
			mov ah,2
			mov bh,0
			mov dh,4
			int 10h	

			
			mov ah,9
			mov al,ds:[si]					;show the remainder masseage use int10\
			mov bl,4
			mov bh,0
			mov cx,1
			int 10h
			

			inc dl
			inc si
			jmp incicle

			nextstep:
			mov ah,2
			mov bh,0
			mov dh,8
			mov dl,0
			int 10h	

			mov ax,4c00h
			int 21h
code ends
end start