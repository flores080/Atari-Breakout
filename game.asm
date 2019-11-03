.model small
.stack 100h

;//////////////////////////////////// PRINT ANY NUMBER
print_number macro number
  xor ax, ax
  mov ax, number
  call PrintNumber
endm

;//////////////////////////////////// WRITE ANY NUMBER
write_number macro number
  xor ax, ax
  mov ax, number
  call WriteNumber
endm

;//////////////////////////////////// READ A NUMBER FROM USER
read_number macro var, sig
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx

  mov ah, 01h
	int 21h

  .if al == 2dh     ;if the first char readed from console input is a '-'
    mov sig, 2dh    ;move to the var a '-' and
    mov ah, 01h     ;continue reading
    int 21h
  .elseif al == 2bh ;else if the first char readed from console input is a '+'
    mov sig, 2bh    ;move to the var a '+' and
    mov ah, 01h     ;continue reading
    int 21h
  .elseif al >= '0' && al <= '9' ;else if the first char readed from console input is a digit
    mov sig, 2bh    ;move to the var a '+' and
  .else
    mov novalid, 1 ;else is a no valid char, so put a 1 on the flag
  .endif

  xor ah, ah
  .while al != 0dh
    xor ah, ah
    sub al, 30h ; le resto para obtener el numero en decimal.
    mov bx, var
    add bx, ax ; le sumo el numero ingresado a lo que tiene mi variable num1.
    mov var, bx
    mov ah, 01h	; leo caracter.
    int 21h
    .if al != 0dh
      .if al >= '0' && al <= '9'
        xor ah, ah
        mov tmp, al
        mov ax, var
        mov bl, 10d
        mul bl ; ax = al * bl
        mov var, ax; guardo en mi variable el nuevo valor.
        mov al, tmp
      .else
        mov novalid, 1
        .break
      .endif
    .endif
	.endw
endm

;//////////////////////////////////// DRAW A PIXEL ON VIDEO MODE (13H)
pixel macro x0, y0, color
  push cx
  mov ah, 0ch
  mov al, color
  mov bh, 0h
  mov dx, y0
  mov cx, x0
  int 10h
  pop cx
endm

;//////////////////////////////////// PRINT ANY "STRING"
print macro _str		;it make the sequence to print a string
	push ax
	push dx
  xor ax, ax
  xor dx, dx
	mov ah,9
	lea dx,offset _str	;display the string passed as messlab
	int 21h				;dos call
	pop dx
	pop ax
endm

;//////////////////////////////////// WRITE ON A FILE ANY VALUE
writef macro _str
	mov ah, 40h
	mov bx, handle
	lea dx, offset _str
	int 21h
	xor cx,cx
endm

getblk macro x, y
  push si
  push di
  xor ax, ax
  xor bx, bx
  xor si, si
  xor dx, dx
  mov ax, y
  mov bx, 8
  mul bx
  add ax, x
  mov si, ax
  mov dl, matx[si]
  mov blk, dx
  mov tmp, si
  pop di
  pop si
  ;print_number tmp
  ;print tab
endm

setlvl macro l
  push di
  push si
  mov col, 0
  mov row, 0
  .while row < 14
    .while col < 8
      call delblock
      inc col
    .endw
    inc row
  .endw
  mov col, 0
  mov row, 0
  mov bab2, 0
  mov bab1, 0
  mov bab, 1
  mov di, bax
  sub di, 5
  .while di <= bax
    mov si, bay
    sub si, 5
    .while si <= bay
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov di, bax1
  sub di, 5
  .while di <= bax1
    mov si, bay1
    sub si, 5
    .while si <= bay1
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov di, bax2
  sub di, 5
  .while di <= bax2
    mov si, bay2
    sub si, 5
    .while si <= bay2
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov e, 0
  mov pos, 188
  mov bax, 162
  mov bay, 171
  mov bax1, 162
  mov bay1, 171
  mov bax2, 162
  mov bay2, 171
  mov ver, 0
  mov hor, 0
  mov ver1, 0
  mov hor1, 0
  mov ver2, 0
  mov hor2, 0
  mov col, 0
  mov row, 0

  .while col < 8
    .while row < 14
      setblk col, row, '0'
      inc row
    .endw
    inc col
  .endw
  mov lvl, l
  mov ax, lvl
  add ax, '0'
  mov lvl, ax
  xor dl, dl
  mov dl, l
  .if dl == 1
    mov col, 0
    mov row, 0
    .while col < 8
      setblk col, row, '1'
      inc col
    .endw
    mov col, 1
    mov row, 1
    .while col < 7
      setblk col, row, '1'
      inc col
    .endw
    mov col, 2
    mov row, 2
    .while col < 6
      setblk col, row, '1'
      inc col
    .endw
    mov col, 3
    mov row, 3
    .while col < 5
      setblk col, row, '1'
      inc col
    .endw
  .elseif dl == 2
    mov col, 0
    mov row, 3
    .while col < 8
      setblk col, row, '1'
      inc col
    .endw
    mov col, 1
    mov row, 2
    .while col < 7
      setblk col, row, '1'
      inc col
    .endw
    mov col, 2
    mov row, 1
    .while col < 6
      setblk col, row, '1'
      inc col
    .endw
    mov col, 3
    mov row, 0
    .while col < 5
      setblk col, row, '1'
      inc col
    .endw

    mov col, 0
    mov row, 4
    .while col < 8
      setblk col, row, '1'
      inc col
    .endw
    mov col, 1
    mov row, 5
    .while col < 7
      setblk col, row, '1'
      inc col
    .endw
    mov col, 2
    mov row, 6
    .while col < 6
      setblk col, row, '1'
      inc col
    .endw
    mov col, 3
    mov row, 7
    .while col < 5
      setblk col, row, '1'
      inc col
    .endw
  .elseif dl == 3
    mov col, 3
    .while col < 5
      mov row, 0
      .while row < 4
        setblk col, row, '1'
        inc row
      .endw
      inc col
    .endw
    mov col, 0
    mov row, 3
    .while row < 10
      setblk col, row, '1'
      inc row
    .endw
    inc row
    setblk col, row, '1'
    mov col, 7
    mov row, 3
    .while row < 10
      setblk col, row, '1'
      inc row
    .endw
    inc row
    setblk col, row, '1'

    mov col, 2
    mov row, 7
    .while row < 11
      setblk col, row, '1'
      inc row
    .endw
    inc row
    setblk col, row, '1'
    mov col, 5
    mov row, 7
    .while row < 11
      setblk col, row, '1'
      inc row
    .endw
    inc row
    setblk col, row, '1'

    mov col, 1
    mov row, 2
    setblk col, row, '1'
    inc row
    inc row
    setblk col, row, '1'
    inc row
    inc row
    inc row
    setblk col, row, '1'
    inc row
    setblk col, row, '1'

    mov col, 6
    mov row, 2
    setblk col, row, '1'
    inc row
    inc row
    setblk col, row, '1'
    inc row
    inc row
    inc row
    setblk col, row, '1'
    inc row
    setblk col, row, '1'

    mov col, 2
    mov row, 1
    setblk col, row, '1'
    inc row
    inc row
    inc row
    setblk col, row, '1'
    inc row
    setblk col, row, '1'

    mov col, 5
    mov row, 1
    setblk col, row, '1'
    inc row
    inc row
    inc row
    setblk col, row, '1'
    inc row
    setblk col, row, '1'

    mov col, 3
    mov row, 6
    setblk col, row, '1'
    inc col
    setblk col, row, '1'
  .endif
  xor ax, ax
  xor cx, cx
  xor bx, bx
  xor dx, dx
  lea bp, offset lvl
  mov ah, 13h
  mov al, 01h
  xor bh, bh
  mov bl, 15
  mov cx, 1
  mov dh, 0
  mov dl, 15
  int 10h
  call drawblocks
  call base
  mov ah, 0
  .while e != 1
    call wait_for_key
  .endw
  pop si
  pop di
endm


setblk macro x, y, val
  push si
  push di
  xor ax, ax
  xor bx, bx
  xor si, si
  xor dx, dx
  mov ax, y
  mov bx, 8
  mul bx
  add ax, x
  mov si, ax
  mov dl, val
  mov matx[si], dl
  pop di
  pop si
  ;print_number tmp
  ;print tab
endm

;//////////////////////////////////// DRAW A COORDINATE (X, Y)
draw_point macro x, y
    pixel x, y, 26h
endm

.386
.data
header db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",13,10
       db "FACULTAD DE INGENIERIA",13,10
       db "ESCUELA DE CIENCIAS Y SISTEMAS",13,10
       db "ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A",13,10
       db "SEGUNDO SEMESTRE 2017",13,10
       db "FERNANDO JOSUE FLORES VALDEZ",13,10
       db "201504385",13,10,13,10,'$'

menu_header db "        ___         ___         ___         ___     ",13,10
       db "       /\__\       /\  \       /\__\       /\__\     ",13,10
       db "      /::|  |     /::\  \     /::|  |     /:/  /       ",13,10
       db "     /:|:|  |    /:/\:\  \   /:|:|  |    /:/  /       ",13,10
       db "    /:/|:|__|__ /::\~\:\  \ /:/|:|  |__ /:/  /  ___    1. Log In",13,10
       db "   /:/ |::::\__/:/\:\ \:\__/:/ |:| /\__/:/__/  /\__\   2. Register",13,10
       db "   \/__/~~/:/  \:\~\:\ \/__\/__|:|/:/  \:\  \ /:/  /   3. Exit",13,10
       db "         /:/  / \:\ \:\__\     |:/:/  / \:\  /:/  /   ",13,10
       db "        /:/  /   \:\ \/__/     |::/  /   \:\/:/  /   ",13,10
       db "       /:/  /     \:\__\       /:/  /     \::/  /   ",13,10
       db "       \/__/       \/__/       \/__/       \/__/    ",13,10,13,10,13,10,'$'

report db "REPORTE PRACTICA NO. 3",13,10,13,10,'$'

game_over db 13,10,13,10,13,13,10,13,10,13,10
          db 13,10,"                G A M E"
          db 13,10,"                O V E R",13,10,13,10,13,10
          db 13,10,"                 X   X"
          db 13,10,"                  ___"
          db 13,10,"                 /   \","$"

game_win db 13,10,13,10,13,13,10,13,10,13,10
          db 13,10,"                 Y  O  U"
          db 13,10,"                 W  I  N",13,10,13,10,13,10
          db 13,10,"                  .   .",13,10
          db 13,10,"                  \___/","$"

fecha  	db      "Date:	"
date	  db      "00/00/0000", 13, 10
hora   	db      "Time:	"
time    db      "00:00:00", 13, 10, 13, 10, 13, 10,'$'

ffilename			db "\arq\rep.txt",0
hand 			 dw   ?
handle     dw   ?
char dw 0,"$"
writec dw 0
congra	db 'Successfully generated file! $'

user db 'ferflo08','$'
level db 'N',"$"

lvl dw 1
points db "000",13,10,'$'
timme db '00:00:00',13, 10,"$"
tab db '  ',"$"

tmp dw ?

matx db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'
     db '00000000'

row dw 0
col dw 0
blk dw 0,"$"
pos dw 188

bax dw 162
bay dw 171
hor dw 0
ver dw 0
bab db 0
;hor 1, derecha
;hor 0, izquierda

;ver 1, arriba
;ver 0, abajo

bax1 dw 162
bay1 dw 171
hor1 dw 0
ver1 dw 0
bab1 db 0
;hor 1, derecha
;hor 0, izquierda

;ver 1, arriba
;ver 0, abajo

bax2 dw 162
bay2 dw 171
hor2 dw 0
ver2 dw 0
bab2 db 0
;hor 1, derecha
;hor 0, izquierda

;ver 1, arriba
;ver 0, abajo

x     dw ?
y     dw ?
colorr db ?

t db 0

h db 0
m db 0
s db 0

p db 0

e db 0

paus db 0
gamep db 0

break db 13, 10,"$"

.code
  main proc
    mov     ax, @data
    mov     ds, ax
    mov     es, ax

    call principalmenu

  .exit
main endp

clearvars proc
  mov t, 0
  mov h, 0
  mov m, 0
  mov s, 0
  mov lvl, 1
  mov p, 0
  ret
clearvars endp

principalmenu proc
  call text_mode
  call clear_screen
  print header
  print menu_header
  mov al, 0
  .while al != '3'
    call wait_for_key
    .if al == '1'
      mov gamep, 1
      mov bab, 1
      call game
      call text_mode
      call clear_screen
      print header
      print menu_header
    .elseif al == '2'
      print congra
    .endif
  .endw
  ret
principalmenu endp

game proc
  push di
  push si
  push edx
  push eax
  push ecx
  push ebx
  call clearvars
  call video_mode
  call headergame
  call marco
  setlvl 1
  call put_time
  mov al, 0
  .while gamep != 0 && P != 110
    .if paus == 0
      .if bab == 1
        call ball
        call move
      .endif
      .if bab1 == 1
        call ball1
        call move1
      .endif
      .if bab2 == 1
        call ball2
        call move2
      .endif

      call timer
      call wait_for_key
      .if bax == 11
        mov hor, 1
      .elseif bax == 313
        mov hor, 0
      .endif


      .if bay == 16
        mov ver, 1
      .elseif bay == 171 ;171
        push bx
        push cx
        mov bx, pos
        add bx, 4
        mov cx, pos
        sub cx, 56
        sub cx, 4
        .if bax <= bx
          .if bax >= cx
            mov ver, 0
          .endif
        .endif
        pop cx
        pop bx
      .elseif bay == 193
        mov ver, 0
        mov bab, 0

        mov di, bax
        sub di, 5
        .while di <= bax
          mov si, bay
          sub si, 5
          .while si <= bay
            pixel di, si, 0
            inc si
          .endw
          inc di
        .endw
      .endif

      .if p >= 40 && bab1
        .if bax1 == 11
          mov hor1, 1
        .elseif bax1 == 313
          mov hor1, 0
        .endif


        .if bay1 == 16
          mov ver1, 1
        .elseif bay1 == 171 ;171
          push bx
          push cx
          xor bx, bx
          xor cx, cx
          mov bx, pos
          add bx, 4
          mov cx, pos
          sub cx, 56
          sub cx, 4
          .if bax1 <= bx
            .if bax1 >= cx
              mov ver1, 0
            .endif
          .endif
          pop cx
          pop bx
        .elseif bay1 == 193
          mov ver1, 0
          mov bab1, 0

          mov di, bax1
          sub di, 5
          .while di <= bax1
            mov si, bay1
            sub si, 5
            .while si <= bay1
              pixel di, si, 0
              inc si
            .endw
            inc di
          .endw

        .endif
      .endif

      .if p >= 94 && bab2
        .if bax2 == 11
          mov hor2, 1
        .elseif bax2 == 313
          mov hor2, 0
        .endif


        .if bay2 == 16
          mov ver2, 1
        .elseif bay2 == 171 ;171
          push bx
          push cx
          xor bx, bx
          xor cx, cx
          mov bx, pos
          add bx, 4
          mov cx, pos
          sub cx, 56
          sub cx, 4
          .if bax2 <= bx
            .if bax2 >= cx
              mov ver2, 0
            .endif
          .endif
          pop cx
          pop bx
        .elseif bay2 == 193
          mov ver2, 0
          mov bab2, 0

          mov di, bax2
          sub di, 5
          .while di <= bax2
            mov si, bay2
            sub si, 5
            .while si <= bay2
              pixel di, si, 0
              inc si
            .endw
            inc di
          .endw

        .endif
      .endif
    .else
      .while paus == 1
        call wait_for_key
      .endw
    .endif
    .if bab == 0 && bab1 == 0 && bab2 == 0
      mov gamep, 0
    .endif
  .endw
  .if gamep == 0
    call text_mode
    call clear_screen
    call video_mode
    print game_over
    mov al, 0
    .while al != 13
      mov ax, 0
      mov  ah, 7	;command to read key
      int  21h		;call DOS
    .endw
  .else
    call text_mode
    call clear_screen
    call video_mode
    print game_win
    mov al, 0
    .while al != 13
      mov ax, 0
      mov  ah, 7	;command to read key
      int  21h		;call DOS
    .endw
  .endif
  pop ebx
  pop ecx
  pop eax
  pop edx
  pop si
  pop di
  ret
game endp

move proc
  push ax
  .if hor == 1
    inc bax
  .else
    dec bax
  .endif
  .if ver == 1
    inc bay
  .else
    dec bay
  .endif
  mov row, 14

  .if bay <= 97
    .if bay >=93 && bay <= 97
      mov row, 13
    .endif
    .if bay >=87 && bay <= 91
      mov row, 12
    .endif
    .if bay >=81 && bay <= 85
      mov row, 11
    .endif
    .if bay >=75 && bay <= 79
      mov row, 10
    .endif
    .if bay >=69 && bay <= 73
      mov row, 9
    .endif
    .if bay >=63 && bay <= 67
      mov row, 8
    .endif
    .if bay >=57 && bay <= 61
      mov row, 7
    .endif
    .if bay >=51 && bay <= 55
      mov row, 6
    .endif
    .if bay >=45 && bay <= 49
      mov row, 5
    .endif
    .if bay >=39 && bay <= 43
      mov row, 4
    .endif
    .if bay >=33 && bay <= 37
      mov row, 3
    .endif
    .if bay >=27 && bay <= 31
      mov row, 2
    .endif
    .if bay >=21 && bay <= 25
      mov row, 1
    .endif
    .if bay >=15 && bay <= 19
      mov row, 0
    .endif
  .endif
  .if bax >=268 && bax <= 311
  	mov col, 7
  .endif
  .if bax >=231 && bax <= 274
  	mov col, 6
  .endif
  .if bax >=194 && bax <= 237
  	mov col, 5
  .endif
  .if bax >=157 && bax <= 200
  	mov col, 4
  .endif
  .if bax >=118 && bax <= 161
  	mov col, 3
  .endif
  .if bax >=81 && bax <= 124
  	mov col, 2
  .endif
  .if bax >=44 && bax <= 87
  	mov col, 1
  .endif
  .if bax >=7 && bax <= 50
  	mov col, 0
  .endif
  getblk col, row
  .if blk == '1' && row != 14
    setblk col, row, '0'

    .if ver == 1
      mov ver, 0
    .else
      mov ver, 1
    .endif
    call delblock
    inc p
    call put_points
    .if p == 20
      setlvl 2
    .elseif p == 60
      setlvl 3
      mov bab1, 0
    .elseif p == 40
      mov bab1, 1
    .elseif p == 77
      mov bab1, 1
    .elseif p == 94
      mov bab2, 1
    .endif
  .endif
  pop ax
  ret
move endp

ball proc
  push di
  push si
  mov di, bax
  sub di, 5
  .while di <= bax
    mov si, bay
    sub si, 5
    .while si <= bay
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov di, bax
  sub di, 4
  .while di < bax
    mov si, bay
    sub si, 4
    .while si < bay
      pixel di, si, 49
      inc si
    .endw
    inc di
  .endw
  pop si
  pop di
  ret
ball endp

move1 proc
  push ax
  .if hor1 == 1
    inc bax1
  .else
    dec bax1
  .endif
  .if ver1 == 1
    inc bay1
  .else
    dec bay1
  .endif

  mov row, 14

  .if bay1 <= 97
    .if bay1 >=93 && bay1 <= 97
      mov row, 13
    .endif
    .if bay1 >=87 && bay1 <= 91
      mov row, 12
    .endif
    .if bay1 >=81 && bay1 <= 85
      mov row, 11
    .endif
    .if bay1 >=75 && bay1 <= 79
      mov row, 10
    .endif
    .if bay1 >=69 && bay1 <= 73
      mov row, 9
    .endif
    .if bay1 >=63 && bay1 <= 67
      mov row, 8
    .endif
    .if bay1 >=57 && bay1 <= 61
      mov row, 7
    .endif
    .if bay1 >=51 && bay1 <= 55
      mov row, 6
    .endif
    .if bay1 >=45 && bay1 <= 49
      mov row, 5
    .endif
    .if bay1 >=39 && bay1 <= 43
      mov row, 4
    .endif
    .if bay1 >=33 && bay1 <= 37
      mov row, 3
    .endif
    .if bay1 >=27 && bay1 <= 31
      mov row, 2
    .endif
    .if bay1 >=21 && bay1 <= 25
      mov row, 1
    .endif
    .if bay1 >=15 && bay1 <= 19
      mov row, 0
    .endif
  .endif
  .if bax1 >=268 && bax1 <= 311
    mov col, 7
  .endif
  .if bax1 >=231 && bax1 <= 274
    mov col, 6
  .endif
  .if bax1 >=194 && bax1 <= 237
    mov col, 5
  .endif
  .if bax1 >=157 && bax1 <= 200
    mov col, 4
  .endif
  .if bax1 >=118 && bax1 <= 161
    mov col, 3
  .endif
  .if bax1 >=81 && bax1 <= 124
    mov col, 2
  .endif
  .if bax1 >=44 && bax1 <= 87
    mov col, 1
  .endif
  .if bax1 >=7 && bax1 <= 50
    mov col, 0
  .endif
  getblk col, row
  .if blk == '1' && row != 14
    setblk col, row, '0'

    .if ver1 == 1
      mov ver1, 0
    .else
      mov ver1, 1
    .endif
    call delblock
    inc p
    call put_points
    .if p == 20
      setlvl 2
    .elseif p == 60
      setlvl 3
      mov bab1, 0
    .elseif p == 40
      mov bab1, 1
    .elseif p == 77
      mov bab1, 1
    .elseif p == 94
      mov bab2, 1
    .endif
  .endif
  pop ax
  ret
move1 endp

ball1 proc
  push di
  push si
  mov di, bax1
  sub di, 5
  .while di <= bax1
    mov si, bay1
    sub si, 5
    .while si <= bay1
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov di, bax1
  sub di, 4
  .while di < bax1
    mov si, bay1
    sub si, 4
    .while si < bay1
      pixel di, si, 60
      inc si
    .endw
    inc di
  .endw
  pop si
  pop di
  ret
ball1 endp

move2 proc
  push ax
  .if hor2 == 1
    inc bax2
  .else
    dec bax2
  .endif
  .if ver2 == 1
    inc bay2
  .else
    dec bay2
  .endif
  mov row, 14

  .if bay2 <= 97
    .if bay2 >=93 && bay2 <= 97
      mov row, 13
    .endif
    .if bay2 >=87 && bay2 <= 91
      mov row, 12
    .endif
    .if bay2 >=81 && bay2 <= 85
      mov row, 11
    .endif
    .if bay2 >=75 && bay2 <= 79
      mov row, 10
    .endif
    .if bay2 >=69 && bay2 <= 73
      mov row, 9
    .endif
    .if bay2 >=63 && bay2 <= 67
      mov row, 8
    .endif
    .if bay2 >=57 && bay2 <= 61
      mov row, 7
    .endif
    .if bay2 >=51 && bay2 <= 55
      mov row, 6
    .endif
    .if bay2 >=45 && bay2 <= 49
      mov row, 5
    .endif
    .if bay2 >=39 && bay2 <= 43
      mov row, 4
    .endif
    .if bay2 >=33 && bay2 <= 37
      mov row, 3
    .endif
    .if bay2 >=27 && bay2 <= 31
      mov row, 2
    .endif
    .if bay2 >=21 && bay2 <= 25
      mov row, 1
    .endif
    .if bay2 >=15 && bay2 <= 19
      mov row, 0
    .endif
  .endif
  .if bax2 >=268 && bax2 <= 311
  	mov col, 7
  .endif
  .if bax2 >=231 && bax2 <= 274
  	mov col, 6
  .endif
  .if bax2 >=194 && bax2 <= 237
  	mov col, 5
  .endif
  .if bax2 >=157 && bax2 <= 200
  	mov col, 4
  .endif
  .if bax2 >=118 && bax2 <= 161
  	mov col, 3
  .endif
  .if bax2 >=81 && bax2 <= 124
  	mov col, 2
  .endif
  .if bax2 >=44 && bax2 <= 87
  	mov col, 1
  .endif
  .if bax2 >=7 && bax2 <= 50
  	mov col, 0
  .endif
  getblk col, row
  .if blk == '1' && row != 14
    setblk col, row, '0'

    .if ver2 == 1
      mov ver2, 0
    .else
      mov ver2, 1
    .endif
    call delblock
    inc p
    call put_points
    .if p == 20
      setlvl 2
    .elseif p == 60
      setlvl 3
      mov bab1, 0
    .elseif p == 40
      mov bab1, 1
    .elseif p == 77
      mov bab1, 1
    .elseif p == 94
      mov bab2, 1
    .endif
  .endif
  pop ax
  ret
move2 endp

ball2 proc
  push di
  push si
  mov di, bax2
  sub di, 5
  .while di <= bax2
    mov si, bay2
    sub si, 5
    .while si <= bay2
      pixel di, si, 0
      inc si
    .endw
    inc di
  .endw

  mov di, bax2
  sub di, 4
  .while di < bax2
    mov si, bay2
    sub si, 4
    .while si < bay2
      pixel di, si, 103
      inc si
    .endw
    inc di
  .endw
  pop si
  pop di
  ret
ball2 endp

timer proc
  .if lvl == '1'
    mov     cx, 00h
    mov     dx, 3000h
    mov     ah, 86h
    int     15h
    .if t == 67
      call gettime
      call put_time
      mov t, 0
    .else
      inc t
    .endif
  .elseif lvl == '2'
    mov     cx, 00h
    mov     dx, 1700h
    mov     ah, 86h
    int     15h
    .if t == 141
      call gettime
      call put_time
      mov t, 0
    .else
      inc t
    .endif
  .elseif lvl == '3'
    mov     cx, 00h
    mov     dx, 1000h
    mov     ah, 86h
    int     15h
    .if t == 188
      call gettime
      call put_time
      mov t, 0
    .else
      inc t
    .endif
  .endif
  ret
timer endp

gettime proc near
  lea    bx, offset timme     ; do hour.
  xor ax, ax
  mov     al, h
  call    put_bcd2

  inc     bx                  ; do minute.
  xor ax, ax
  mov     al, m
  call    put_bcd2

  inc     bx                  ; do second.
  xor ax, ax
  mov     al, s
  call    put_bcd2

  inc s
  .if s == 60
    mov s, 0
    inc m
    .if m == 60
      mov m, 0
      inc h
    .endif
  .endif

  ret

  put_bcd2:
      xor edx, edx
      mov cx, 10
      div cl
      add al, '0'
      mov [bx], al
      inc bx
      add ah, '0'
      mov [bx], ah
      inc bx

      ret
gettime endp

put_time proc
  xor ax, ax
  xor cx, cx
  xor bx, bx
  xor dx, dx
  lea bp, offset timme
  mov ah, 13h
  mov al, 01h
  xor bh, bh
  mov bl, 15
  mov cx, 8
  mov dh, 0
  mov dl, 30
  int 10h
  ret
put_time endp

setpoints proc
  lea     bx, offset points     ; do hour.
  xor ax, ax
  mov     al, p

  add bx, 2
  aam
  add al, '0'
	mov [bx], al
	movzx ax, ah
  dec bx
	aam
  add al, '0'
	mov [bx], al
	movzx ax, ah
  dec bx
	aam
  add al, '0'
	mov [bx], al
	movzx ax, ah


  ret
setpoints endp

put_points proc
  push ax
  push bx
  push cx
  push dx
  call setpoints
  xor ax, ax
  xor cx, cx
  xor bx, bx
  xor dx, dx
  lea bp, offset points
  mov ah, 13h
  mov al, 01h
  xor bh, bh
  mov bl, 15
  mov cx, 3
  mov dh, 0
  mov dl, 22
  int 10h
  pop dx
  pop cx
  pop bx
  pop ax
  ret
put_points endp

headergame proc
  call gettime
  print tab
  print user
  print tab
  print tab
  print level
  print tab
  print tab
  call put_points
  ret
headergame endp

displayB800 proc
  push ax
  push bx
  displaying:
  ;GET Y (Y*160).

    mov  ax, y
    mov  bl, 160 ;ONE TEXT LINE = 80*2 BYTES.
    mul  bl  ;Y*160.
  ;GET X (X*2).
    mov  bx, x
    shl  bx, 1  ;X*2 BECAUSE IT'S CHAR/ATTR. SHL=PUSH ONE BIT LEFT (FAST MULTIPLY BY 2).
  ;X,Y TOGETHER (Y*160 + X*2). THIS IS THE OFFSET INSIDE B800.
    add  bx, ax
  ;PUT CHAR IN POSITION X,Y.

    mov  ah, colorr
    mov  al, [ di ]  ;CURRENT STRING CHAR.
    mov  es:[ bx ], ax  ;NOTICE BX IS OFFSET INSIDE 0B800H.
  ;NEXT CHAR.
    inc  di
    inc  x
    loop displaying
    pop bx
    pop ax
    ret
displayB800 endp

base proc
  push ax
  push si
  xor cx, cx

  mov cx, 12
  .while cx < 309
    mov si, 176
    .while si > 170
      pixel cx, si, 0
      dec si
    .endw
    inc cx
  .endw

  mov cx, pos
  sub cx, 56
  .while cx < pos
    mov si, 176
    .while si > 170
      pixel cx, si, 101
      dec si
    .endw
    inc cx
  .endw
  pop si
  pop ax
  ret
base endp

drawblocks proc
  mov col, 0
  .while col < 8
    mov row, 0
    .while row < 14
      getblk col, row
      .if blk == '1'
        call drawblock
      .else
        call delblock
      .endif
      inc row
    .endw
    inc col
  .endw
  ret
drawblocks endp

drawblock proc
  push si
  push di
  mov cx, row
  mov bx, 15
  .while cx > 0
    add bx, 6
    dec cx
  .endw
  mov di, bx
  add di, 5

  .while bx < di
    mov cx, col
    mov dx, 11
    .while cx > 0
      add dx, 37
      dec cx
    .endw
    mov si, dx
    add si, 36
    mov cx, dx
    .if col > 3
      add cx, 2
      add si, 2
    .endif
    .while cx < si
      .if row == 0 || row == 1 || row == 6 || row == 7 || row == 12 || row == 13
        pixel cx, bx, 55
      .elseif row == 2 || row == 3 || row == 8 || row == 9 || row == 14 || row == 15
        pixel cx, bx, 39
      .elseif row == 4 || row == 5 || row == 10 || row == 11 || row == 16 || row == 17
        pixel cx, bx, 43
      .endif
      inc cx
    .endw
    inc bx
  .endw
  pop di
  pop si
  ret
drawblock endp

delblock proc
  push si
  push di
  push bx
  push cx
  push dx
  xor si, si
  xor di, di
  xor bx, bx
  xor cx, cx
  xor dx, dx
  mov cx, row
  mov bx, 15
  .while cx > 0
    add bx, 6
    dec cx
  .endw
  mov di, bx
  add di, 5

  .while bx < di
    mov cx, col
    mov dx, 11
    .while cx > 0
      add dx, 37
      dec cx
    .endw
    mov si, dx
    add si, 36
    mov cx, dx
    .if col > 3
      add cx, 2
      add si, 2
    .endif
    .while cx < si
      pixel cx, bx, 0
      inc cx
    .endw
    inc bx
  .endw
  pop dx
  pop cx
  pop bx
  pop di
  pop si
  ret
delblock endp

marco proc
  mov cx, 5
  .while cx < 315
    draw_point cx, 10
    draw_point cx, 194
    inc cx
  .endw
  mov cx, 10
  .while cx < 195
    draw_point 5, cx
    draw_point 314, cx
    inc cx
  .endw
  ret
marco endp

;/////////////////////////////////////////////////////////////////////////// READ KEY
wait_for_key proc
  ;mov  ah, 7	;command to read key
  ;int  21h		;call DOS
  xor ax, ax
  mov  ah, 0Bh  ;CHECK IF ANY KEY WAS PRESSED.
  int  21h      ;RESULT IN AL : ==0:NO KEY, !=0:KEY.
  .if al != 0
    mov ah, 7
    int 21h
    .if al == 4Dh && pos < 308 && paus == 0
      add pos, 30
      .if e == 0
        add bax, 30
      .endif
      call base
    .elseif al == 4Bh && pos > 77 && paus == 0
      sub pos, 30
      .if e == 0
        sub bax, 30
      .endif
      call base
    .elseif al == 32
      .if paus == 1
        mov gamep, 0
        mov paus, 0
      .else
        mov e, 1
      .endif
    .elseif al == 27
      .if paus == 1
        mov paus, 0
      .else
        mov paus, 1
      .endif
    .endif
  .endif
  ret
wait_for_key endp

;/////////////////////////////////////////////////////////////////////////// SETS VIDEO MODE CONSOLE
video_mode proc
  mov ax, 0013h
  int 10h
  ret
video_mode endp

;/////////////////////////////////////////////////////////////////////////// SETS TEXT MODE CONSOLE
text_mode proc
  mov ax, 0003h
  int 10h
  ret
text_mode endp

;/////////////////////////////////////////////////////////////////////////// CLEAR THE CONSOLE
clear_screen proc           			;clear the console
  mov  ah, 0
  mov  al, 3
  int  10h
  ret
clear_screen endp

;/////////////////////////////////////////////////////////////////////////// SET CONSOLE COLORS
color proc
  mov ax, 0600h
  mov bh, 0009h
  mov cx, 0000h
  mov dx, 184Fh
  int 10h
  ret
color endp

;/////////////////////////////////////////////////////////////////////////// DRAW THE GRAPH AXES
show_axes proc
  mov cx, 318   ;sets the highest value on console (x axe)
  x_axs:
  pixel cx, 99, 32h
  loop x_axs     ;loops while cx != 0

  mov cx, 198   ;sets the highest value on console (y axe)
  y_axs:
  pixel 159, cx, 32h
  loop y_axs     ;loops while cx != 0
  ret
show_axes endp

PrintNumber proc
    xor bx, bx
    xor cx, cx
    mov cx, 0
    mov bx, 10
  @@loophere:
      xor edx, edx
      div bx					;divide by ten

      ; now ax <-- ax/10
      ;     dx <-- ax % 10

      ; print dx
      ; this is one digit, which we have to convert to ASCII
      ; the print routine uses dx and ax, so let's push ax
      ; onto the stack. we clear dx at the beginning of the
      ; loop anyway, so we don't care if we much around with it

      push ax
      add dl, '0'				;convert dl to ascii

      pop ax					;restore ax
      push dx					;digits are in reversed order, must use stack
      inc cx					;remember how many digits we pushed to stack
      cmp ax, 0				;if ax is zero, we can quit
  jnz @@loophere

      ;cx is already set
      mov ah, 2				;2 is the function number of output char in the DOS Services.
  @@loophere2:
      pop dx					;restore digits from last to first
      int 21h					;calls DOS Services
      loop @@loophere2

      ret
PrintNumber endp

WriteNumber proc
    mov writec, 0
    xor bx, bx
    xor cx, cx
    mov cx, 0
    mov bx, 10
@@loophere:
    xor edx, edx
    div bx                          ;divide by ten

    ; now ax <-- ax/10
    ;     dx <-- ax % 10

    ; print dx
    ; this is one digit, which we have to convert to ASCII
    ; the print routine uses dx and ax, so let's push ax
    ; onto the stack. we clear dx at the beginning of the
    ; loop anyway, so we don't care if we much around with it

    push ax
    add dl, '0'					;convert dl to ascii

    pop ax						;restore ax
    push dx						;digits are in reversed order, must use stack
    inc writec					;remember how many digits we pushed to stack
    cmp ax, 0					;if ax is zero, we can quit
jnz @@loophere

    ;cx is already set
                        ;2 is the function number of output char in the DOS Services.
.while writec != 0
    mov ah, 40h
    mov cx, 1
    mov bx, handle
    mov char, 0
    pop char					;restore digits from last to first
    lea dx, offset char
    int 21h						;calls DOS Services
    dec writec
.endw

    ret
WriteNumber endp

datetime proc near
    mov     ah, 04h             ; get date from bios.
    int     1ah

    lea     bx, offset date     ; do day.
    mov     al, dl
    call    put_bcd2

    inc     bx                  ; do month.
    mov     al, dh
    call    put_bcd2

    inc     bx                  ; do year.
    mov     al, ch
    call    put_bcd2
    mov     al, cl
    call    put_bcd2

    mov     ah, 02h             ; get time from bios.
    int     1ah

    lea     bx, offset time     ; do hour.
    mov     al, ch
    call    put_bcd2

    inc     bx                  ; do minute.
    mov     al, cl
    call    put_bcd2

    inc     bx                  ; do second.
    mov     al, dh
    call    put_bcd2

    ret

; Places two-digit BCD value (in al) as two characters to [bx].
;   bx is advanced by two, ax is destroyed.
put_bcd2:
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    ret
datetime endp

end main
