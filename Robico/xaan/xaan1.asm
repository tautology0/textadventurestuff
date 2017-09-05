;
; user equates
;
org     &ffb9
.osrdsc skip 3
.osvdu  skip 3
.oseven skip 3
.gsinit skip 3
.gsread skip 3
.nvrdch skip 3
.ncwrch skip 3
.osfind skip 3
.osgbpb skip 3
.osbput skip 3
.osbget skip 3
.osargs skip 3
.osfile skip 3
.osrdch skip 3
.osasci skip 4
.osnewl skip 3
.oswrcr skip 4
.oswrch skip 3
.osword skip 3
.osbyte skip 3
.oscli  skip 3
.nmiv   skip 3
.resetv skip 3
.irqv  
;
; code equates
;
l0060       = &0060
msgnumber       = &0061
capflag     = &0062        ; if == 0; then next character is a capital
l0063       = &0063
l0064       = &0064
wordbufptr  = &0066
wordbufptrh = &0067
l0068       = &0068
lwrormask   = &0069        ; == &20 - value to lower case ASCII
l006b       = &006b
bufptr      = &0070
bufptrh     = &0071
cmpbuf      = &0072
cmpbufh     = &0073
l0074       = &0074
linelen     = &0080
nounflag    = &0081        ; if != 0; then there is a noun
curverb     = &0082
curnoun     = &0083
msglist     = &0084
msglisth    = &0085
verbv       = &0086
verbvh      = &0087
l0089       = &0089
inputbuf    = &0400
verbbuf     = &041f
nounbuf     = &043e
wordbuf     = &0600
l0922       = &0922
verbptrsl   = &7600
verbptrsh   = &7638
l7a20       = &7a20
verblist    = &7673
nounlist    = &77A9
;
; start of code
;
org &0880
;
.loadaddr
.command    .byte "R. XAAN"
            .byte &0d
.execaddr   lda #&e1
            ldx #&00
            ldy #&00
            jsr osbyte        ; osbyte 225: disable function keys
            lda #&c8
            ldx #&03
            jsr osbyte        ; osbyte 200,3: disable escape and clear memory on break
            lda #&8b
            ldx #&01
            ldy #&00
            jsr osbyte        ; osbyte 139,1: *OPT 1 - no messages during file ops
            ldx #&command MOD 256
            ldy #&command DIV 256
            jmp oscli         ; *R. XAAN
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00

; incbufptr - adds one to the buffer ptr in &70 and &71            
.incbufptr
{
            clc
            lda bufptr
            adc #&01
            sta bufptr
            bcs inchigh
            rts
.inchigh    inc bufptrh
            rts
}

; addwordbufptr - adds the value in A to wordbufptr

.addwordbufptr
{
            clc
            adc wordbufptr
            sta wordbufptr
            bcs incwbhigh
            rts
.incwbhigh  inc wordbufptrh
            rts
}

.setwordbufptr
{
            ldy #<wordbuf
            sty wordbufptr
            lda #>wordbuf
            sta wordbufptrh
            rts
}

; &10921
.printmsg
{            
            lda #&86
            jmp oswrch        ; VDU 134 (Colour = cyan)
.msgnocol   jsr setwordbufptr
.clrmsgloop lda lwrormask     ; == 20
.msgloop    sta capflag
            lda (bufptr),y    ; MIDGE parsing special characters
            cmp #&0d          ; end of message
            beq endmsg
            cmp #&5b          ; token
            bcs instoken         
            cmp #&20          ; token + &a5
            bcc l0981
            cmp #&2e          
            beq punctcap
            cmp #&3f          
            beq punctcap
            cmp #&21         
            beq punctcap
            cmp #&23          ; capitalise
            beq capnext
            cmp #&2c          ; ", "
            beq punctlwr
            cmp #&3b          ; "; "
            beq punctlwr
            cmp #&3a          ; ": "
            beq punctlwr
            cmp #&24          ; verb
            beq l09a6 
            cmp #&25          ; noun
            beq l09b0
            cmp #&26          ; ?
            beq l09ba
            cmp #&3c          ; "<"
            beq l09c6
            ora capflag
.storechar  sta (wordbufptr),y
            lda #&01
.incptrs    jsr addwordbufptr
            jsr incbufptr
            jmp clrmsgloop
.endmsg     jmp l0aa3
.instoken   jsr l0a2b
l097c:      ldy #&00
            jmp incptrs
l0981:      jsr l0a6e
            jmp l097c
.punctcap   jsr spaceafter
            jsr addwordbufptr
.capnext    jsr incbufptr
            lda #&00
            jmp msgloop
.spaceafter sta (wordbufptr),y
            lda #&20
            iny
            sta (wordbufptr),y
            lda #&02
            dey
            rts
.punctlwr   jsr spaceafter
            jmp incptrs
l09a6:      lda #&1f
            sta cmpbufh
            jsr l0a86
            jmp incptrs
l09b0:      lda #&3e
            sta cmpbufh
            jsr l0a86
            jmp incptrs
l09ba:      jsr incbufptr
            lda lwrormask
            eor #&20
            sta lwrormask
            jmp msgloop
l09c6:      lda #&01
            eor l006b
            sta l006b
            jmp storechar
; l09cf
; findmsg - finds message in X (and passes it to print routine)
.findmsg
{            
            stx msgnumber
            lda #&20
            sta lwrormask
            lda msglist         ; 0 when I looked - blank A, X and Y?
            sta bufptr
            tay
            tax
            lda msglisth        ; &45 - &4500 - start of messages
            sta bufptrh
            lda msgnumber
            beq foundmsg
.searchloop lda (bufptr),y
            cmp #&0d
            beq endmsg
.notfound   jsr incbufptr
            jmp searchloop
.endmsg     inx
            cpx msgnumber
            bne notfound
            jsr incbufptr
.foundmsg   jmp msgnocol
}

l09fa:      jsr l0b28
            ldy #&00
            stx l0060
            lda wordbufptr
            sta l0063
            lda wordbufptrh
            sta l0064
l0a09:      lda (l0063),y
            cmp #&20
            beq l0a17
            cmp #&0d
            beq l0a17
            iny
            jmp l0a09
l0a17:      sec
            lda #&27
            sbc l0060
            sta l0060
            cpy l0060
            bcs l0a25
l0a22:      ldy #&00
            rts
l0a25:      jsr l0b22
            jmp l0a22
l0a2b:      sec
            sbc #&5b
            sta cmpbuf
            ldx #&00
            lda #&e4
            sta cmpbufh
            lda #&78
            sta l0074
l0a3a:      lda (cmpbufh),y
            cmp #&40
            beq l0a53
            jmp l0a44
l0a43:      inx
l0a44:      lda #&01
            clc
            adc cmpbufh
            sta cmpbufh
            tya
            adc l0074
            sta l0074
            jmp l0a3a
l0a53:      cpx cmpbuf
            bne l0a43
l0a57:      iny
            lda (cmpbufh),y
            cmp #&40
            beq l0a6b
            dey
            ora capflag
            sta (wordbufptr),y
            iny
            lda lwrormask
            sta capflag
            jmp l0a57
l0a6b:      dey
            tya
            rts
l0a6e:      sta cmpbuf
            cmp #&0e
            bcs l0a81
l0a74:      ldx #&00
            lda #&9c
            sta cmpbufh
            lda #&7b
            sta l0074
            jmp l0a3a
l0a81:      dec cmpbuf
            jmp l0a74
l0a86:      lda #&04
            sta l0074
l0a8a:      lda (cmpbufh),y
            cmp #&0d
            beq l0a96
            sta (wordbufptr),y
            iny
            jmp l0a8a
l0a96:      tya
            ldy #&00
            rts
l0a9a:      lda l0068
            eor #&04
            sta l0068
            jmp l0acc
l0aa3:      sta (wordbufptr),y
            jsr l0b28
            ldy #&00
            cpx #&00
            bne l0ab1
            jsr l0921
l0ab1:      jsr setwordbufptr
l0ab4:      jsr l09fa
            lda (wordbufptr),y
            cmp #&0d
            beq l0ad4
            cmp #&2b
            beq l0ae4
            cmp #&3d
            beq l0a9a
            jsr oswrch
            ldx l0068
            bne l0ad5
l0acc:      lda #&01
            jsr addwordbufptr
            jmp l0ab4
l0ad4:      rts
l0ad5:      txa
            pha
            lda #&13
            jsr osbyte        ; OSBYTE 19 - wait for field synchronisation
            pla
            tax
            dex
            bne l0ad5
            jmp l0acc
l0ae4:      jsr l0b22
l0ae7:      iny
            lda (wordbufptr),y
            cmp #&2b
            bne l0ae7
            sty bufptr
            sec
            lda #&29
            sbc bufptr
            lsr a
            sta bufptr
            jsr gettcursor
            lda #&1f
            jsr oswrch     ; VDU 31 - move text cursor 
            lda bufptr
            jsr oswrch     ; x co-ord
            tya
            jsr oswrch     ; y co-ord - VDU 31, [&70], Y
            ldy #&00
l0b0b:      lda #&01
            jsr addwordbufptr
            lda (wordbufptr),y
            cmp #&2b
            beq l0b1c
            jsr oswrch
            jmp l0b0b
l0b1c:      jsr l0b22
            jmp l0acc
l0b22:      jsr osnewl
            jmp l0921
            
; gettcursor - returns the current text cursor in x and y
.gettcursor
{
            lda #&86
            jmp osbyte     ; OSBYTE 134 - read text cursor position
}
            dcb &10, &10, &10,
            
.inposword  dcb <inputbuf
            dcb >inputbuf
            dcb &1e        ; max line len = 30
            dcb &20        ; minimum ascii = &20 " "
            dcb &7a        ; maximum ascii = &7a "z"

.ackescape
{           lda #&7e  
            jsr osbyte     ; OSBYTE 126 - acknowledge escape condition
            jmp getline
}

; getinput - retrieves input from command line
; filters for blank or illegal input and splits it into verbbuf and nounbuf
; nounflag will be == 0 if there is only a verb
; stored at &B3D 
.getinput
{
            lda #&5d
            jsr oswrch     ; ASCII "]" - input arrow
.getline    lda #&00       
            ldy #>inposword
            ldx #<inposword
            jsr osword     ; OSWORD 0, inposword - read line
            sty linelen    ; line length
            sty nounflag   ; line length
            bcs ackescape  ; CS = escape pressed
            cpy #&00
            beq getinput   ; if no characters read
            ldy #&00
            jsr remspace   ; remove spaces from the front

            ldx #&00          
.checkloop            
            lda inputbuf,y
            cmp #&20
            beq charok     ; If a space
            cmp #&41
            bcs charok     ; If >= ASCII A
            jmp getinput   ; illegal character restart
.charok     ora #&20       ; convert to lower case
            sta inputbuf,x ; place back in the input buffer
            inx
            iny
            cpy linelen      ; have we reached the end?
            bcc checkloop
            lda inputbuf,y
            sta inputbuf,x ; Should be &0d - so this ends the string
            
            ldy #&00
.verbloop   lda inputbuf,y
            cmp #&20
            beq verbend    ; If a space
            cmp #&0d
            beq onlyverb   ; If end of line
            sta verbbuf,y  ; store in verb
            iny
            jmp verbloop
.onlyverb   sta verbbuf,y
            sta nounbuf
            lda #&00
            sta nounflag
            rts
.verbend    lda #&0d
            sta verbbuf,y
            jsr ltrim
            ldx #&00
.nounloop   lda inputbuf,y
            cmp #&0d
            beq nounend
            sta nounbuf,x
            iny
            inx
            jmp nounloop
.nounend    sta nounbuf,x
            lda nounbuf
            cmp #&0d
            beq nonoun
            rts
.nonoun     lda #&00
            sta nounflag
            rts
}
            
.ltrim
{           
            lda inputbuf,y
            cmp #&20
            bne ret
            iny
            jmp ltrim
.ret        rts
}

; setbufnoun
; set bufptr to the address of the nounlist
.setbufnoun
{
            lda #<nounlist
            sta bufptr
            lda #>nounlist
            sta bufptrh
            rts
}

; &0bd8
; searches the nounlist for the current noun and stores it in curnoun
.nounsearch
{
            jsr setbufnoun
            lda #<nounbuf
            sta cmpbuf
            lda #>nounbuf
            sta cmpbufh
            jsr searchlist
            stx curnoun
            rts
}

; searches the verblist for the current verb and stores it in curverb
.verbsearch
{
            lda #<verblist
            sta bufptr
            lda #>verblist
            sta bufptrh
            lda #<verbbuf
            sta cmpbuf
            lda #>verbbuf
            sta cmpbufh
            jsr searchlist
            stx curverb
            rts
}      

; searches for the word in cmpbuf in the list pointed to by bufptr
; on return X = number in list.
.searchlist
{      
            ldx #&ff            
.listloop   ldy #&00
            lda (bufptr),y
            cmp #&0d
            beq endoflist
            cmp #&40
            beq nextword
            jsr incbufptr
            jmp listloop
.endoflist  ldx #&ff             ; word not found
            rts
.nextword   inx
            jsr incbufptr
.wordloop   lda (cmpbuf),y
            cmp #&0d
            beq endofword
            cmp (bufptr),y
            bne nextword
            iny
            jmp wordloop
.nextword   jmp listloop
.endofword  ldy #&00
.letloop    lda (bufptr),y
            cmp #&40
            beq matched
            sta (cmpbuf),y
            iny
            jmp letloop
.matched    lda #&0d
            sta (cmpbuf),y
            rts
}

; &0c3e
.handlecmd
{
            jsr osnewl           ; newline
            ldx curverb
            cpx #&ff             ; no verb found
            beq badverb   
            lda verbptrsl,x      ; lookup table to control each verb
            sta verbv
            lda verbptrsh,x
            sta verbvh
            jsr setnouns
            jmp (verbv)
.badverb    ldx #&00
            jsr l09cf
            ldx #&02
            jsr l09cf
            ldx nounflag
            beq l0c75
            ldx curnoun
            cpx #&ff
            bne l0c75
            ldx #&01
l0c6d:      jsr l09cf
            ldx #&03
l0c72:      jsr l09cf
l0c75:      jsr osnewl
            lda #&86
            sta l0922
            jmp osnewl
}            
; setnouns - quick helper to set X to current noun and A to whether there is a noun
.setnouns
{      
            ldx curnoun
            lda nounflag
            rts
}
; c85            
            ldx #&00
            jmp l0c6d
            bne l0c91
            ldx #&04
            jmp l0c72
l0c91:      ldx #&00
            jmp l0c72
; 0c96
.quitcmd
{        
            ldx #&05
            jmp l0c72
}
            bne l0c91
            ldx #&07
            jsr l09cf
            jsr osnewl
            jsr osnewl
l0ca8:      jsr osrdch
            cmp #&1b
            beq l0cba
            cmp #&4e
            beq l0cc2
            cmp #&59
            beq l0cc7
            jmp l0ca8
l0cba:      lda #&7e
            jsr osbyte
            jmp l0ca8
l0cc2:      ldx #&08
            jmp l0c72
l0cc7:      ldx #&09
            stx l0089
            jmp l0c72
            jsr setbufnoun
            ldy #&00
            stx msgnumber
            ldx #&00
l0cd7:      lda (bufptr),y
            cmp #&0d
            beq l0ce7
            cmp #&40
            beq l0ce8
l0ce1:      jsr incbufptr
            jmp l0cd7
l0ce7:      rts
l0ce8:      cpx msgnumber
            beq l0cf0
            inx
            jmp l0ce1
l0cf0:      jsr incbufptr
l0cf3:      lda (bufptr),y
            cmp #&40
            beq l0ce7
            jsr oswrch
            iny
            jmp l0cf3

