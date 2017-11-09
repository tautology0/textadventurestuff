;
; user equates
;
oscli       = &fff7
osbyte      = &fff4
oswrch      = &ffee
osnewl      = &ffe7
osrdch      = &ffe0
;
; code equates
;
l000d       = &000d
l0020       = &0020
l0029       = &0029
l002b       = &002b
l003a       = &003a
l0044       = &0044
l0045       = &0045
l0051       = &0051
l0058       = &0058
l0060       = &0060
l0061       = &0061
l0068       = &0068
l006a       = &006a
l006b       = &006b
l006d       = &006d
l0074       = &0074
l007b       = &007b
l007c       = &007c
l007d       = &007d
l007e       = &007e
l007f       = &007f
l0084       = &0084
l0085       = &0085
currentroom = &0088
l0089       = &0089
droploc     = &008a
invsize     = &008b
l008c       = &008c
l008d       = &008d
l008e       = &008e
l0522       = &0522
l0523       = &0523
lastobj     = &0525
tempstore   = &0526
l0527       = &0527
l0900       = &0900
l0922       = &0922
findmsg     = &09cf
l0a00       = &0a00
l0b00       = &0b00
l0b22       = &0b22
l0b28       = &0b28
l0b3d       = &0b3d
l0bd8       = &0bd8
l0be9       = &0be9
l0c00       = &0c00
l0c3e       = &0c3e
prtmsg      = &0c72
l0c80       = &0c80
badnoun     = &0c85
waitnoun    = &0c91
sitcmd      = &0c96
printnoun   = &0cce
l1855       = &1855
l1c03       = &1c03
l1c16       = &1c16
l20ac       = &20ac
;
; start of code
;
            *= &1200
;
jprtempty=&121e
.invcmd
{
            bne jwaitnoun
            ldx #&0b       ; message 11 "Inventory: \n \nYou are carrying"
            jsr findmsg
            ldx #&00
            lda #&01
            jsr prtobjs
            ldx #&0c       ; message 12 "and wearing "
            jsr findmsg
            ldx #&01
            lda #&01
            jsr prtobjs
            cpy #&00
            bne someobjs
.jprtempty  lda #&7f
            jmp prtempty
.someobjs   rts
}

.jwaitnoun
{
            jmp waitnoun
}

.getoil
{
            lda #&3f
            sta lampflag
            jmp notwater
}            

; neednoun - deals with case where a verb needs a noun and doesn't have one
; e.g. "ATTACK"
neednoun=&1231
; cantdo - deals with the case where the verb and noun combo doesn't make sense
; e.g. "ATTACK RING"
cantdo=&123e
; nothere - deals with the case the object isn't present
nothere=&1268
; thenoun - prints "the noun"
thenoun=&126a
; nothold - deals with case when object isn't in inventory 
nothold=&1272
; holdnoun - prints "holding the noun"
holdnoun=&1274
.getcmd
{
            bne havenoun
.neednoun   ldx #&0a       ; message 10 "I can't guess what you want to verb"
            jmp prtmsg
.havenoun   cpx #&ff
            beq jbadnoun
            cpx #&28
            bcc isobject   ; object < 40 
.cantdo     ldx #&11       ; message 17 "You can't do that"
            jmp prtmsg
.jbadnoun   jmp badnoun
.isobject   stx lastobj
            lda inventory,x
            beq nothold
            cmp currentroom
            beq getobj
            cmp #&01
            beq getobj
            cmp #&28
            bcs nothere    ; object > 40
            tax
            lda inventory,x
            beq getobj
            cmp #&01
            beq getobj
            cmp currentroom
            beq getobj
.nothere    ldx #&0e       ; message 14 "You can't see"
.thenoun    jsr findmsg
            ldx #&12       ; message 18 "the noun"
            jmp prtmsg
.nothold    ldx #&0f       ; message 16 "You are not"
.holdnoun   jsr findmsg
            ldx #&1a       ; message 26 "holding"
            jmp thenoun    ; "the noun"
.getobj     lda invsize
            cmp #&07       ; is space in inventory?
            bcs invfull
            ldx lastobj
            cpx #&1a       ; object 26 "oil"
            beq getoil
            cpx #&26       ; object 38 "water"
            bne notwater
            jmp l12fe
.notwater   lda objflags,x
            and #&0f
            bne l12b3
l1297:      jsr doverb
l129a:      inc invsize
            ldx lastobj
            lda inventory,x
            cmp #&01
            bne l12a8
            dec l008c
l12a8:      lda #&00
            sta inventory,x
            rts
.invfull    ldx #&16       ; message 22 "Your hands are full!"
            jmp prtmsg
l12b3:      cmp #&04
            beq l1297
            cmp #&05
            beq cantget
            cmp #&06
            beq l12db
            cmp #&07
            beq l12ef
            tay
            txa
            pha
            tya
            clc
            adc #&12
            tax
            jsr prtmsg
            pla
            tax
            dec objflags,x
            beq l129a
            rts
.cantget    ldx #&1c       ; message 31 "the % is immovable"
            jmp prtmsg
l12db:      lda l7514
            cmp #&01
            bne l12ea
            lda #&00
            sta objflags,x
            jmp l1297
l12ea:      ldx #&68
            jmp prtmsg
l12ef:      lda waterloc
            cmp #&27
            bne l12ea
            lda #&00
            sta objflags,x
            jmp l1297
l12fe:      ldx #&71       ; message 113 "Fill a container."
            jmp prtmsg
           
.tjbadnoun  jmp jbadnoun

.throwcmd
{
            bne havenoun
            jmp neednoun
.havenoun   ldy currentroom
l130d:      sty droploc
            cpx #&ff
            beq tjbadnoun
            cpx #&28          ; noun 40 - door
            bcc canthrow      ; < noun 40
            jmp cantdo
.canthrow   lda invsize
            bne stuffinv      ; if we have stuff in inv
            ldx #&10          ; message 16 "You are not"
            jsr findmsg
            ldx #&1a          ; message 26 "holding"
            jsr findmsg
            ldx #&18          ; "anything"
            jmp prtmsg
.stuffinv   lda inventory,x
            beq thininv
}

; youarenothold - deals with the case where noun is not in inventory
.youarenothold
{            
            ldx #&10          ; message 16 "You are not"
            jmp holdnoun
}            
.thininv
{
            dec invsize
            lda droploc
            sta inventory,x
            jmp doverb
}
           
; &1341
.gocmd
{
            ldx #&19          ; message 25 "Just type a direction."
            jmp prtmsg
}
srchnoun:   jmp l142e
l1349:      jmp badnoun
            bne l1351
            jmp neednoun
l1351:      cpx #&ff
            beq l1349
            cpx #&28
            bcc l135c
            jmp cantdo
l135c:      lda objflags,x
            and #&0f
            cmp #&04
            beq l1368
            jmp cantdo
l1368:      lda inventory,x
            beq l1374
            cpx #&01
            beq l139b
            jmp youarenothold
l1374:      lda l008c
            cmp #&07
            bcs l1396
            cpx #&13
            bne l138a
            lda waterloc
            cmp #&13
            bne l138a
            ldx #&72
            jmp prtmsg
l138a:      lda #&01
            sta inventory,x
            inc l008c
            dec invsize
            jmp doverb
l1396:      ldx #&17
            jmp prtmsg
l139b:      ldx #&0f
            jsr findmsg
            ldx #&1b
            jmp thenoun
            
.searchcmd
{            
            bne srchnoun
l13a7:      ldx #&52             ; message 82 "You find"
            jsr findmsg
            ldx currentroom
            lda #&00
            jsr prtobjs
            cpy #&00
            bne l13ba
            jmp jprtempty
l13ba:      rts
}
l13bb:      sty tempstore
            lda #&83
            jsr oswrch
            txa
            pha
            lda #&30
            sta l0527
            lda #&00
            ldx tempstore
            beq l13df
            sed
            clc
l13d3:      adc #&01
            bcc l13db
            inc l0527
            clc
l13db:      dex
            bne l13d3
            cld
l13df:      tay
            lda l0527
            cmp #&30
            beq l140b
l13e7:      jsr oswrch
            tya
            lsr a
            lsr a
            lsr a
            lsr a
            clc
            adc #&30
            cmp #&30
            beq l1410
l13f6:      jsr oswrch
            tya
            and #&0f
            adc #&30
            jsr oswrch
            pla
            tax
            ldy tempstore
            lda #&86
            jmp oswrch
l140b:      lda #&83
            jmp l13e7
l1410:      ldx l0527
            cpx #&31
            bcs l13f6
            lda #&83
            jmp l13f6
l141c:      ldy l008d
            jsr l13bb
            lda #&2f
            jsr oswrch
            ldy #&fa
            jsr l13bb
            jmp lflf
l142e:      bne l1433
            jmp neednoun
l1433:      cpx #&ff
            bne l143a
.jbadnoun   jmp badnoun
l143a:      cpx #&28
            bcc l1441
            jmp cantdo
l1441:      lda inventory,x
            beq l1451
            cmp #&01
            beq l1451
            cmp currentroom
            beq l1451
            jmp nothere
l1451:      cpx #&0a
            bne l1458
            jmp l197b
l1458:      lda l7520,x
            stx lastobj
            tax
            jsr findmsg
l1462:      ldx #&52
            jsr findmsg
            lda #&02
            ldx lastobj
            jsr prtobjs
            cpy #&00
            bne l1476
            jmp jprtempty
l1476:      rts

.donthave
{
            ldx #&20          ; message 20 "You don't possess it!"
            jmp prtmsg
}   
         
            bne jjwaitnoun
            lda lamploc
            bne donthave
            ldx lampflag
            cpx #&3f
            beq l14c1
            cpx #&40
            beq l14b7
            lda l008e
            beq l14c1
            cpx #&3d
            beq l14a8
            cpx #&3e
            beq l14a8
            lda l008e
            cmp #&28
            bcc l14bc
            ldx #&3d
l14a2:      stx lampflag
            jmp prtmsg
l14a8:      lda l7420
            beq l14b2
            ldx #&69
            jsr findmsg
l14b2:      ldx #&3c
            jmp l14a2
l14b7:      ldx #&40
            jmp l14a2
l14bc:      ldx #&3e
            jmp l14a2
l14c1:      jmp l14a2
.jneednoun  jmp neednoun
.jjwaitnoun jmp jwaitnoun

; &14ca
.fillcmd
{
            beq jneednoun
            cpx #&ff
            beq jjbadnoun
            cpx #&15             ; noun 21 - lamp
            beq islamp
            cpx #&27             ; noun 39 - well
            bne notwell
            jmp fillwell
.notwell    cpx #&13             ; noun 19 - hat
            bne jjwaitnoun
            jmp fillhat
.islamp     lda lamploc
            bne donthave
            lda oilloc
            beq haveoil
            ldx #&10             ; message 16 "You are not"
            jsr findmsg
            ldx #&1a             ; message 26 "holding"
            jsr findmsg
            ldx #&1a             ; noun 26 - oil
            jsr printnoun
            jmp lflf
.haveoil    lda #&3c
            sta lampflag
            lda #&15             ; noun 21 - lamp
            sta oilloc
            dec invsize
            jmp sitcmd
.jjbadnoun  jmp jbadnoun
}
l1510:      lda #&00
            sta l7427
            ldx lampflag
            cpx #&3d
            beq l1521
            cpx #&3e
            beq l1521
            rts
l1521:      lda #&01
            sta l7427
            lda l008e
            cmp #&01
            beq l1535
            cmp #&27
            bcc l1541
            beq l1549
            dec l008e
            rts
l1535:      dec l008e
            lda #&ff
            sta oilloc
            ldx #&3f
            jmp l14a2
l1541:      ldx #&3e
            stx lampflag
            dec l008e
            rts
l1549:      dec l008e
            jmp l14bc
            jmp neednoun
l1551:      tya
            pha
            stx lastobj
            lda objflags,x
            and #&3f
            lsr a
            lsr a
            lsr a
            lsr a
            clc
            adc #&4b
            tax
            jsr findmsg
            jsr l0b28
            cpx #&1c
            bcs l1588
l156d:      ldx lastobj
            jsr printnoun
            pla
            tay
            iny
            cpy l006a
            beq l1583
            tya
            pha
            ldx #&4f
            jsr findmsg
            pla
            tay
l1583:      dey
            ldx lastobj
            rts
l1588:      jsr l0b22
            jmp l156d
            
; prtobjs - print all objects in room X
; X == 0 - inventory
; X == 1 - wearing
prtempty=&15ab
.prtobjs
{
            sta l0523
            stx droploc
            ldy #&00
            sty l0522
            jsr l15c1
            dey
            beq l15b9
            sty l006a
            inc l0522
            jsr l15c1
l15a6:      lda #&7f          ; backspace
            jsr oswrch
.prtempty   jsr oswrch
            lda #&2e          ; ASCII 46 - "."
            jsr oswrch
.lflf       jsr osnewl
            jmp osnewl
l15b9:      ldx #&0d          ; Message 13 "nothing"
            jsr findmsg
            ldy #&00
            rts
l15c1:      ldy #&01
            ldx #&02
l15c5:      lda inventory,x
            cmp droploc
            bne l15eb
            lda l0523
            beq l160d
            lda l0522
            beq l15e6
            lda l0523
            cmp #&02
            beq l15e3
            jsr osnewl
            jsr l13bb
l15e3:      jsr l1551
l15e6:      iny
            cpy l006a
            beq l15f1
l15eb:      inx
            cpx #&28
            bne l15c5
            rts
l15f1:      lda l0522
            beq l15eb
            stx lastobj
            tya
            pha
            lda #&20
            jsr oswrch
            ldx #&36
            jsr findmsg
            pla
            tay
            ldx lastobj
            jmp l15eb
l160d:      lda l7420
            beq l1628
            lda objflags,x
            bmi l1630
            lda lamploc
            beq l1623
            cmp droploc
            beq l1623
l1620:      jmp l15eb
l1623:      lda l7427
            beq l1620
l1628:      lda l0522
            beq l15e6
            jmp l15e3
l1630:      lda lamploc
            beq l163c
            cmp droploc
            beq l163c
            jmp l1628
l163c:      lda l7427
            beq l1628
            jmp l1620
            bne l1649
            jmp neednoun
l1649:      cpx #&ff
            bne l1650
            jmp badnoun
l1650:      cpx #&28
            bcc l1657
l1654:      jmp cantdo
l1657:      lda inventory,x
            beq l165f
            jmp youarenothold
l165f:      stx lastobj
            ldx #&53
            jsr prtmsg
            jsr l0b3d
            jsr osnewl
            jsr l0bd8
            jsr l0c80
            beq l16ac
            cpx #&ff
            beq l16bb
            cpx lastobj
            beq l1654
            cpx #&15
            beq l16b1
            lda objflags,x
            and #&40
            beq l1654
            lda inventory,x
            beq l1699
            cmp #&01
            beq l1699
            cmp currentroom
            beq l1699
            jmp nothere
l1699:      txa
            tay
            ldx lastobj
            lda #&05
            sta l1855
            jsr l130d
            lda #&67
            sta l1855
            rts
l16ac:      ldx #&54
            jmp prtmsg
l16b1:      lda lastobj
            cmp #&1a
            bne l1654
            jmp islamp
l16bb:      jmp jwaitnoun
l16be:      lda #&00
            sta l0089
            sta l7424
            sta l7422
            sta guardflag
            sta grdprison
            sta l7428
            sta l007b
            lda #&89
            sta l006b
            jsr l0b3d
            jsr l0be9
            jsr l0bd8
            jsr l0c3e
            jsr l1510
            lda l0089
            cmp #&09
            beq l1722
            jsr l1ad3
            lda l007b
            bne l1722
            lda guardflag
            bne l1700
            lda l7428
            bne l1700
            jmp l1754
l1700:      lda l741f
            bne l1732
l1705:      lda l7421
            bne l170b
            rts
l170b:      lda l74fe
            cmp #&01
            beq l1722
            ldx #&24
            jsr prtmsg
            ldy l7426
            iny
            cpy #&05
            beq l1723
            sty l7426
l1722:      rts
l1723:      ldx #&26
l1725:      jsr findmsg
.killplayer lda #&01
            sta l7422
            ldx #&27
            jmp prtmsg
l1732:      lda umbrflag
            cmp #&3a             ; is umbrella open?
            beq l173c
            jmp l1705
l173c:      lda umbrellaloc
            beq l1748
            cmp currentroom
            beq l174a
            jmp l1705
l1748:      dec invsize
l174a:      lda #&ff
            sta umbrellaloc
            ldx #&4a
            jmp prtmsg
l1754:      lda guardloc
            cmp currentroom
            bne l1700      ; Guard in current room?
            lda guardalive
            cmp #&55       ; Guard alive?
            bne l1700
            lda currentroom
            cmp #&34       ; Room 52 "in a small, dimly lit prison cell"
            beq l176f      
            cmp #&3c       ; Room 60 "guard room of the keep"
            beq l176f
            jmp l1700
l176f:      lda currentroom
            cmp #&34       ; Room 52 "in a small, dimly lit prison cell"
            beq l1787
            lda l7424
            beq l178f
            lda #&57
            sta guardalive
            ldx #&58
            jsr prtmsg
            jmp l1700
l1787:      lda grdprison
            beq grdleave
            jmp l1700
l178f:      ldx #&59
            jmp l1725
            
.grdleave   lda #&35             ; Location 53 "at a dead end in the corridor"
            sta guardloc
            lda #&01             ; close prison door
            sta doorflag
            ldx #&5a             ; Msg 90 "The guard shouts at you for disturbing him"
            jsr prtmsg
            jmp l1700
            
            beq l17b5
            cpx #&29
            beq l17ba
            cpx #&2a
            beq l17b5
            ldx #&5b
            jmp prtmsg
l17b5:      ldx #&5c
            jmp prtmsg
l17ba:      lda #&01
            sta l7424
            ldx #&5d
            jmp prtmsg
; &17c4
; handles the ATTACK, STRANGLE and KILL commands.
.attackcmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff       ; Is it a valid noun?
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&12       ; GUARD
            beq isguard
            jmp cantdo
.isguard    lda guardloc   ; guard location
            cmp currentroom
            beq guardhere
            jmp nothere
.guardhere  lda chainloc   ; chain location
            bne chainnoinv
            lda #&01       ; below removes block and guard
            sta grdprison  ; remove door block
            lda #&56
            sta guardalive ; set guard to be dead
            ldx #&5e       ; message 94 - kill guard
            jsr findmsg
            dec invsize    ; reduce size of inventory
            ldx #&ff
            stx chainloc   ; destroy chain
            ldx #&61       ; message 97 - chain dissolves
            jmp prtmsg
.chainnoinv ldx #&5f       ; message 95 "You need a weapon."
            jmp prtmsg
}
 
; &1806 
.knockcmd
{
            beq nonoun
            cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&28       ; 40 - door
            bcc nowthapp
            cpx #&28       ; 40 -door
            bne nowthapp
.nonoun     lda doorflag
            cmp #&01       ; prison door open?
            beq doorclose
            jmp cantdo
.doorclose  lda currentroom
            cmp #&34       ; Room 52 "in a small, dimly lit prison cell"
            bne nowthapp
            sta guardloc   ; move guard to prison cell
            lda #&00       
            sta doorflag   ; open door
            ldx #&62       ; Message "A guard opens the door"
            stx guardflag
            jmp prtmsg
}
; nowthapp - serves cases where noun is not present
; e.g. BOARD SHIP when no ship
.nowthapp
{
            ldx #&1d          ; message 29 "Nothing Happens"
            jmp prtmsg
}
; &0183c
.wishcmd
{
            beq nowthapp      ; no noun - nothing happens
            cpx #&ff
            bne validnoun
            jmp jbadnoun            
.validnoun  cpx #&28          
            bcc isobj         ; < noun 40 "door" - i.e. an object
            jmp cantdo
.isobj      lda inventory,x
            beq nowthapp      ; if have object - "nowt happens"
            jmp youarenothold
}
; e.g. DRINK WATER
.doverb
{            
            ldx #&67          ; message 103 "You $ the %."
            jmp prtmsg
}            
; &1859
.opencmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&25          ; noun 37 "umbrella"
            beq isumbrella
            cpx #&28          ; noun 40 "door"
            beq isdoor
            jmp jwaitnoun
.isumbrella lda umbrellaloc
            beq haveumb
            jmp youarenothold
.haveumb    ldx #&3a
            stx umbrflag      ; Store flag to say umbrella open
            jmp prtmsg
.isdoor     lda doorflag
            cmp #&02
            bne doorclosed
            jmp nothere
.doorclosed cmp #&01
            beq dooropened
            jmp cantdo
.dooropened lda currentroom
            cmp #&34          ; Room 52 "a small, dimly lit prison cell"
            bne notprison
.doorlock   ldx #&65          ; Message 101 "The door is locked."
                              ; You can lock yourself in the prison cell
            jmp prtmsg
.notprison  cmp #&99          ; Room 153 "outside the Tower of Xaan."
            beq doorlock
            lda #&00          ; door open
            sta doorflag
}
.pdoorstat
{
            lda doorflag
            beq opendoor
            cmp #&01
            beq closedoor
            rts
.opendoor   ldx #&63          ; Message 99 "The door is open."
            jmp prtmsg
.closedoor  ldx #&64          ; Message 100 "The door is closed."
            jmp prtmsg
}            

; &18b9
; closecmd - handles CLOSE
.closecmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&25          ; noun 37 - umbrella
            beq validnoun
            cpx #&28          ; noun 40 - door
            beq isdoor
            jmp jwaitnoun
.validnoun lda umbrellaloc
            beq haveumbr
            jmp youarenothold
.haveumbr   ldx #&3b          ; the Umbrella is closed
            stx umbrflag
            jmp prtmsg
.isdoor     lda doorflag
            cmp #&02
            bne doorhere
            jmp nothere
.doorhere   cmp #&00
            beq closedoor
            jmp cantdo
.closedoor  lda #&01
            sta doorflag
            jmp pdoorstat
}            
; &18f9
; breakcmd - handles BREAK
.breakcmd
{            
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&28          ; items < 40 can be carried.
            bcc invitem
            jmp cantdo
.invitem    lda inventory,x   ; check inventory
            beq haveobj
            jmp youarenothold
.haveobj    dec invsize
            lda #&ff
            sta inventory,x   ; destroy object
            cpx #&0c          ; noun 12 - doll
            beq isdoll
            ldx #&67          ; message 103 "You verb the noun"
.stampit    jsr findmsg
            ldx #&6e          ; message 110 "Then stamp ..."
            jmp prtmsg
.isdoll     ldx #&67          ; message 103 "You verb the noun"
            jsr findmsg
            ldx #&9d          ; message 157 "An object falls to the floor"
            lda currentroom
            sta broochloc     ; Move brooch to current room
            jmp stampit
}
            
.fillhat
{
            lda hatloc
            beq havehat
            jmp donthave
.havehat    lda waterloc
            cmp #&13          ; 19 - hat
            beq waterhat      
            cmp currentroom
            bne nowater
            lda #&13
            sta waterloc      ; put water in hat
            jmp sitcmd
.nowater    ldx #&70          ; Message 112 "You need water."
            jmp prtmsg
.waterhat   ldx #&72          ; Message 114 "The hat is full!"
            jmp prtmsg
}

fillwell:   lda l751d
            cmp currentroom
            beq l1967
            jmp nothere
l1967:      lda waterloc
            cmp #&13
            bne nowater
            lda hatloc
            bne nowater
            lda #&27
            sta waterloc
            jmp sitcmd
l197b:      lda currentroom
            cmp #&38
            bcc l19ab
            cmp #&3c
            bcs l19ab
            ldx #&51
            jsr findmsg
            ldx #&30
            lda currentroom
            cmp #&38
            beq l199a
            cmp #&39
            beq l19a3
            cmp #&3b
            beq l19a7
l199a:      jsr findmsg
            jsr l15a6
            jmp l1462
l19a3:      dex
            jmp l199a
l19a7:      dex
            jmp l19a3
l19ab:      jmp l1458

; &19ae
.katroscmd
{
            lda currentroom
            cmp #&99          ; room 153 "You are outside the Tower of Xaan..."
            beq outxaan
            jmp nowthapp
.outxaan    lda doorflag
            bne dooropen
            jmp nowthapp
.dooropen   lda #&00
            sta doorflag
            ldx #&9f          ; message 159 "The building resounds with a low..."
            jmp prtmsg
}
 
; &19c9
.praycmd
{            
            ldx #&86          ; message 134 "God helps those who help themselves!"
            jmp prtmsg
}
            
; &19ce
; climbcmd - handles CLIMB
.climbcmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  lda currentroom
            cmp #&46          ; room 70 - clifftop southwest of keep
            bcc noclimb
            cmp #&6c          ; room 108 - entrance chamber of large cave system
            bcc validroom     ; between 70 and 108
.noclimb    ldx #&23          ; message 35 "you can't verb here"
            jmp prtmsg
.validroom  cmp #&5a          ; room 90 - entrance to a massive forest
            bcc notforest
            cpx #&2d          ; noun 45 - tree
            beq climbtree
.cantclimb  jmp cantdo
.climbtree  ldx #&38          ; message 56 "you verb the tree ..."
            jmp prtmsg
.notforest  cpx #&2e          ; noun 46 cliff
            beq climbcliff
            cpx #&2f          ; noun 47 mountain
            bne cantclimb
.climbcliff ldx #&29          ; message 41 "you being to verb the sheer face ..."
            jsr findmsg
            jmp killplayer
}

; &1a09
; jumpcmd - handles JUMP
.jumpcmd
{
            beq nonoun
.jjwaitnoun jmp jwaitnoun
.nonoun     lda currentroom
            cmp #&46
            bcc jsitcmd
            cmp #&49
            bcc jumpcliff
            cmp #&4d
            bcc jumpmount
.jsitcmd    jmp sitcmd
.jumpcliff  ldx #&37       ; message 55 "You verb and plunge off the cliff ..."
.kill       jsr findmsg
            jmp killplayer
.jumpmount  ldx #&25       ; message 37 ""I'm sick of this adventure", you scream ..."
            jmp kill
}

jjwaitnoun  = &1a0b

; &1a2c
; digcmd - handles DIG
.digcmd
{
            bne jjwaitnoun
            lda shovelloc
            beq haveshov
            ldx #&21       ; message 33 "You need a shovel to verb!"
            jmp prtmsg
.haveshov   lda currentroom
            cmp #&83       ; room 131 "You are in a dimly lit graveyard ..."
            bcc nodig
            cmp #&87       ; room 135 "You are on a misty flight of steps ..."
            bcc gravedig
            beq nodig
            cmp #&8c
            bcc sanddig
            cmp #&91       ; room 145 "You are on a vast, windswept plain ..."
            bcc l1a5e
.nodig      ldx #&22       ; message 34 "The floor is too hard ..."
            jmp prtmsg
.gravedig   jsr l1a66
            ldx #&82       ; message 130 "You $ long and deep, and ..."
            jmp prtmsg
.sanddig    ldx #&83       ; message 131 "The sand is dry and the hole ..."
            jmp prtmsg
l1a5e:      jsr l1a66
            ldx #&84       ; message 132 "The damp sand is firm ..."
            jmp prtmsg
l1a66:      ldx #&27       ; object 27 - well
            lda currentroom
            clc
            adc #&5d
            sta tempstore
l1a70:      lda inventory,x
            cmp tempstore
            bne l1a7d
            lda currentroom
            sta inventory,x
l1a7d:      dex
            bpl l1a70
            rts
}

.drinkcmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&26          ; noun 38 - water
            beq iswater
            jmp cantdo
.iswater    lda waterloc
            cmp currentroom 
            beq ishere
            cmp #&13          ; noun 19 - hat   
            beq ishere
            jmp nothere
.ishere     lda #&ff
            sta waterloc
            jmp doverb
}

.eatcmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp jbadnoun
.validnoun  cpx #&0e          ; noun 14 - food
            beq isfood
            jmp cantdo
.isfood     lda foodloc
            beq ininv
            cmp currentroom
            beq inroom
            jmp nothere
.ininv      dec invsize
.inroom     lda #&ff
            sta foodloc
            jmp doverb
}
            
l1ad3:      jsr l20d0
            lda currentroom
            jsr l1cff
            lda l007c
            beq l1ae2
            jmp killplayer
l1ae2:      lda currentroom
            cmp #&63
            bcc l1af4
            cmp #&83
            bcs l1af4
            lda #&01
            sta l7420
            jmp l1af9
l1af4:      lda #&00
            sta l7420
l1af9:      lda currentroom
            cmp #&35
            bcc l1b13
            cmp #&56
            bcc l1b0b
            cmp #&88
            bcc l1b13
            cmp #&94
            bcs l1b13
l1b0b:      lda #&01
            sta l7421
            jmp l1b18
l1b13:      lda #&00
            sta l7421
l1b18:      lda currentroom
            cmp #&46
            bcc l1b32
            cmp #&56
            bcc l1b2a
            cmp #&88
            bcc l1b32
            cmp #&94
            bcs l1b32
l1b2a:      lda #&01
            sta l741f
            jmp l1b37
l1b32:      lda #&00
            sta l741f
l1b37:      lda currentroom
            cmp #&83
            bcc l1b73
            cmp #&88
            bcs l1b73
            lda l7505
            cmp #&01
            bne l1b73
            lda #&cf
            sta currentroom
            ldx #&85
            jsr prtmsg
            ldx #&27
l1b53:      lda inventory,x
            beq l1b68
            cmp #&01
            beq l1b70
l1b5c:      dex
            bpl l1b53
            lda #&00
            sta invsize
            sta l008c
            jmp l1c00
l1b68:      lda #&bb
            sta inventory,x
            jmp l1b5c
l1b70:      jmp l1b68
l1b73:      rts
            .byte &32,&3a,&53,&54
            eor (l0074,x)
            adc l006d
            bvs l1bf6
            and l003a
            .byte &54
            eor (l0058,x)
            .byte &3a,&43
            bvc l1bdf
            .byte &23
            bmi l1bc4
            .byte &42
            eor l0051
            ror l736f
            adc l0061
            .byte &72,&63
            pla
            .byte &3a
            jmp l5844
            .byte &23
            bmi l1ba9
            .byte &00
            ldx l2e5a,y
            jmp l4f4f
            bvc l1bdf
            jmp l4144
            plp
l1ba9:      eor l0058
            and l0029
            bit l3a59
            .byte &42
            eor l6349
            .byte &6b
            ror l6d75
            .byte &3a
            rol l6e69
            .byte &63,&3a
            jmp l4144
            .byte &23,&32,&3a
l1bc4:      .byte &43
            jmp l3a43
            eor (l0044,x)
            .byte &43
            eor l0058
            and l003a
            .byte &53,&54
            eor (l0045,x)
            cli
            and l003a
            jmp l4144
            .byte &23
            bmi l1c16
            eor (l0044,x)
            .byte &43
l1bdf:      eor l0058
            and l002b
            and (l003a),y
            .byte &53,&54
            eor (l0045,x)
            cli
            and l002b
            and (l003a),y
            lsr a
            eor l4c50
            .byte &4f,&4f
            bvc l1c03
l1bf6:      .byte &00
            iny
            .byte &1f
            rol l6b63
            ror l6d75
            .byte &3a
l1c00:      lda #&5c
            sta l007e
            lda #&6e
            sta l007f
            ldy #&00
            tya
l1c0b:      sta l7400,y
            iny
            cpy #&1f
            bne l1c0b
            lda #&02
            sta doorflag
            ldy #&00
            lda currentroom
            sec
            sbc #&34
            sta l007d
            tax
            cpx #&00
            beq l1c43
            ldx #&00
l1c28:      lda (l007e),y
            bmi l1c3c
l1c2c:      lda #&02
            clc
            adc l007e
            sta l007e
            lda #&00
            adc l007f
            sta l007f
            jmp l1c28
l1c3c:      inx
            cpx l007d
            bne l1c2c
            iny
            iny
l1c43:      lda (l007e),y
            and #&0f
            tax
            inc l7400,x
            lda (l007e),y
            and #&f0
            sta l7414,x
            iny
            lda (l007e),y
            sta l740a,x
            iny
            lda l7414,x
            and #&40
            beq l1c65
            lda #&01
            sta doorflag
l1c65:      lda l7414,x
            bmi l1c6d
            jmp l1c43
l1c6d:      rts
l1c6e:      lda #&7f
            jsr oswrch
            jsr oswrch
            tya
            jmp oswrch
l1c7a:      ldx #&2a
            jmp l1c97
l1c7f:      ldx #&00
            ldy #&00
l1c83:      lda l7400,x
            beq l1c89
            iny
l1c89:      inx
            cpx #&0a
            bne l1c83
            dey
            sty l006a
            cpy #&00
            beq l1c7a
            ldx #&2b
l1c97:      jsr findmsg
            ldy #&00
            ldx #&00
l1c9e:      lda l7400,y
            beq l1cd0
            lda l7414,y
            and #&10
            beq l1caf
            dec l006a
            jmp l1cd0
l1caf:      stx l007d
            tya
            pha
            clc
            adc #&2c
            tax
            jsr findmsg
            ldx l007d
            inx
            cpx l006a
            bne l1cce
            ldy #&20
            jsr l1c6e
            ldx #&36
            jsr findmsg
            ldx l007d
            inx
l1cce:      pla
            tay
l1cd0:      iny
            cpy #&0a
            bne l1c9e
            ldy #&2e
            jsr l1c6e
            lda #&20
            jsr osnewl
            rts
l1ce0:      lda #&3c             ; Room 60 "guard room of the keep"
            sta guardloc
            lda #&55
            sta guardalive
            jmp l1d03
l1ced:      lda currentroom
            cmp #&da
            beq l1d5d
            cmp #&36
            beq l1ce0
            cmp #&94
            bcc l1d03
            cmp #&98
            bcc l1d21
l1cff:      cmp #&98
            beq l1d08
l1d03:      lda #&00
            sta l007c
            rts
l1d08:      lda #&00
            sta l75b8
            lda umbrellaloc
            bne l1d21
            lda umbrflag
            cmp #&3b             ; Umbrella is closed
            beq l1d21
            lda #&01
            sta l75b8
            jmp l1d03
l1d21:      lda #&01
            sta l007c
            rts
l1d26:      lda #&01
            sta l7420
            jsr l1fa0
            bne l1d03
            ldx #&28
l1d32:      jsr findmsg
            jmp l1d21
l1d38:      lda #&01
            sta l7420
            jsr l1fa0
            bne l1d03
            ldx #&74
            jmp l1d32
l1d47:      lda currentroom
            cmp #&63
            bcc l1d55
            cmp #&6c
            bcc l1d26
            cmp #&83
            bcc l1d38
l1d55:      lda #&00
            sta l7420
            jmp l1d03
l1d5d:      ldx #&87
            lda #&01
            cmp l7513
            beq l1da7
            cmp l7506
            beq l1db7
            cmp l74fe
            bne l1dbf
            cmp l7505
            bne l1dc7
            cmp hatloc
            bne l1dcf
            cmp l750c
            bne l1dd7
            cmp l750e
            bne l1ddf
            cmp l7514
            bne l1de7
            cmp l7517
            bne l1def
            lda #&00
            cmp l750c
            beq l1da7
            cmp l7506
            beq l1db7
            ldx #&92
            jsr findmsg
            ldx #&93
            jsr prtmsg
            jmp l1d03
l1da7:      jsr findmsg
            ldx #&88
l1dac:      jsr findmsg
            ldx #&91
            jsr prtmsg
            jmp l1d21
l1db7:      jsr findmsg
            ldx #&89
            jmp l1dac
l1dbf:      jsr findmsg
            ldx #&8c
            jmp l1dac
l1dc7:      jsr findmsg
            ldx #&8b
            jmp l1dac
l1dcf:      jsr findmsg
            ldx #&8a
            jmp l1dac
l1dd7:      jsr findmsg
            ldx #&8d
            jmp l1dac
l1ddf:      jsr findmsg
            ldx #&90
            jmp l1dac
l1de7:      jsr findmsg
            ldx #&8f
            jmp l1dac
l1def:      jsr findmsg
            ldx #&8e
            jmp l1dac
            nop
            nop
l1df9:      beq l1dfe
            jmp jwaitnoun
l1dfe:      lda guardloc
            cmp currentroom
            bne l1e11
            lda guardalive
            cmp #&55
            bne l1e11
            ldx #&60             ; Message 60 "The guard blocks your way."
            jmp prtmsg
l1e11:      ldx #&00
            rts
l1e14:      beq l1e11
            jmp jwaitnoun
            jsr l1df9
            bne l1e21
            jmp l1e7e
l1e21:      rts
            jsr l1e14
            bne l1e21
            inx
            jmp l1e7e
            jsr l1e14
            bne l1e21
            inx
            inx
            jmp l1e7e
l1e35:      jsr l1e14
            bne l1e21
            jmp l1ee1
l1e3d:      ldx #&03
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&04
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&05
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&06
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&07
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&08
            jmp l1e7e
            jsr l1e14
            bne l1e21
            ldx #&09
            jmp l1e7e
l1e7e:      lda l7400,x
            beq l1e94
            lda l7414,x
            and #&40
            beq l1ea2
            lda doorflag
            beq l1e99
            ldx #&64
            jmp prtmsg
l1e94:      ldx #&73
            jmp prtmsg
l1e99:      txa
            pha
            ldx #&66
            jsr findmsg
            pla
            tax
l1ea2:      lda l740a,x
            sta currentroom
            inc l7428
            jsr l1c00
            jsr l2137
            jsr l1d47
            lda l007c
            beq l1eba
            jmp killplayer
l1eba:      lda currentroom
            jsr l1cff
            jsr l1f57
            jsr l1ced
            lda l007c
            beq l1ed3
            lda currentroom
            cmp #&98
            bne l1ed0
            rts
l1ed0:      jmp killplayer
l1ed3:      lda currentroom
            cmp #&db
            beq l1edc
            jmp l1f7b
l1edc:      lda #&01
            sta l007b
            rts
l1ee1:      lda currentroom
            cmp #&da             ; room 166 "End of passageway on first floor"
            beq l1eea
            jmp l1e3d
l1eea:      cmp l74fb
            bne l1f2d
            cmp broochloc
            bne l1f2d
            cmp l74ff
            bne l1f2d
            cmp l7501
            bne l1f2d
            cmp l7507
            bne l1f2d
            cmp l750a
            bne l1f2d
            cmp l750d
            bne l1f2d
            cmp l750f
            bne l1f2d
            cmp l7511
            bne l1f2d
            cmp l7512
            bne l1f2d
            txa
            pha
            ldx #&95
            jsr findmsg
            ldx #&93
            jsr prtmsg
            pla
            tax
            jmp l1e3d
l1f2d:      ldx #&94
            jsr findmsg
            ldx #&93
            jmp prtmsg
; boardcmd - handles BOARD
.boardcmd
{
            bne havenoun
            jmp neednoun
.havenoun   cpx #&ff
            bne validnoun
            jmp badnoun
.validnoun  cpx #&2b          ; noun 43 - ship
            beq isship
            jmp jwaitnoun     
            nop               ; ??
.isship     lda currentroom
            cmp #&da          ; in room 1 
            bne noship
            jmp l1e35
.noship     jmp nowthapp
}
l1f57:      jsr l1fa0
            beq l1f69
            jsr l1f86
            lda doorflag
            beq l1f6e
            cmp #&01
            beq l1f73
            rts
l1f69:      ldx #&69
            jmp findmsg
l1f6e:      ldx #&63
            jmp findmsg
l1f73:      ldx #&64
            jmp findmsg
l1f78:      jsr l1f57
l1f7b:      lda l7427
            beq l1f83
            jsr l1c7f
l1f83:      jmp l13a7
l1f86:      lda #&53
            sta l0085
            lda #&00
            sta l0084
            ldx currentroom
            lda l7520,x
            tax
            jsr l2131
            lda #&45
            sta l0085
            lda #&00
            sta l0084
            rts
l1fa0:      lda l7420
            beq l1fb9
            lda lampflag
            cmp #&3c
            beq l1fbf
            cmp #&3f
            beq l1fbf
            lda lamploc
            beq l1fb9
            cmp currentroom
            bne l1fbf
l1fb9:      lda #&01
l1fbb:      sta l7427
            rts
l1fbf:      lda #&00
            jmp l1fbb
            ldx #&07
            jsr prtmsg
            jsr l200f
            beq l1fd3
l1fce:      ldx #&08
            jmp prtmsg
l1fd3:      ldx #&00
l1fd5:      lda currentroom,x
            sta l7429,x
            inx
            cpx #&08
            bne l1fd5
            ldx #&c0
            ldy #&22
            jsr oscli
            jmp sitcmd
            ldx #&07
            jsr prtmsg
            jsr l200f
            beq l1ff6
            jmp l1fce
l1ff6:      ldx #&d1
            ldy #&22
            jsr oscli
            ldx #&00
l1fff:      lda l7429,x
            sta currentroom,x
            inx
            cpx #&08
            bne l1fff
            jsr sitcmd
            jmp l1f78
l200f:      jsr osrdch
            cmp #&1b
            beq l2024
            cmp #&59
            bne l201d
            lda #&00
            rts
l201d:      cmp #&4e
            bne l200f
            lda #&01
            rts
l2024:      lda #&7e
            jsr osbyte
            jmp l200f
l202c:      ldx #&00
l202e:      lda l7400,x
            sta l3000,x
            lda l7500,x
            sta l3100,x
            dex
            bne l202e
            rts
l203e:      ldx #&2f
            lda #&00
l2042:      sta l0060,x
            dex
            bpl l2042
            lda #&ff
            sta l008e
            lda #&01
            sta l008c
            lda #&34       ; Room 52 "in a small, dimly lit prison cell"
            sta currentroom
            lda #&45
            sta l0084
            rts
l2058:      jsr l203e
            ldx #&00
l205d:      lda l3000,x
            sta l7400,x
            lda l3100,x
            sta l7500,x
            dex
            bne l205d
            jsr l223d
            jsr l1c00
            jmp l1f78
l2075:      jsr l202c
l2078:      lda #&0c
            jsr oswrch
            jsr l2058
l2080:      jsr l16be
            lda l0089
            cmp #&09
            beq l20c7
            lda l7422
            bne l2095
            lda l007b
            bne l209e
            jmp l2080
l2095:      jsr l218c
l2098:      jsr l20a6
            jmp l2078
l209e:      ldx #&a0
            jsr prtmsg
            jmp l2098
l20a6:      lda #&85
            sta l0922
            ldx #&96
            jsr l2131
            jsr l20ca
l20b3:      jsr osrdch
            cmp #&1b
            beq l20bf
            cmp #&0d
            bne l20b3
            rts
l20bf:      lda #&7e
            jsr osbyte
            jmp l20b3
l20c7:      jmp l2078
l20ca:      lda #&86
            sta l0922
            rts
l20d0:      lda currentroom
            cmp #&d6
            beq l20d7
            rts
l20d7:      lda foodloc
            cmp #&d6
            beq l20f1
            cmp #&03
            beq l20f1
            ldx #&97
            jsr findmsg
            ldx #&98
l20e9:      jsr findmsg
            ldx #&9b
            jmp prtmsg
l20f1:      lda l7516
            cmp #&d6
            beq l2106
            cmp #&03
            beq l2106
            ldx #&97
            jsr findmsg
            ldx #&99
            jmp l20e9
l2106:      lda l74fa
            cmp #&d6
            beq l211b
            cmp #&03
            beq l211b
            ldx #&97
            jsr findmsg
            ldx #&9a
            jmp l20e9
l211b:      lda l750e
            cmp #&ff
            beq l2127
            ldx #&9c
            jmp prtmsg
l2127:      lda #&d6
            sta l750e
            ldx #&9e
            jmp prtmsg
l2131:      jsr findmsg
            jmp osnewl
l2137:      lda currentroom
            cmp #&36
            beq l214a
            cmp #&3d
            beq l217e
            cmp #&6c
            beq l2162
            cmp #&9a
            beq l2170
            rts
l214a:      lda l7432
            bne l2157
            jsr l2158
            lda #&01
            sta l7432
l2157:      rts
l2158:      lda l7431
            clc
            adc #&0a
            sta l7431
            rts
l2162:      lda l7434
            bne l2157
            jsr l2158
            lda #&01
            sta l7434
            rts
l2170:      lda l7435
            bne l2157
            jsr l2158
            lda #&01
            sta l7435
            rts
l217e:      lda l7433
            bne l2157
            jsr l2158
            lda #&01
            sta l7433
            rts
l218c:      ldy #&00
            lda #&da
            cmp l74fb
            bne l2196
            iny
l2196:      cmp broochloc
            bne l219c
            iny
l219c:      cmp l74ff
            bne l21a2
            iny
l21a2:      cmp l7501
            bne l21a8
            iny
l21a8:      cmp l7507
            bne l21ae
            iny
l21ae:      cmp l750a
            bne l21b4
            iny
l21b4:      cmp l750d
            bne l21ba
            iny
l21ba:      cmp l750f
            bne l21c0
            iny
l21c0:      cmp l7511
            bne l21c6
            iny
l21c6:      cmp l7512
            bne l21cc
            iny
l21cc:      lda #&01
            cmp l74fe
            bne l21d4
            iny
l21d4:      cmp l7505
            bne l21da
            iny
l21da:      cmp hatloc
            bne l21e0
            iny
l21e0:      cmp l750c
            bne l21e6
            iny
l21e6:      cmp l750e
            bne l21ec
            iny
l21ec:      cmp l7514
            bne l21f2
            iny
l21f2:      cmp l7517
            bne l21f8
            iny
l21f8:      lda l74fa
            cmp #&03
            beq l2203
            cmp #&d6
            bne l2204
l2203:      iny
l2204:      lda foodloc
            cmp #&03
            beq l220f
            cmp #&d6
            bne l2210
l220f:      iny
l2210:      lda l7516
            cmp #&03
            beq l221b
            cmp #&d6
            bne l221c
l221b:      iny
l221c:      lda waterloc
            cmp #&27
            bne l2224
            iny
l2224:      lda #&00
            sta l008d
l2228:      lda l008d
            clc
            adc #&0a
            sta l008d
            dey
            bne l2228
            lda l7431
            clc
            adc l008d
            sta l008d
            jmp l141c
l223d:      lda #&45
            sta l0085
            lda #&00
            sta l0084
            lda #&83
            sta l0922
            ldx #&06
            jsr prtmsg
            lda #&0f
            jsr oswrch
            jmp l20ca
            ldx #&40
            jmp prtmsg
            rts
execaddr:   lda #&16
            jsr oswrch
            lda #&07
            jsr oswrch     ; OSWRCH 22,7 - i.e. MODE 7
            lda #&0f
            jsr oswrch     ; OSWRCH 15 - i.e. page mode off
            lda #&8b
            ldx #&01
            ldy #&00
            sty l0068
            jsr osbyte     ; OSBYTE 139 - Turn load information off
            lda #&43       ; high byte of intro message
            sta l0085
            lda #&00       ; low byte of intro message
            sta l0084
            tax
            lda #&0c    
            jsr oswrch     ; OSWRCH 12 - CLS
l2285:      txa
            pha
            jsr l2131
            pla
            tax
            inx
            cpx #&06
            bne l2285
            stx l20ac
            jsr osnewl
            lda #&89
            sta l006b
            jsr l20a6
            ldx #&96
            stx l20ac
            lda #&45
            sta l0085
            jmp l2075
            ldx #&00
l22ac:      lda #&10
            sta l0b00,x
            lda #&00
            sta l0900,x
            sta l0a00,x
            sta l0c00,x
            dex
            bne l22ac
            rts
; &22bf
            .byte &53
            rol l4120
            .byte &44
            lsr l0020,x
            .byte &37,&34
            bmi l22fb
            jsr l3637
            bmi l2300
            ora l2e4c
            jsr l4441
            lsr l000d,x
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00
l22fb:      .byte &00,&00,&00,&00,&00
l2300:      .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
l2e4c:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
l2e5a:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&ff,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
l3000:      .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
l3100:      .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &ff,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00
l3637:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&ff,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&ff,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&ff,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&ff,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
l3a43:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
l3a59:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&0f,&76,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00
l4120:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
l4144:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&ff,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&22,&23,&8a,&4a
            .byte &12,&9f,&10,&8f,&c1,&20,&5c,&20
            .byte &a8,&a9,&4b,&20,&5c,&27,&52,&9d
            .byte &c1,&99,&3f,&45,&48,&3f,&be,&4d
            .byte &9d,&b3,&21,&ac,&fc,&45,&a3,&f2
            .byte &22,&2c,&0f,&b5,&54,&a4,&89,&23
            .byte &4b,&99,&20,&7b,&23,&58,&41,&ac
            .byte &2c,&ac,&e1,&e7,&59,&2e,&0d,&22
            .byte &23,&93,&2e,&2e,&2e,&93,&22,&2c
            .byte &5c,&20,&43,&52,&59,&2c,&46,&0b
            .byte &da,&59,&2c,&8a,&47,&41,&5a,&9d
            .byte &19,&20,&8f,&89,&23,&4b,&99,&2e
            .byte &0d,&22,&23,&53,&b1,&c7,&99,&20
            .byte &4d,&a2,&93,&2c,&57,&aa,&9d,&5c
            .byte &2c,&c1,&47,&21,&5c,&20,&4b,&ee
            .byte &a6,&10,&8f,&23,&a5,&c1,&20,&76
            .byte &a8,&49,&0c,&b7,&2c,&c1,&98,&5c
            .byte &3f,&a5,&dd,&f1,&20,&8b,&a7,&7a
            .byte &4d,&a2,&4b,&45,&04,&20,&c8,&a3
            .byte &a1,&57,&bb,&c3,&22,&2c,&cb,&55
            .byte &de,&a4,&89,&23,&4b,&99,&2c,&0c
            .byte &49,&d7,&59,&2e,&0d,&22,&23,&ed
            .byte &a6,&4c,&b3,&47,&20,&a1,&57,&bb
            .byte &c3,&3f,&49,&27,&a7,&56,&aa,&a2
            .byte &a8,&02,&b8,&59,&22,&2c,&5c,&20
            .byte &43,&df,&ff,&2c,&54,&b5,&d3,&99
            .byte &20,&5c,&a3,&43,&c0,&f1,&45,&a0
            .byte &d4,&50,&53,&2e,&0d,&22,&23,&49
            .byte &27,&a7,&ee,&9f,&53,&55,&ab,&22
            .byte &2c,&ab,&50,&d4,&45,&a4,&89,&23
            .byte &4b,&99,&2c,&22,&23,&d2,&b0,&4c
            .byte &20,&5c,&20,&df,&54,&2c,&d8,&4f
            .byte &42,&41,&da,&59,&22,&2c,&8a,&48
            .byte &9d,&b9,&44,&aa,&a4,&c8,&a3,&5c
            .byte &20,&76,&42,&9d,&d1,&53,&9f,&a9
            .byte &76,&d8,&c9,&b3,&21,&0d,&23,&03
            .byte &20,&08,&47,&7a,&5c,&a3,&7f,&a4
            .byte &7e,&89,&23,&c9,&4c,&8a,&7b,&23
            .byte &58,&41,&ac,&2e,&2e,&2e,&0d,&2b
            .byte &23,&50,&ab,&53,&53,&3c,&26,&ab
            .byte &54,&55,&52,&4e,&26
l4441:      .byte &3c,&76,&b8,&ae,&54,&2e,&2b,&0d
            .byte &9e,&a9,&76,&d8,&c9,&b3,&21,&0d
            .byte &23,&03,&20,&08,&47,&7a,&5c,&a3
            .byte &7f,&a4,&7e,&89,&23,&c9,&4c,&8a
            .byte &7b,&23,&58,&41,&ac,&2e,&2e,&2e
            .byte &0d,&2b,&23,&50,&ab,&53,&53,&3c
            .byte &26,&ab,&54,&55,&52,&4e,&26,&3c
            .byte &76,&b8,&ae,&54,&2e,&2b,&0d,&02
            .byte &d1,&83,&cf,&02,&d2,&83,&d0,&00
            .byte &d3,&83,&d1,&01,&d2,&84,&d4,&01
            .byte &d3,&82,&86,&08,&92,&89,&83,&e2
            .byte &c1,&02,&88,&85,&d8,&02,&d7,&85
            .byte &d9,&02,&d8,&83,&da,&02,&d9,&83
            .byte &db,&82,&da,&10,&98,&01,&66,&02
            .byte &59,&03,&58,&06,&67,&87,&65,&02
            .byte &de,&88,&82,&00,&8a,&02,&4f,&03
            .byte &dd,&04,&8b,&85,&53,&08,&94,&89
            .byte &cf,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&23
            .byte &a5,&c1,&98,&55,&c4,&aa,&b8,&8a
            .byte &0d,&4f,&a3,&0d,&ed,&a6,&76,&22
            .byte &24,&22,&20,&0d,&10,&8f,&22,&25
            .byte &22,&20,&f2,&ac,&53,&2e,&0d,&3d
            .byte &23,&5c,&20,&1e,&12,&9d,&c8,&a3
            .byte &a1,&57,&bb,&c3,&2e,&2e,&2e,&2e
            .byte &3d,&0d,&23,&4f,&4b,&1f,&0d,&2b
            .byte &23,&57,&cd,&be,&4d,&9d,&c2,&2b
            .byte &2b,&22,&23,&c9,&4c,&8a,&7b,&23
            .byte &58,&41,&ac,&22,&2b,&2b,&23,&42
            .byte &59,&3a,&23,&df,&42,&aa,&9f,&23
            .byte &4f,&27,&23,&c3,&ae,&59,&2b,&2b
            .byte &23,&80,&2b,&0d,&23,&ae,&9d,&5c
            .byte &20,&53,&55,&52,&9d,&5c,&20,&57
            .byte &ac,&9f,&76,&24,&3f,&0d,&23,&a5
            .byte &a8,&b5,&9a,&20,&5c,&20,&57,&aa
            .byte &9d,&8e,&4b,&49,&44,&44,&99,&21
            .byte &0d,&23,&42,&59,&45,&21,&0d,&23
            .byte &a5,&d1,&98,&47,&55,&b7,&a4,&10
            .byte &8f,&5c,&20,&57,&ac,&9f,&76,&24
            .byte &21,&0d,&23,&a9,&56,&af,&54,&b9
            .byte &59,&3a,&2b,&20,&2b,&23,&5b,&43
            .byte &ae,&52,&59,&99,&20,&0d,&8a,&05
            .byte &ae,&99,&20,&0d,&ee,&a8,&99,&20
            .byte &0d,&23,&5c,&20,&d1,&98,&71,&20
            .byte &0d,&23,&5b,&c7,&ab,&fd,&a2,&0d
            .byte &23,&5b,&ee,&9f,&0d,&23,&5c,&20
            .byte &d1,&98,&c1,&20,&a8,&b2,&21,&0d
            .byte &89,&25,&21,&0d,&23,&6d,&a1,&46
            .byte &a9,&c7,&2c,&c7,&01,&9a,&a2,&54
            .byte &55,&47,&2c,&89,&25,&20,&49,&a4
            .byte &46,&ab,&e0,&21,&0d,&23,&49,&9f
            .byte &b8,&ae,&54,&a4,&76,&dd,&4f,&53
            .byte &af,&2e,&0d,&23,&89,&25,&20,&71
            .byte &4d,&a4,&49,&4d,&00,&56,&41,&42
            .byte &c3,&21,&0d,&23,&5c,&a3,&48,&8c
            .byte &a4,&ae,&9d,&46,&55,&d7,&21,&0d
            .byte &23,&a1,&d5,&44,&a2,&d1,&9e,&8e
            .byte &cc,&4b,&9d,&03,&20,&4d,&55,&d3
            .byte &2c,&5c,&20,&4b,&ee,&57,&21,&0d
            .byte &ac,&59,&a8,&99,&21,&0d,&23,&4a
            .byte &12,&9f,&91,&20,&a1,&cf,&ab,&43
            .byte &54,&9c,&2e,&0d,&ed,&4c,&44,&99
            .byte &20,&0d,&05,&ae,&99,&20,&0d,&23
            .byte &89,&25,&20,&49,&a4,&49,&4d,&00
            .byte &56,&41,&42,&c3,&21,&0d,&23,&ee
            .byte &a8,&99,&20,&b4,&eb,&af,&53,&2e
            .byte &0d,&23,&5c,&20,&d1,&9e,&71,&20
            .byte &0d,&23,&89,&25,&20,&49,&a4,&ee
            .byte &a8,&99,&20,&53,&ea,&43,&49,&c7
            .byte &2e,&0d,&23,&5c,&20,&c1,&98,&db
            .byte &53,&53,&b7,&a4,&b6,&21,&0d,&23
            .byte &5c,&20,&ca,&45,&a0,&a1,&53,&ed
            .byte &bd,&4c,&20,&76,&24,&21,&0d,&23
            .byte &89,&94,&49,&a4,&c2,&4f,&20,&48
            .byte &ae,&a0,&76,&24,&2e,&0d,&23,&5c
            .byte &20,&d1,&98,&24,&20,&48,&aa,&45
            .byte &2e,&0d,&23,&89,&46,&ab,&45,&5a
            .byte &99,&20,&be,&4c,&a0,&43,&88,&a4
            .byte &5c,&20,&76,&89,&42,&b3,&45,&21
            .byte &0d,&22,&23,&49,&27,&a7,&d0,&f1
            .byte &20,&7b,&a8,&49,&a4,&7f,&22,&2c
            .byte &5c,&20,&53,&43,&ab,&d6,&2c,&8a
            .byte &7a,&a1,&53,&55,&49,&43,&49,&44
            .byte &c7,&20,&46,&ab,&4e,&5a,&59,&2c
            .byte &24,&20,&6e,&89,&50,&a9,&e3,&43
            .byte &c3,&2c,&76,&42,&9d,&50,&55,&4c
            .byte &ea,&a0,&42,&a2,&89,&c0,&ec,&44
            .byte &4c,&a2,&41,&50,&d8,&4f,&41,&d3
            .byte &99,&20,&94,&a1,&46,&45,&a6,&4d
            .byte &e5,&af,&54,&a4,&4c,&b2,&aa,&21
            .byte &0d,&23,&89,&a9,&b1,&e8,&aa,&b2
            .byte &9d,&43,&d4,&4d,&b2,&9d,&b4,&a4
            .byte &08,&be,&4d,&9d,&c2,&4f,&20,&4d
            .byte &55,&d3,&20,&c8,&a3,&5c,&a3,&05
            .byte &ae,&a2,&d5,&44,&59,&2e,&0d,&23
            .byte &5c,&20,&71,&a7,&76,&b4,&56,&9d
            .byte &22,&bf,&50,&ae,&b1,&44,&22,&20
            .byte &8a,&47,&b3,&9d,&76,&89,&47,&ab
            .byte &b2,&2c,&42,&18,&20,&7f,&20,&7a
            .byte &89,&53,&4b,&59,&21,&0d,&23,&5c
            .byte &20,&57,&aa,&9d,&bf,&56,&b5,&ab
            .byte &a0,&42,&a2,&a1,&c0,&8b,&a3,&56
            .byte &49,&43,&49,&9b,&20,&ed,&47,&20
            .byte &7a,&89,&74,&21,&0d,&23,&5c,&20
            .byte &08,&47,&7a,&76,&24,&20,&89,&53
            .byte &ad,&45,&a3,&46,&f6,&45,&2c,&53
            .byte &d4,&50,&20,&8a,&46,&c7,&4c,&2e
            .byte &41,&a4,&5c,&20,&14,&d9,&f2,&54
            .byte &2c,&5c,&20,&53,&43,&ab,&d6,&21
            .byte &8b,&9e,&8b,&52,&9d,&49,&a4,&d0
            .byte &4c,&af,&43,&45,&21,&0d,&23,&89
            .byte &8e,&56,&c9,&49,&da,&9d,&65,&20
            .byte &49,&a4,&0d,&23,&8b,&52,&9d,&ae
            .byte &9d,&56,&c9,&49,&da,&9d,&65,&a4
            .byte &0d,&5d,&2c,&0d,&5e,&2c,&0d,&5f
            .byte &2c,&0d,&60,&2c,&0d,&5d,&5f,&2c
            .byte &0d,&5d,&60,&2c,&0d,&5e,&5f,&2c
            .byte &0d,&5e,&60,&2c,&0d,&19,&2c,&0d
            .byte &67,&2c,&0d,&8a,&0d,&23,&5c,&20
            .byte &24,&20,&8a,&14,&d2,&47,&9d,&4f
            .byte &46,&46,&20,&89,&7c,&2e,&89,&c6
            .byte &a1,&57,&0a,&ad,&a4,&4f,&bd,&a3
            .byte &5c,&a3,&0f,&b2,&54,&aa,&45,&a0
            .byte &e9,&4c,&4b,&2e,&0d,&23,&5c,&20
            .byte &24,&20,&89,&54,&ab,&45,&2c,&c1
            .byte &20,&5c,&a3,&46,&d6,&9b,&20,&41
            .byte &ea,&c5,&9e,&49,&e8,&aa,&53,&b3
            .byte &b2,&9c,&2c,&8a,&24,&20,&67,&20
            .byte &41,&47,&41,&a9,&2e,&57,&13,&21
            .byte &5c,&27,&52,&9d,&03,&20,&c5,&44
            .byte &d1,&50,&21,&0d,&2b,&23,&4d,&b7
            .byte &ef,&dc,&3a,&2b,&3d,&23,&b8,&4f
            .byte &50,&20,&b6,&21,&4c,&bc,&56,&9d
            .byte &4d,&9d,&c7,&b3,&45,&21,&49,&27
            .byte &a7,&7e,&a8,&49,&a4,&50,&cb,&7a
            .byte &08,&99,&20,&53,&55,&52,&ab,&c7
            .byte &c9,&9f,&8f,&89,&4d,&e5,&af,&54
            .byte &2c,&49,&46,&20,&5c,&20,&c1,&98
            .byte &4d,&a9,&44,&21,&3d,&0d,&23,&89
            .byte &b8,&55,&52,&44,&a2,&25,&20,&49
            .byte &a4,&68,&2e,&0d,&23,&89,&b8,&55
            .byte &52,&44,&a2,&25,&20,&49,&a4,&69
            .byte &44,&2e,&0d,&23,&89,&cb,&e8,&20
            .byte &49,&a4,&4f,&46,&46,&2e,&0d,&23
            .byte &89,&cb,&e8,&20,&1b,&52,&4e,&a4
            .byte &6d,&a1,&16,&5a,&5a,&4c,&99,&20
            .byte &a9,&54,&af,&53,&b6,&59,&2e,&0d
            .byte &23,&89,&cb,&e8,&20,&49,&a4,&46
            .byte &fd,&99,&2e,&0d,&23,&89,&cb,&e8
            .byte &20,&ca,&e0,&a4,&4f,&e7,&2e,&0d
            .byte &23,&57,&52,&b6,&9d,&76,&23,&c7
            .byte &49,&43,&45,&21,&0d,&23,&89,&25
            .byte &20,&49,&a4,&c5,&44,&9d,&6e,&a1
            .byte &d4,&9a,&2c,&50,&ab,&43,&49,&9b
            .byte &20,&c7,&dd,&a2,&8a,&08,&ae,&a4
            .byte &89,&e6,&42,&c3,&a7,&7b,&89,&23
            .byte &4b,&b2,&df,&a4,&44,&59,&e3,&b8
            .byte &59,&2e,&0d,&23,&89,&43,&dd,&ff
            .byte &20,&49,&a4,&57,&ae,&4d,&2c,&6d
            .byte &4d,&ac,&a2,&db,&f1,&45,&54,&53
            .byte &2e,&0d,&23,&b8,&4f,&50,&20,&50
            .byte &cb,&59,&99,&20,&6d,&5c,&a3,&25
            .byte &21,&b6,&27,&a4,&42,&41,&a0,&4d
            .byte &ac,&4e,&aa,&53,&21,&0d,&23,&89
            .byte &25,&20,&49,&a4,&46,&0a,&48,&9c
            .byte &45,&a0,&6e,&02,&b3,&2c,&b6,&a4
            .byte &ad,&41,&56,&a2,&4c,&a9,&4b,&a4
            .byte &af,&43,&52,&12,&b1,&a0,&6d,&52
            .byte &12,&9f,&6e,&41,&dc,&a4,&1e,&b8
            .byte &2e,&0d,&23,&a8,&49,&a4,&49,&a4
            .byte &cb,&e8,&20,&25,&2e,&0d,&23,&89
            .byte &25,&20,&ae,&9d,&a1,&4c,&d9,&a9
            .byte &9b,&20,&50,&a9,&4b,&20,&be,&4c
            .byte &b5,&52,&2c,&8a,&4b,&4e,&b6,&b1
            .byte &a0,&b5,&9f,&7b,&a1,&48,&b9,&52
            .byte &49,&42,&c3,&2c,&c5,&9e,&c5,&44
            .byte &9d,&46,&49,&1c,&9d,&28,&41,&a4
            .byte &4f,&50,&db,&c6,&a0,&76,&50,&a9
            .byte &45,&2c,&4f,&a3,&53,&e5,&45,&a8
            .byte &99,&29,&2e,&0d,&23,&8b,&53,&9d
            .byte &ae,&9d,&74,&20,&25,&2e,&0d,&23
            .byte &89,&25,&20,&49,&a4,&a1,&47,&c0
            .byte &56,&9d,&cf,&47,&47,&aa,&27,&53
            .byte &2e,&0d,&23,&4d,&4d,&4d,&21,&8b
            .byte &53,&9d,&57,&aa,&9d,&54,&ab,&c4
            .byte &a2,&7a,&31,&39,&37,&31,&2c,&57
            .byte &aa,&45,&98,&8b,&59,&3f,&14,&b2
            .byte &46,&b9,&4d,&53,&2c,&8a,&c7,&4c
            .byte &20,&a8,&b2,&3f,&0d,&23,&89,&68
            .byte &20,&d9,&42,&ab,&d7,&a1,&43,&b2
            .byte &43,&ad,&a4,&7a,&89,&90,&20,&8a
            .byte &da,&13,&a4,&87,&2e,&0d,&a1,&0d
            .byte &41,&9e,&0d,&53,&e5,&9d,&0d,&a1
            .byte &50,&f4,&a3,&7b,&0d,&2c,&0d,&23
            .byte &89,&25,&20,&ca,&e0,&4c,&9d,&71
            .byte &4d,&a4,&76,&42,&9d,&b8,&55,&f1
            .byte &2e,&0d,&23,&89,&25,&20,&47,&dd
            .byte &57,&a4,&6d,&a1,&62,&9d,&41,&55
            .byte &c0,&21,&89,&ca,&e0,&4c,&9d,&db
            .byte &a9,&54,&a4,&0d,&23,&5c,&20,&46
            .byte &a9,&a0,&0d,&23,&10,&aa,&45,&3f
            .byte &0d,&23,&a5,&d1,&98,&47,&55,&b7
            .byte &53,&21,&0d,&23,&89,&61,&49,&a4
            .byte &ac,&e1,&a2,&8f,&08,&99,&20,&cf
            .byte &b8,&55,&52,&42,&e0,&2e,&0d,&23
            .byte &89,&61,&49,&a4,&44,&bc,&44,&2e
            .byte &0d,&23,&89,&61,&49,&a4,&0a,&c3
            .byte &04,&2e,&0d,&23,&89,&61,&ad,&ae
            .byte &a4,&89,&25,&20,&8a,&46,&c7,&4c
            .byte &a4,&bf,&45,&ea,&a3,&a9,&76,&bb
            .byte &a4,&44,&ab,&d6,&53,&2e,&0d,&23
            .byte &89,&61,&57,&ff,&b7,&2c,&71,&a4
            .byte &5c,&20,&8a,&7a,&41,&9e,&a9,&b8
            .byte &ac,&54,&2c,&b4,&a4,&44,&c0,&57
            .byte &9e,&bb,&a4,&01,&9a,&a2,&fc,&b9
            .byte &44,&2e,&6d,&a1,&53,&99,&c3,&2c
            .byte &46,&cb,&0f,&99,&20,&da,&13,&2c
            .byte &89,&c0,&5a,&b9,&2d,&e0,&47,&9d
            .byte &7b,&89,&57,&bc,&50,&7e,&53,&d4
            .byte &43,&45,&a4,&a8,&52,&b5,&de,&20
            .byte &5c,&a3,&ca,&f1,&2c,&8a,&5c,&a3
            .byte &ad,&41,&a0,&df,&d7,&53,&2c,&d4
            .byte &46,&45,&82,&4c,&59,&2c,&c7,&b3
            .byte &47,&20,&89,&46,&dd,&b9,&2e,&0d
            .byte &23,&89,&61,&0f,&b5,&54,&a4,&8f
            .byte &5c,&20,&c8,&a3,&cf,&b8,&55,&52
            .byte &42,&99,&20,&bb,&a7,&8a,&4c,&bc
            .byte &56,&b7,&2c,&43,&dd,&53,&99,&20
            .byte &89,&c1,&4f,&a3,&08,&48,&a9,&a0
            .byte &bb,&4d,&2e,&0d,&23,&a5,&c1,&98
            .byte &4b,&ee,&a6,&b6,&2e,&43,&b5,&4c
            .byte &a0,&5c,&20,&e9,&a7,&49,&9f,&c8
            .byte &a3,&f2,&3f,&0d,&23,&5c,&20,&53
            .byte &99,&20,&89,&cb,&b1,&53,&9f,&4e
            .byte &d9,&08,&a3,&42,&a2,&89,&46,&d6
            .byte &9b,&20,&ad,&41,&56,&a2,&f2,&54
            .byte &c7,&20,&e1,&b5,&50,&2c,&23,&55
            .byte &52,&ac,&49,&55,&a7,&23,&a8,&55
            .byte &c4,&aa,&d5,&4c,&54,&2c,&56,&aa
            .byte &a2,&4c,&b5,&44,&4c,&59,&2e,&0d
            .byte &23,&5c,&20,&53,&99,&20,&a1,&42
            .byte &bc,&55,&b0,&46,&55,&4c,&20,&4c
            .byte &55,&4c,&cb,&42,&a2,&41,&42,&b5
            .byte &9f,&53,&4b,&49,&eb,&99,&20,&a8
            .byte &52,&b5,&de,&20,&a1,&4d,&bc,&c1
            .byte &57,&2c,&47,&41,&8b,&52,&99,&20
            .byte &46,&dd,&57,&aa,&53,&2e,&89,&57
            .byte &b9,&4c,&a0,&71,&4d,&a4,&a1,&08
            .byte &54,&b1,&a3,&50,&cb,&43,&45,&2e
            .byte &0d,&23,&5c,&20,&e1,&49,&50,&20
            .byte &89,&43,&b4,&7a,&b0,&9a,&4c,&a2
            .byte &8a,&b8,&ae,&9f,&76,&54,&57,&c9
            .byte &9f,&49,&9f,&ae,&b5,&4e,&a0
l4c50:      .byte &89,&47,&55,&ae,&44,&27,&a4,&ca
            .byte &f1,&2e,&41,&a4,&89,&cb,&53,&9f
            .byte &42,&ab,&41,&a8,&20,&7b,&d4,&46
            .byte &9d,&49,&a4,&53,&f0,&0b,&5a,&45
            .byte &a0,&6e,&bb,&a4,&d5,&44,&59,&2c
            .byte &48,&9d,&fe,&d9,&50,&a4,&76,&89
            .byte &46,&dd,&b9,&2e,&0d,&23,&5c,&20
            .byte &ca,&45,&a0,&a1,&57,&bc,&50,&b3
            .byte &2e,&0d,&23,&89,&61,&da,&4f,&f1
            .byte &a4,&5c,&a3,&57,&1f,&2e,&0d,&23
            .byte &89,&ac,&43,&49,&af,&9f,&43,&b4
            .byte &7a,&44,&c9,&03,&4c,&bd,&a4,&a9
            .byte &76,&a1,&50,&e7,&9d,&7b,&17,&b8
            .byte &2c,&57,&bb,&d3,&20,&4d,&99,&c3
            .byte &a4,&6d,&89,&53,&55,&52,&52,&b5
            .byte &c4,&99,&20,&cf,&52,&9f,&8a,&49
            .byte &a4,&dd,&53,&9f,&c8,&ab,&56,&aa
            .byte &21,&0d,&23,&a1,&61,&68,&a4,&89
            .byte &c1,&4f,&a3,&8a,&af,&54,&aa,&a4
            .byte &89,&6a,&2e,&0d,&23,&89,&c1,&4f
            .byte &a3,&49,&a4,&68,&2e,&0d,&23,&89
            .byte &c1,&4f,&a3,&49,&a4,&69,&44,&2e
            .byte &0d,&23,&89,&c1,&4f,&a3,&49,&a4
            .byte &6b,&2e,&0d,&23,&89,&c1,&4f,&a3
            .byte &53,&cb,&4d,&a4,&53,&e9,&9f,&08
            .byte &48,&a9,&a0,&5c,&21,&0d,&23,&5c
            .byte &20,&24,&20,&89,&25,&2e,&0d,&23
            .byte &89,&25,&20,&49,&a4,&b5,&9f,&7b
            .byte &ab,&41,&d3,&21,&0d,&23,&49,&9f
            .byte &49,&a4,&50,&b6,&d3,&20,&74,&2e
            .byte &0d,&23,&89,&25,&20,&ae,&9d,&e6
            .byte &42,&df,&49,&44,&aa,&45,&a0,&6d
            .byte &89,&ae,&4d,&a4,&7b,&23,&4b,&b2
            .byte &df,&53,&2e,&0d,&23,&89,&25,&20
            .byte &57,&41,&a4,&c5,&44,&9d,&7a,&23
            .byte &b1,&58,&0a,&21,&0d,&23,&4a,&12
            .byte &9f,&5c,&a3,&d0,&5a,&45,&21,&0d
            .byte &23,&89,&25,&20,&49,&a4,&52,&b5
            .byte &de,&2c,&c0,&47,&dc,&a0,&8a,&46
            .byte &e7,&a8,&a2,&6d,&d8,&c9,&7e,&cf
            .byte &52,&54,&2e,&0d,&23,&8b,&9e,&5c
            .byte &20,&b8,&d6,&50,&20,&89,&bf,&1c
            .byte &49,&a4,&b5,&9f,&7b,&f9,&49,&b8
            .byte &af,&43,&45,&21,&0d,&23,&89,&25
            .byte &20,&49,&a4,&53,&c5,&d7,&2e,&41
            .byte &9e,&a9,&53,&43,&52,&49,&50,&b0
            .byte &7e,&ab,&fd,&53,&3a,&22,&23,&a8
            .byte &49,&a4,&25,&20,&b4,&a4,&a1,&c5
            .byte &58,&49,&4d,&55,&a7,&93,&20,&d1
            .byte &50,&f6,&b6,&a2,&7b,&34,&35,&2e
            .byte &34,&36,&20,&4c,&b6,&ab,&53,&22
            .byte &2e,&0d,&23,&5c,&20,&ca,&45,&a0
            .byte &93,&2e,&0d,&23,&46,&49,&d7,&20
            .byte &a1,&43,&b3,&cc,&a9,&aa,&2e,&0d
            .byte &23,&89,&48,&8f,&49,&a4,&46,&55
            .byte &d7,&21,&0d,&23,&5c,&20,&d1,&98
            .byte &f5,&20,&24,&2e,&0d,&23,&b5,&d3
            .byte &21,&5c,&20,&57,&c7,&4b,&45,&a0
            .byte &a9,&76,&a1,&db,&a9,&b1,&a0,&b8
            .byte &c7,&f6,&b0,&54,&9d,&7a,&89,&74
            .byte &21,&0d,&27,&23,&aa,&45,&2c,&b8
            .byte &4f,&50,&20,&db,&4b,&99,&20,&f2
            .byte &2c,&5c,&20,&43,&ad,&45,&4b,&a2
            .byte &25,&21,&0d,&23,&b6,&27,&a4,&a1
            .byte &1a,&9f,&00,&a8,&2d,&45,&b2,&af
            .byte &21,&0d,&23,&89,&25,&20,&49,&a4
            .byte &af,&43,&52,&12,&b1,&a0,&6d,&17
            .byte &1a,&b7,&21,&0d,&23,&89,&25,&20
            .byte &49,&a4,&43,&c0,&46,&b1,&a0,&6e
            .byte &db,&4c,&c9,&ad,&a0,&d0,&4c,&56
            .byte &aa,&21,&0d,&23,&a8,&49,&a4,&25
            .byte &20,&dd,&4f,&4b,&a4,&d4,&4b,&9d
            .byte &54,&ab,&0a,&55,&ab,&21,&0d,&23
            .byte &89,&25,&20,&52,&b2,&54,&c3,&a4
            .byte &57,&ad,&9e,&5c,&20,&53,&b4,&4b
            .byte &9d,&b6,&2e,&0d,&23,&89,&25,&20
            .byte &49,&a4,&46,&0a,&48,&9c,&45,&a0
            .byte &6e,&43,&4c,&bc,&a3,&43,&52,&59
            .byte &b8,&c7,&21,&0d,&23,&89,&25,&20
            .byte &49,&a4,&c5,&44,&9d,&7b,&32,&32
            .byte &20,&43,&ae,&8f,&f5,&4c,&44,&21
            .byte &0d,&23,&8b,&a2,&ae,&9d,&c0,&47
            .byte &dc,&44,&2c,&1b,&9f,&43,&c3,&ac
            .byte &2e,&0d,&23,&89,&25,&20,&49,&a4
            .byte &b8,&52,&d2,&47,&20,&6d,&0f,&a9
            .byte &99,&20,&ea,&ae,&4c,&53,&21,&0d
            .byte &23,&89,&25,&20,&b4,&a4,&a1,&4c
            .byte &ae,&47,&9d,&ef,&eb,&bb,&ab,&21
            .byte &0d,&23,&b6,&27,&a4,&a1,&23,&50
            .byte &aa,&d0,&41,&9e,&25,&21,&0d,&23
            .byte &4d,&4d,&4d,&21,&c1,&98,&5c,&20
            .byte &4a,&12,&9f,&dd,&56,&9d,&81,&46
            .byte &ab,&0f,&2c,&43,&ae,&d5,&d4,&43
            .byte &20,&ae,&4f,&c5,&3f,&0d,&23,&5c
            .byte &20,&24,&20,&4c,&b3,&47,&20,&8a
            .byte &bf,&04,&2c,&8a,&55,&ca,&ae
l4f4f:      .byte &a8,&20,&a1,&57,&49,&8b,&ab,&a0
            .byte &43,&b9,&50,&c6,&2c,&57,&bb,&d3
            .byte &20,&44,&c9,&03,&4c,&bd,&a4,&a9
            .byte &76,&a1,&50,&e7,&9d,&7b,&44,&12
            .byte &9f,&8a,&49,&a4,&53,&43,&b2,&54
            .byte &aa,&45,&a0,&42,&a2,&89,&46,&b5
            .byte &a3,&90,&53,&21,&0d,&23,&89,&53
            .byte &8a,&49,&a4,&0e,&a2,&8a,&89,&ed
            .byte &4c,&9d,&f0,&49,&f1,&4c,&a2,&46
            .byte &49,&d7,&a4,&a9,&2e,&0d,&23,&89
            .byte &44,&d6,&50,&20,&53,&8a,&49,&a4
            .byte &46,&02,&a7,&8a,&5c,&20,&24,&20
            .byte &a1,&4c,&ae,&47,&9d,&50,&b6,&2e
            .byte &0d,&23,&6d,&89,&74,&20,&47,&cb
            .byte &53,&c6,&a4,&b3,&2c,&89,&4d,&c9
            .byte &9f,&c2,&54,&c7,&4c,&a2,&4f,&42
            .byte &53,&43,&55,&ab,&a4,&5c,&a3,&56
            .byte &c9,&9c,&2e,&5c,&20,&07,&49,&50
            .byte &20,&8a,&ae,&9d,&43,&b3,&43,&12
            .byte &c6,&a0,&41,&a4,&5c,&20,&bb,&9f
            .byte &89,&46,&dd,&b9,&2e,&57,&ad,&9e
            .byte &5c,&20,&57,&ff,&45,&2c,&5c,&20
            .byte &46,&a9,&a0,&5c,&52,&c6,&4c,&46
            .byte &20,&8f,&89,&c8,&4f,&9f,&7b,&89
            .byte &88,&2c,&5c,&a3,&db,&53,&53,&b7
            .byte &53,&9c,&a4,&47,&b3,&45,&21,&0d
            .byte &23,&f5,&a0,&ad,&4c,&50,&a4,&a8
            .byte &4f,&53,&9d,&57,&ed,&20,&ad,&4c
            .byte &50,&20,&8b,&4d,&c6,&4c,&56,&b7
            .byte &21,&0d,&22,&23,&a5,&ab,&be,&47
            .byte &4e,&c9,&9d,&0d,&81,&ef,&f1,&99
            .byte &21,&0d,&a8,&4f,&53,&9d,&47,&dd
            .byte &56,&b7,&2e,&8b,&59,&27,&52,&9d
            .byte &89,&23,&4b,&99,&27,&53,&21,&0d
            .byte &81,&b4,&02,&21,&0d,&a8,&4f,&53
            .byte &9d,&46,&55,&52,&b0,&56,&9d,&45
            .byte &59,&b7,&21,&0d,&81,&54,&b9,&03
            .byte &21,&0d,&a8,&4f,&53,&9d,&42,&8c
            .byte &a2,&c3,&47,&53,&21,&0d,&a8,&4f
            .byte &53,&9d,&ac,&4b,&4c,&b7,&21,&0d
            .byte &a8,&4f,&53,&9d,&46,&0b,&54,&21
            .byte &0d,&a8,&4f,&53,&9d,&48,&8c,&53
            .byte &21,&0d,&23,&5c,&20,&42,&9d,&89
            .byte &44,&b7,&50,&aa,&b2,&9d,&43,&52
            .byte &49,&4d,&a9,&c7,&20,&6e,&89,&6c
            .byte &53,&2c,&59,&b3,&44,&aa,&21,&5c
            .byte &27,&d7,&20,&ee,&9f,&be,&4d,&9d
            .byte &41,&d5,&ae,&a0,&4d,&a2,&95,&22
            .byte &2c,&0f,&b5,&54,&a4,&89,&23,&d1
            .byte &50,&cc,&a9,&2c,&8a,&b0,&45,&a4
            .byte &5c,&a3,&ca,&f1,&20,&a9,&76,&56
            .byte &ae,&49,&9b,&20,&ef,&e7,&b9,&27
            .byte &a4,&4b,&ee,&54,&53,&21,&0d,&22
            .byte &23,&ad,&d7,&4f,&20,&8b,&ab,&2c
            .byte &62,&aa,&21,&5c,&27,&d7,&20,&42
            .byte &9d,&57,&ac,&54,&a9,&27,&20,&50
            .byte &0a,&ef,&47,&9d,&7e,&4d,&a2,&56
            .byte &b7,&c6,&4c,&2c,&57,&49,&d7,&20
            .byte &27,&45,&3f,&44,&df,&50,&20,&5c
            .byte &a3,&79,&67,&20,&8b,&ab,&2c,&c8
            .byte &a3,&1e,&59,&4d,&af,&54,&2c,&d4
            .byte &4b,&45,&22,&2c,&0d,&ef,&59,&a4
            .byte &89,&23,&d1,&50,&cc,&a9,&2e,&0d
            .byte &22,&23,&19,&20,&5c,&a3,&db,&4f
            .byte &50,&20,&bf,&f1,&2c,&c5,&b1,&59
            .byte &21,&a5,&57,&ac,&9f,&4d,&b9,&9d
            .byte &54,&ab,&0a,&55,&ab,&22,&2c,&0d
            .byte &22,&23,&53,&bb,&bd,&a3,&4d,&9d
            .byte &b0,&4d,&42,&aa,&53,&21,&a8,&b2
            .byte &27,&d7,&20,&c1,&20,&4e,&49,&43
            .byte &cd,&59,&2c,&d0,&52,&22,&2c,&0d
            .byte &23,&50,&ab,&53,&53,&3c,&26,&ab
            .byte &54,&55,&52,&4e,&26,&3c,&c8,&a3
            .byte &ac,&4f,&8b,&a3,&47,&d6,&45,&2e
            .byte &0d,&22,&23,&ad,&d7,&4f,&21,&c7
            .byte &a8,&b5,&de,&20,&23,&49,&27,&a7
            .byte &a1,&08,&47,&47,&ae,&2c,&23,&49
            .byte &27,&a7,&41,&a4,&d3,&e2,&53,&a2
            .byte &41,&a4,&0c,&aa,&59,&b3,&9d,&cd
            .byte &c6,&2c,&4f,&4b,&1f,&3f,&03,&20
            .byte &4a,&12,&9f,&44,&df,&50,&20,&0d
            .byte &53,&e5,&9d,&c8,&4f,&a0,&0d,&a1
            .byte &42,&41,&a3,&7b,&03,&41,&50,&20
            .byte &0d,&a1,&da,&ac,&4b,&45,&9f,&0d
            .byte &67,&20,&8b,&52,&9d,&c8,&a3,&f2
            .byte &22,&2c,&ef,&59,&a4,&89,&08,&47
            .byte &47,&ae,&2e,&0d,&22,&23,&bb,&21
            .byte &49,&27,&56,&9d,&b4,&a0,&a1,&57
            .byte &0a,&48,&22,&2c,&ef,&59,&a4,&89
            .byte &08,&47,&47,&ae,&2c,&57,&41,&56
            .byte &99,&20,&89,&03,&41,&50,&2e,&0d
            .byte &23,&41,&9e,&4f,&42,&4a,&45,&43
            .byte &9f,&46,&c7,&4c,&a4,&76,&89,&46
            .byte &dd,&b9,&21,&0d,&22,&23,&08,&d1
            .byte &12,&9d,&5c,&27,&56,&9d,&08,&45
            .byte &9e,&03,&20,&4e,&49,&43,&9d,&76
            .byte &f2,&2c,&b4,&56,&9d,&8b,&53,&9d
            .byte &4d,&b6,&54,&af,&53,&22,&2c,&ef
            .byte &59,&a4,&89,&08,&47,&47,&ae,&2c
            .byte &47,&af,&aa,&9b,&4c,&59,&2e,&0d
            .byte &23,&89,&1b,&e7,&44,&99,&20,&ab
            .byte &53,&b5,&c4,&a4,&6d,&a1,&dd,&a6
            .byte &50,&b6,&43,&ad,&a0,&e9,&a7,&41
            .byte &a4,&89,&c5,&53,&d0,&56,&9d,&c1
            .byte &4f,&a3,&53,&dd,&57,&4c,&a2,&68
            .byte &53,&2c,&ab,&56,&bc,&4c,&99,&2c
            .byte &41,&a4,&49,&9f,&c1,&45,&a4,&03
            .byte &2c,&89,&cf,&4d,&4c,&a2,&d4,&9f
            .byte &a9,&54,&aa,&49,&4f,&a3,&7b,&89
            .byte &97,&21,&0d,&23,&57,&cd,&4c,&20
            .byte &44,&b3,&45,&21,&5c,&20,&b4,&56
            .byte &9d,&be,&e8,&c3,&b1,&a0,&22,&23
            .byte &c9,&4c,&8a,&7b,&23,&58,&41,&ac
            .byte &22,&20,&8a,&b4,&56,&9d,&a1,&c5
            .byte &58,&49,&4d,&55,&a7,&53,&43,&b9
            .byte &9d,&7b,&32,&35,&30,&20,&db,&a9
            .byte &54,&53,&21,&0d,&53,&21,&0d,&22
            .byte &23,&ad,&d7,&4f,&20,&8b,&ab,&2c
            .byte &62,&23,&89,&54,&ab,&4d,&af,&44
            .byte &9b,&20,&db,&05,&a3,&7b,&89,&93
            .byte &46,&c7,&4c,&20,&46,&b9,&43,&45
            .byte &a4,&5c,&20,&76,&5c,&a3,&4b,&ca
            .byte &45,&a4,&8a,&5c,&20,&be,&4c,&cb
            .byte &50,&c6,&2c,&42,&ab,&41,&a8,&82
            .byte &4c,&59,&2c,&76,&89,&46,&dd,&b9
            .byte &21,&5c,&20,&47,&4c,&ac,&43,&9d
            .byte &5d,&57,&ae,&44,&a4,&8a,&c5,&4b
            .byte &9d,&b5,&9f,&89,&b4,&5a,&a2,&53
            .byte &b4,&50,&9d,&7b,&a1,&77,&20,&af
            .byte &07,&ac,&43,&9d,&08,&59,&b3,&44
            .byte &2e,&8b,&9e,&0c,&aa,&59,&a8,&99
            .byte &20,&f5,&45,&a4,&42,&cb,&f1,&2e
            .byte &0d,&23,&5b,&d2,&bf,&a3,&89,&43
            .byte &c0,&0f,&99,&20,&93,&46,&c7,&4c
            .byte &2c,&89,&68,&20,&d9,&42,&ab,&d7
            .byte &a1,&ad,&4c,&a0,&ef,&46,&cd,&a2
            .byte &6f,&5c,&2e,&89,&10,&b6,&9d,&93
            .byte &20,&52,&12,&ad,&a4,&1e,&b8,&2c
            .byte &b6,&a4,&53,&50,&c0,&a2,&03,&ff
            .byte &99,&20,&5c,&20,&76,&89,&53,&4b
            .byte &a9,&2e,&a8,&52,&b5,&de,&20,&89
            .byte &05,&9f,&b4,&5a,&45,&2c,&76,&89
            .byte &5d,&2c,&5c,&20,&71,&20,&89,&af
            .byte &07,&ac,&43,&9d,&76,&a1,&74,&20
            .byte &77,&2e,&0d,&23,&5b,&7a,&a1,&53
            .byte &c5,&d7,&2c,&cf,&4d,&4c,&a2,&d4
            .byte &9f,&6c,&2c,&46,&e7,&c3,&a0,&6d
            .byte &89,&b8,&af,&d3,&20,&7b,&44,&bc
            .byte &a8,&20,&8a,&bf,&d1,&59,&2e,&89
            .byte &e4,&e2,&a8,&2c,&e1,&ac,&b6,&9d
            .byte &64,&a4,&71,&a7,&76,&69,&20,&7a
            .byte &7e,&5c,&2c,&66,&82,&20,&8a,&4d
            .byte &af,&f6,&99,&21,&76,&89,&5d,&20
            .byte &dd,&e5,&a4,&a1,&e9,&dc,&2c,&02
            .byte &7e,&c1,&b9,&2e,&0d,&23,&5b,&8f
            .byte &a1,&44,&bc,&a0,&af,&a0,&7a,&89
            .byte &43,&b9,&8d,&b9,&2e,&89,&6c,&a4
            .byte &5e,&20,&7b,&5c,&20,&06,&56,&9d
            .byte &57,&41,&a2,&76,&52,&b5,&de,&2c
            .byte &1c,&49,&f1,&20,&64,&53,&2c,&8a
            .byte &89,&43,&45,&e7,&99,&20,&49,&a4
            .byte &03,&20,&dd,&57,&2c,&81,&5b,&46
            .byte &b9,&43,&45,&a0,&76,&b8,&e2,&50
            .byte &2e,&0d,&23,&5b,&7a,&a1,&4c,&b3
            .byte &47,&2c,&5f,&2d,&60,&20,&43,&b9
            .byte &8d,&b9,&2e,&f8,&8b,&a3,&78,&20
            .byte &7b,&5c,&2c,&6b,&20,&6c,&a4,&b8
            .byte &ab,&54,&d3,&20,&a9,&76,&89,&47
            .byte &dd,&e5,&2e,&0d,&23,&5b,&8f,&89
            .byte &60,&aa,&9e,&af,&a0,&7b,&89,&4c
            .byte &b3,&47,&20,&43,&b9,&8d,&b9,&2e
            .byte &5e,&20,&7b,&5b,&89,&cb,&53,&9f
            .byte &7b,&89,&6b,&20,&6c,&53,&2e,&a1
            .byte &4e,&ae,&df,&a6,&ae,&d3,&57,&41
            .byte &a2,&49,&a4,&4a,&12,&9f,&56,&c9
            .byte &49,&da,&9d,&d6,&b3,&47,&53,&9f
            .byte &89,&53,&b4,&c1,&57,&a4,&7b,&89
            .byte &5d,&20,&64,&2e,&0d,&23,&5b,&7a
            .byte &a1,&54,&57,&49,&b8,&99,&20,&7d
            .byte &20,&7b,&45,&d3,&4f,&99,&20,&43
            .byte &b9,&8d,&b9,&53,&2e,&bc,&d3,&20
            .byte &53,&b5,&4e,&a0,&5c,&20,&c5,&4b
            .byte &9d,&71,&4d,&a4,&d6,&50,&d4,&46
            .byte &49,&45,&a0,&41,&a4,&49,&9f,&42
            .byte &b5,&4e,&43,&45,&a4,&08,&54,&05
            .byte &45,&9e,&89,&be,&4c,&44,&2c,&df
            .byte &f1,&20,&64,&53,&21,&0d,&23,&5b
            .byte &7a,&89,&61,&6a,&20,&7b,&89,&4b
            .byte &45,&04,&2e,&d4,&9a,&20,&b8,&ab
            .byte &d6,&a4,&7a,&6e,&41,&9e,&68,&20
            .byte &c1,&b9,&57,&41,&a2,&76,&89,&5d
            .byte &2c,&ab,&41,&d3,&99,&20,&0c,&aa
            .byte &a2,&43,&b9,&4e,&aa,&2c,&53,&ed
            .byte &57,&99,&20,&89,&46,&e7,&a8,&20
            .byte &8a,&53,&f0,&c7,&4f,&a3,&81,&41
            .byte &42,&b5,&c4,&53,&21,&a1,&53,&43
            .byte &17,&46,&46,&a2,&61,&49,&a4,&53
            .byte &c3,&04,&99,&20,&7e,&a1,&48,&ae
            .byte &44,&2c,&57,&e2,&bf,&9e,&42,&af
            .byte &d3,&20,&c6,&9f,&a9,&76,&89,&5d
            .byte &20,&64,&2e,&0d,&23,&5b,&7e,&a1
            .byte &88,&c2,&50,&20,&5d,&20,&7b,&89
            .byte &4b,&45,&04,&2c,&dd,&4f,&4b,&99
            .byte &20,&67,&20,&a1,&44,&ac,&47,&aa
            .byte &9b,&20,&53,&43,&ab,&9d,&53,&dd
            .byte &50,&9d,&76,&a1,&74,&20,&73,&08
            .byte &59,&b3,&44,&2e,&0d,&23,&5b,&7e
            .byte &89,&88,&c2,&50,&20,&5d,&60,&20
            .byte &7b,&89,&4b,&45,&04,&2e,&76,&89
            .byte &5d,&2c,&67,&20,&89,&88,&2c,&89
            .byte &74,&20,&73,&53,&50,&ab,&fd,&a4
            .byte &f6,&df,&53,&a4,&a1,&56,&c7,&c3
            .byte &59,&2e,&0d,&23,&5b,&7e,&89,&88
            .byte &c2,&50,&20,&5d,&5f,&20,&7b,&89
            .byte &4b,&45,&04,&2e,&5d,&2c,&67,&20
            .byte &89,&88,&2c,&49,&a4,&89,&c8,&ab
            .byte &b8,&2e,&0d,&23,&5b,&7e,&a1,&be
            .byte &42,&42,&c3,&a0,&75,&57,&41,&a2
            .byte &4c,&bc,&44,&99,&20,&5e,&60,&20
            .byte &76,&5d,&5f,&20,&67,&20,&89,&88
            .byte &2e,&0d,&23,&5b,&7e,&a1,&be,&42
            .byte &42,&c3,&a0,&75,&57,&41,&a2,&57
            .byte &bb,&d3,&20,&4c,&bc,&44,&a4,&5e
            .byte &5f,&20,&76,&5d,&60,&20,&67,&20
            .byte &89,&88,&2e,&0d,&23,&5b,&7a,&a1
            .byte &84,&20,&60,&20,&7b,&89,&4b,&45
            .byte &04,&2e,&bb,&de,&20,&64,&a4,&97
            .byte &20,&f8,&8b,&a3,&78,&20,&7b,&5c
            .byte &2c,&0f,&52,&b5,&44,&99,&20,&5c
            .byte &20,&7a,&a1,&bf,&04,&2c,&be,&4c
            .byte &a0,&53,&b4,&c1,&57,&2e,&0d,&23
            .byte &5b,&7a,&a1,&bb,&de,&20,&64,&45
            .byte &a0,&83,&5f,&20,&7b,&89,&4b,&45
            .byte &04,&2e,&89,&64,&a4,&b4,&56,&9d
            .byte &08,&45,&9e,&57,&b9,&9e,&e4,&e2
            .byte &a8,&20,&4f,&bd,&a3,&89,&47,&af
            .byte &aa,&b2,&9c,&a4,&8a,&ae,&9d,&d2
            .byte &53,&55,&52,&4d,&b5,&ba,&41,&42
            .byte &c3,&2e,&0d,&23,&5b,&7a,&a1,&64
            .byte &45,&a0,&84,&20,&60,&20,&7b,&89
            .byte &4b,&45,&04,&2e,&a1,&43,&88,&20
            .byte &42,&ab,&45,&5a,&9d,&ab,&44,&44
            .byte &af,&a4,&5c,&a3,&46,&f6,&45,&2e
            .byte &0d,&23,&5b,&7a,&a1,&64,&45,&a0
            .byte &83,&5f,&20,&7b,&89,&4b,&45,&04
            .byte &2e,&a1,&0f,&ae,&50,&20,&42,&ab
            .byte &45,&5a,&9d,&57,&bb,&b8,&c3,&a4
            .byte &19,&20,&89,&83,&6e,&89,&5e,&2e
            .byte &0d,&23,&5b,&7e,&a1,&7c,&c2,&50
            .byte &20,&5e,&60,&20,&7b,&89,&4b,&45
            .byte &04,&2e,&89,&b8,&52,&b3,&47,&20
            .byte &90,&20,&cb,&53,&ad,&a4,&89,&c6
            .byte &a1,&a9,&76,&a1,&54,&55,&52,&00
            .byte &e7,&2c,&53,&af,&44,&99,&20,&53
            .byte &55,&52,&46,&20,&19,&20,&89,&4a
            .byte &41,&47,&dc,&a0,&7c,&2d,&46,&f6
            .byte &45,&2e,&0d,&23,&5b,&7e,&a1,&4e
            .byte &ae,&df,&a6,&c3,&44,&47,&9d,&5e
            .byte &20,&7b,&89,&4b,&45,&04,&2c,&bb
            .byte &de,&20,&6f,&89,&c0,&47,&99,&20
            .byte &53,&bc,&2e,&89,&90,&20,&da,&13
            .byte &a4,&48,&ae,&a0,&8a,&46,&b9,&43
            .byte &45,&a4,&5c,&20,&92,&41,&47,&41
            .byte &a9,&53,&9f,&89,&4b,&45,&04,&20
            .byte &64,&2c,&87,&20,&6e,&89,&bf,&1c
            .byte &49,&a4,&a8,&df,&57,&9e,&19,&20
            .byte &42,&a2,&89,&57,&0a,&48,&20,&41
            .byte &a4,&49,&9f,&43,&c0,&53,&ad,&a4
            .byte &a9,&76,&89,&53,&ad,&45,&a3,&7c
            .byte &2e,&0d,&23,&5b,&5e,&5f,&20,&7b
            .byte &89,&4b,&45,&04,&2c,&7e,&a1,&50
            .byte &a9,&e3,&43,&4c,&9d,&4f,&56,&aa
            .byte &dd,&4f,&4b,&99,&20,&89,&53,&bc
            .byte &2e,&89,&fc,&02,&4c,&99,&20,&90
            .byte &20,&ed,&57,&4c,&a4,&ae,&b5,&4e
            .byte &a0,&5c,&2c,&42,&b6,&99,&20,&5c
            .byte &a3,&11,&b7,&48,&20,&8a,&46,&ab
            .byte &45,&5a,&99,&20,&5c,&a3,&42,&ab
            .byte &41,&a8,&21,&0d,&23,&5b,&7e,&a1
            .byte &50,&cb,&7a,&4f,&56,&aa,&dd,&4f
            .byte &4b,&99,&20,&a1,&c0,&4d,&53,&b4
            .byte &f1,&4c,&9d,&47,&c0,&bd,&59,&ae
            .byte &44,&2e,&89,&90,&20,&ec,&f1,&a4
            .byte &19,&20,&46,&a9,&9d,&44,&12,&9f
            .byte &57,&bb,&d3,&20,&be,&56,&aa,&a4
            .byte &5c,&20,&6e,&ad,&41,&a0,&76,&c2
            .byte &45,&2c,&8a,&c5,&4b
l5844:      .byte &45,&a4,&5c,&20,&71,&a7,&de,&4f
            .byte &b8,&4c,&a2,&57,&bb,&b1,&2e,&0d
            .byte &23,&5b,&bb,&de,&20,&6f,&a1,&90
            .byte &fc,&04,&9f,&50,&cb,&a9,&2c,&dd
            .byte &4f,&4b,&99,&20,&67,&20,&6e,&a1
            .byte &df,&f1,&a2,&50,&ab,&43,&49,&ec
            .byte &43,&45,&2e,&89,&b8,&52,&b3,&47
            .byte &20,&90,&20,&52,&12,&ad,&a4,&50
            .byte &0a,&9f,&5c,&2c,&a8,&52,&b5,&de
            .byte &20,&a1,&dd,&a6,&ae,&d3,&57,&41
            .byte &a2,&76,&89,&5d,&2c,&8a,&a9,&76
            .byte &89,&4d,&55,&b8,&a2,&77,&53,&2e
            .byte &0d,&23,&5b,&7e,&a1,&50,&ab,&43
            .byte &49,&ec,&43,&9d,&46,&41,&a3,&6f
            .byte &a1,&ea,&42,&da,&9d,&42,&bc,&d3
            .byte &2e,&89,&da,&55,&b8,&aa,&a2,&90
            .byte &20,&fc,&02,&4c,&a4,&ae,&b5,&4e
            .byte &a0,&5c,&2c,&d1,&12,&99,&20,&5c
            .byte &20,&76,&b1,&45,&b1,&a3,&50,&ab
            .byte &43,&ae,&49,&9b,&4c,&a2,&7e,&89
            .byte &e0,&dc,&21,&0d,&23,&5b,&7e,&a1
            .byte &47,&55,&b8,&a2,&7c,&c2,&50,&20
            .byte &dd,&4f,&4b,&99,&20,&b5,&9f,&f6
            .byte &df,&53,&a4,&89,&53,&bc,&2e,&46
            .byte &41,&a3,&70,&5c,&20,&49,&a4,&a1
            .byte &57,&e2,&bf,&9e,&4a,&45,&54,&f3
            .byte &2c,&60,&20,&7b,&57,&bb,&d3,&20
            .byte &49,&a4,&4d,&e2,&ab,&a0,&a1,&ef
            .byte &e7,&99,&20,&95,&2e,&0d,&23,&5b
            .byte &7e,&a1,&ea,&42,&da,&9d,&85,&8f
            .byte &89,&c8,&4f,&9f,&7b,&a1,&53,&b1
            .byte &04,&20,&7c,&2e,&a1,&53,&c7,&54
            .byte &a2,&42,&ab,&45,&5a,&9d,&da,&13
            .byte &a4,&7a,&6e,&89,&53,&bc,&2e,&0d
            .byte &23,&5b,&7e,&a1,&ea,&42,&da,&9d
            .byte &42,&bc,&d3,&2c,&d2,&bf,&a3,&a1
            .byte &bb,&de,&20,&7c,&2c,&ca,&58,&9f
            .byte &76,&89,&52,&b5,&de,&20,&53,&bc
            .byte &2e,&89,&90,&20,&49,&a4,&b8,&52
            .byte &b3,&47,&2e,&0d,&23,&5b,&7e,&a1
            .byte &54,&ab,&45,&82,&20,&75,&20,&8f
            .byte &89,&c8,&4f,&9f,&7b,&a1,&bb,&de
            .byte &20,&4d,&b5,&ba,&41,&a9,&2e,&b8
            .byte &ae,&99,&20,&19,&2c,&b6,&a4,&53
            .byte &b1,&04,&20,&64,&a4,&71,&a7,&76
            .byte &44,&c9,&41,&eb,&bc,&a3,&a9,&76
            .byte &89,&43,&4c,&b5,&44,&a2,&53,&4b
            .byte &59,&2e,&0d,&23,&5c,&20,&8f,&89
            .byte &d5,&54,&c2,&a7,&7b,&a1,&54,&c7
            .byte &4c,&2c,&b8,&ae,&4b,&20,&4d,&b5
            .byte &ba,&41,&a9,&2e,&76,&89,&5d,&2c
            .byte &8b,&52,&9d,&49,&a4,&a1,&43,&ab
            .byte &56,&49,&43,&9d,&7a,&89,&78,&20
            .byte &7b,&89,&4d,&b5,&ba,&41,&a9,&2c
            .byte &4c,&ae,&47,&9d,&af,&b5,&de,&20
            .byte &76,&af,&54,&aa,&2e,&0d,&23,&5b
            .byte &8f,&89,&af,&07,&ac,&43,&9d,&76
            .byte &a1,&c5,&53,&d0,&56,&9d,&c8,&ab
            .byte &b8,&2e,&5f,&20,&8a,&60,&20,&7b
            .byte &5c,&20,&47,&df,&57,&a4,&a1,&a8
            .byte &b9,&4e,&a2,&ad,&44,&47,&aa,&13
            .byte &2c,&57,&bb,&d3,&20,&46,&b9,&4d
            .byte &a4,&a1,&75,&20,&a9,&76,&89,&73
            .byte &8a,&8b,&9e,&bd,&aa,&a4,&52,&49
            .byte &9a,&20,&8a,&c3,&46,&54,&2c,&43
            .byte &dd,&53,&99,&20,&7a,&89,&54,&ab
            .byte &b7,&2e,&49,&9f,&49,&a4,&d4,&9a
            .byte &20,&48,&aa,&45,&2c,&1b,&9f,&ea
            .byte &aa,&99,&20,&a9,&2c,&c7,&4c,&20
            .byte &49,&a4,&41,&9e,&45,&aa,&49,&9d
            .byte &42,&cb,&f1,&4e,&b7,&53,&21,&0d
            .byte &23,&5b,&8f,&89,&e0,&47,&9d,&7b
            .byte &89,&c8,&ab,&b8,&2c,&5c,&a3,&57
            .byte &41,&a2,&b5,&9f,&42,&6b,&20,&42
            .byte &a2,&a1,&a8,&49,&f1,&20,&ad,&44
            .byte &dc,&2e,&0d,&23,&5b,&8f,&89,&c8
            .byte &ab,&b8,&27,&a4,&e0,&dc,&2e,&7a
            .byte &89,&ad,&44,&47,&aa,&4f,&a6,&46
            .byte &b9,&4d,&99,&20,&89,&5f,&aa,&9e
            .byte &42,&b5,&c4,&ae,&a2,&49,&a4,&a1
            .byte &ed,&c3,&2c,&4a,&12,&9f,&57,&49
            .byte &44,&9d,&af,&b5,&de,&20,&c8,&a3
            .byte &5c,&20,&76,&53,&f0,&0b,&5a,&9d
            .byte &a8,&52,&b5,&de,&2e,&0d,&23,&5b
            .byte &bf,&04,&20,&7a,&89,&c8,&ab,&b8
            .byte &2e,&54,&c7,&4c,&20,&54,&ab,&45
            .byte &a4,&ab,&41,&a3,&19,&20,&c7,&4c
            .byte &20,&ae,&b5,&c4,&2c,&8b,&49,&a3
            .byte &1c,&ac,&43,&ad,&a4,&a9,&54,&aa
            .byte &54,&57,&a9,&99,&20,&76,&43,&55
            .byte &9f,&b5,&9f,&c7,&4c,&20,&16,&59
            .byte &d4,&9a,&2e,&5c,&a3,&cb,&e8,&20
            .byte &d1,&b8,&a4,&a1,&59,&cd,&dd,&a6
            .byte &b4,&dd,&20,&4f,&bd,&a3,&5c,&2c
            .byte &57,&bb,&d3,&20,&53,&d1,&ab,&a4
            .byte &89,&73,&43,&ab,&b2,&55,&ab,&a4
            .byte &8a,&ed,&4c,&44,&a4,&8b,&a7,&8f
            .byte &42,&1f,&2e,&0d,&23,&5b,&7a,&89
            .byte &af,&07,&ac,&43,&9d,&43,&b4,&4d
            .byte &08,&a3,&7b,&a1,&4c,&ae,&47,&9d
            .byte &d1,&56,&9d,&53,&59,&53,&b1,&4d
            .byte &2e,&5e,&20,&7b,&5c,&2c,&89,&d1
            .byte &53,&d1,&44,&99,&20,&93,&46,&c7
            .byte &4c,&20,&4f,&42,&53,&43,&55,&ab
            .byte &a4,&5c,&a3,&56,&49,&45,&a6,&7b
            .byte &89,&c8,&ab,&b8,&2e,&0d,&23,&5b
            .byte &8f,&a1,&44,&bc,&a0,&af,&a0,&7a
            .byte &89,&77,&20,&50,&0a,&ef,&47,&b7
            .byte &2e,&5c,&20,&cb,&e8,&20,&d1,&b8
            .byte &a4,&62,&45,&2c,&ac,&49,&c5,&b1
            .byte &a0,&53,&b4,&c1,&57,&a4,&7e,&89
            .byte &55,&ca,&bd,&9e,&64,&53,&2e,&0d
            .byte &23,&5b,&7a,&a1,&7d,&20,&7b,&4e
            .byte &ae,&df,&a6,&77,&20,&50,&0a,&ef
            .byte &47,&b7,&2c,&4d,&a9,&44,&46,&55
            .byte &4c,&20,&7b,&89,&df,&f1,&a2,&b5
            .byte &54,&43,&df,&50,&a4,&8a,&db,&a9
            .byte &b1,&a0,&b8,&c7,&f6,&b0,&b1,&a4
            .byte &57,&bb,&d3,&20,&48,&ac,&47,&20
            .byte &44,&ac,&47,&aa,&9b,&4c,&a2,&6e
            .byte &89,&43,&45,&e7,&99,&2e,&0d,&23
            .byte &5b,&7a,&a1,&4c,&ae,&47,&9d,&43
            .byte &b4,&4d,&42,&aa,&2c,&41,&57,&ae
            .byte &9d,&7b,&89,&be,&4c,&a0,&44,&c0
            .byte &55,&9a,&20,&57,&bb,&d3,&20,&54
            .byte &b5,&43,&ad,&a4,&5c,&a3,&46,&f6
            .byte &9d,&6e,&89,&5d,&2e,&0d,&23,&5b
            .byte &7a,&a1,&da,&55,&b8,&aa,&a2,&77
            .byte &20,&50,&0a,&ef,&dc,&2e,&a1,&42
            .byte &ab,&45,&5a,&9d,&da,&13,&a4,&7a
            .byte &6e,&89,&5e,&2e,&0d,&23,&5b,&7a
            .byte &a1,&c5,&53,&d0,&56,&9d,&b4,&d7
            .byte &20,&7a,&89,&77,&53,&2e,&89,&53
            .byte &b5,&4e,&a0,&7b,&0e,&49,&eb,&99
            .byte &20,&93,&20,&45,&d3,&4f,&45,&a4
            .byte &6e,&53,&e5,&45,&10,&aa,&9d,&cf
            .byte &b8,&ac,&9f,&8a,&e6,&aa,&47,&99
            .byte &20,&6e,&89,&53,&b4,&c1,&57,&a4
            .byte &7b,&89,&43,&45,&e7,&99,&20,&5c
            .byte &20,&71,&20,&e9,&dc,&2c,&43,&b3
            .byte &49,&43,&c7,&20,&b8,&c7,&f6,&b0
            .byte &b1,&53,&2c,&d4,&4d,&9d,&10,&b6
            .byte &9d,&7a,&89,&47,&4c,&ae,&9d,&7b
            .byte &5c,&a3,&cb,&e8,&2e,&0d,&23,&5b
            .byte &8f,&89,&c2,&50,&20,&7b,&a1,&90
            .byte &99,&20,&b8,&f4,&52,&d1,&c6,&2c
            .byte &ad,&57,&9e,&6e,&89,&77,&20,&df
            .byte &f1,&2e,&0d,&23,&5b,&7e,&a1,&90
            .byte &99,&20,&b8,&f4,&52,&d1,&c6,&2c
            .byte &43,&ae,&bd,&a0,&6e,&89,&77,&20
            .byte &df,&f1,&2e,&0d,&23,&5b,&7a,&a1
            .byte &cf,&4d,&4c,&a2,&d4,&9f,&47,&c0
            .byte &bd,&59,&ae,&44,&2e,&fc,&02,&4c
            .byte &99,&20,&01,&b8,&a4,&43,&dd,&ff
            .byte &20,&89,&ad,&fd,&b8,&b3,&b7,&2c
            .byte &c5,&4b,&99,&20,&8b,&a7,&53,&bb
            .byte &4d,&f2,&a3,&6d,&41,&9e,&d2,&4e
            .byte &b2,&55,&c0,&4c,&20,&d4,&9a,&2e
            .byte &0d,&23,&5b,&7e,&a1,&01,&b8,&a2
            .byte &46,&d4,&9a,&20,&7b,&53,&b1,&50
            .byte &a4,&57,&bb,&d3,&20,&43,&b3,&ca
            .byte &43,&54,&a4,&19,&ea,&a3,&8a,&dd
            .byte &05,&a3,&c3,&bd,&4c,&a4,&7b,&89
            .byte &47,&c0,&bd,&59,&ae,&44,&2e,&0d
            .byte &23,&5b,&7e,&0e,&59,&2c,&53,&8c
            .byte &a2,&42,&bc,&d3,&2e,&7a,&89,&cf
            .byte &b8,&ac,&43,&9d,&76,&89,&5d,&2c
            .byte &89,&52,&b5,&de,&20,&c6,&a1,&43
            .byte &c0,&53,&ad,&a4,&76,&89,&53,&ed
            .byte &ab,&2e,&a1,&4c,&b6,&54,&4c,&9d
            .byte &57,&41,&a2,&5e,&2c,&89,&47,&ab
            .byte &a2,&7c,&a4,&64,&20,&7a,&89,&42
            .byte &bc,&d3,&2e,&0d,&23,&5b,&7e,&a1
            .byte &53,&8c,&a2,&85,&42,&a2,&89,&52
            .byte &b5,&de,&20,&53,&bc,&2e,&89,&53
            .byte &8a,&49,&a4,&44,&d6,&50,&20,&8a
            .byte &5c,&20,&4c,&bc,&56,&9d,&bf,&04
            .byte &20,&c8,&4f,&54,&d8,&a9,&54,&53
            .byte &2e,&0d,&23,&5b,&7e,&a1,&57,&49
            .byte &bf,&2c,&11,&8f,&50,&cb,&a9,&2e
            .byte &89,&90,&20,&da,&13,&a4,&b8,&52
            .byte &b3,&47,&4c,&59,&2c,&4b,&49,&f1
            .byte &99,&20,&19,&20,&89,&44,&12,&9f
            .byte &a9,&76,&d3,&4f,&4b,&99,&20,&43
            .byte &4c,&b5,&44,&53,&2e,&0d,&23,&5b
            .byte &7e,&89,&c2,&50,&20,&7b,&a1,&44
            .byte &ac,&47,&aa,&9b,&20,&53,&43,&ab
            .byte &9d,&53,&dd,&50,&9d,&4f,&56,&aa
            .byte &dd,&4f,&4b,&99,&20,&89,&c8,&ab
            .byte &b8,&2e,&5c,&20,&47,&41,&5a,&9d
            .byte &67,&20,&89,&88,&2c,&76,&89,&d5
            .byte &54,&c2,&a7,&7b,&89,&53,&dd,&50
            .byte &9d,&10,&aa,&9d,&89,&e1,&b5,&4e
            .byte &a0,&71,&4d,&a4,&46,&02,&4d,&aa
            .byte &2e,&8f,&81,&4d,&e5,&af,&54,&2c
            .byte &a1,&b8,&b3,&9d,&00,&bd,&a4,&6e
            .byte &d2,&bf,&a3,&5c,&2c,&8a,&5c,&20
            .byte &53,&50,&c0,&57,&4c,&20,&f6,&df
            .byte &53,&a4,&89,&4a,&41,&47,&dc,&a0
            .byte &b8,&b3,&b7,&2e,&0d,&23,&5c,&20
            .byte &af,&b1,&a3,&89,&cf,&cb,&ec,&16
            .byte &b1,&a0,&48,&9b,&9d,&8a,&ea,&45
            .byte &a3,&52,&b5,&c4,&2c,&d1,&55,&b0
            .byte &9b,&4c,&59,&2e,&5c,&20,&ad,&41
            .byte &a3,&a1,&4c,&b5,&a0,&53,&43,&c0
            .byte &50,&99,&20,&8a,&8b,&9e,&be,&4c
            .byte &cb,&50,&53,&9d,&76,&89,&46,&dd
            .byte &b9,&2c,&41,&a4,&89,&df,&7b,&d1
            .byte &bd,&a4,&7a,&8a,&43,&52,&12,&ad
            .byte &a4,&5c,&2e,&0d,&23,&5c,&20,&af
            .byte &b1,&a3,&89,&6a,&20,&8a,&46,&a9
            .byte &a0,&5c,&52,&c6,&4c,&46,&20,&7a
            .byte &a1,&b8,&55,&44,&59,&2e,&a1,&4c
            .byte &bc,&8b,&a3,&fc,&49,&bd,&4c,&20
            .byte &43,&b4,&49,&a3,&46,&f6,&45,&a4
            .byte &87,&20,&6e,&5c,&2e,&53,&55,&44
            .byte &44,&af,&4c,&59,&2c,&89,&43,&b4
            .byte &49,&a3,&ab,&56,&4f,&4c,&bd,&a4
            .byte &8a,&5c,&20,&46,&f6,&9d,&89,&23
            .byte &4b,&99,&2e,&22,&23,&a5,&c1,&98
            .byte &57,&ac,&9f,&76,&42,&9d,&cf,&b8
            .byte &55,&52,&42,&e0,&22,&2c,&48,&9d
            .byte &0f,&b5,&54,&53,&2c,&8a,&47,&c0
            .byte &42,&42,&99,&20,&a1,&d0,&4c,&bd
            .byte &a3,&c3,&54,&b1,&a3,&68,&aa,&2c
            .byte &b8,&41,&42,&a4,&5c,&21,&0d,&23
            .byte &5c,&20,&14,&d2,&47,&9d,&a9,&76
            .byte &89,&46,&ab,&45,&5a,&99,&20,&53
            .byte &bc,&2e,&a1,&06,&47,&ac,&b0,&43
            .byte &20,&57,&41,&56,&9d,&46,&dd,&4f
            .byte &44,&a4,&4f,&bd,&a3,&5c,&2c,&50
            .byte &55,&d7,&99,&20,&5c,&20,&55,&c4
            .byte &aa,&2e,&89,&cb,&53,&9f,&a8,&99
            .byte &20,&5c,&20,&46,&45,&cd,&20,&49
            .byte &a4,&89,&b8,&99,&20,&7b,&53,&c7
            .byte &9f,&93,&20,&7a,&5c,&a3,&45,&59
            .byte &b7,&2e,&0d,&23,&5b,&b5,&54,&78
            .byte &20,&89,&23,&97,&20,&7b,&23,&58
            .byte &41,&ac,&2e,&b6,&a4,&43,&55,&52
            .byte &bd,&a0,&64,&a4,&ae,&9d,&e4,&e2
            .byte &a8,&20,&8a,&bb,&de,&2c,&8a,&dd
            .byte &e5,&2c,&49,&4d,&db,&53,&99,&4c
            .byte &59,&2c,&4f,&bd,&a3,&89,&c9,&4c
            .byte &8c,&2e,&89,&60,&20,&64,&20,&49
            .byte &a4,&cc,&4b,&45,&9e,&19,&20,&42
            .byte &a2,&41,&9e,&ae,&43,&ad,&44,&2c
            .byte &57,&e2,&bf,&9e,&c1,&b9,&2c,&57
            .byte &bb,&d3,&20,&49,&a4,&b8,&55,&44
            .byte &bf,&a0,&6d,&42,&cb,&f1,&20,&02
            .byte &7e,&8a,&1e,&a9,&b1,&a0,&6d,&89
            .byte &23,&4b,&99,&27,&a4,&be,&8f,&7b
            .byte &ae,&4d,&53,&2e,&0d,&23,&5b,&7a
            .byte &89,&c5,&7a,&b4,&d7,&20,&7b,&89
            .byte &97,&2e,&cc,&50,&b7,&07,&49,&45
            .byte &a4,&bf,&ec,&43,&54,&99,&20,&89
            .byte &23,&4b,&99,&20,&7b,&23,&58,&41
            .byte &ac,&27,&a4,&0c,&e7,&20,&ab,&18
            .byte &4e,&2c,&48,&ac,&47,&20,&6e,&89
            .byte &47,&ab,&59,&2c,&b8,&b3,&9d,&64
            .byte &53,&2e,&76,&89,&5f,&20,&49,&a4
            .byte &89,&ae,&43,&ad,&a0,&c1,&4f,&a3
            .byte &4c,&bc,&44,&99,&20,&b5,&54,&2e
            .byte &0d,&23,&5b,&7a,&a1,&57,&49,&44
            .byte &9d,&63,&7a,&89,&97,&2e,&a1,&53
            .byte &c5,&d7,&20,&c1,&4f,&a3,&d4,&45
            .byte &a4,&50,&ae,&b0,&c7,&4c,&a2,&bb
            .byte &44,&bf,&9e,&8f,&89,&d5,&54,&c2
            .byte &a7,&7b,&53,&e5,&9d,&53,&b1,&50
            .byte &53,&2e,&0d,&23,&5b,&7a,&89,&57
            .byte &49,&44,&9d,&43,&b9,&8d,&b9,&2c
            .byte &1c,&49,&9a,&4c,&a2,&d4,&9f,&6e
            .byte &6f,&42,&a2,&a1,&62,&9d,&d4,&9a
            .byte &2d,&53,&b5,&52,&43,&9d,&5c,&20
            .byte &43,&ac,&ee,&9f,&55,&c4,&aa,&b8
            .byte &8c,&2e,&0d,&23,&5b,&8f,&89,&af
            .byte &a0,&7b,&89,&57,&49,&44,&9d,&43
            .byte &b9,&8d,&b9,&2e,&a1,&46,&d4,&9a
            .byte &20,&7b,&b8,&f4,&52,&a4,&4c,&bc
            .byte &44,&a4,&76,&89,&94,&41,&d5,&bd
            .byte &2c,&8a,&a1,&53,&c5,&d7,&20,&c1
            .byte &4f,&a3,&49,&a4,&c6,&9f,&7a,&89
            .byte &5d,&20,&64,&2e,&0d,&23,&5b,&7a
            .byte &a1,&57,&cd,&4c,&20,&46,&55,&52
            .byte &4e,&c9,&ad,&a0,&53,&b6,&54,&99
            .byte &20,&6a,&2c,&44,&b5,&da,&9d,&47
            .byte &cb,&5a,&e0,&2c,&6d,&46,&0a,&48
            .byte &9c,&41,&da,&9d,&42,&d6,&d5,&4f
            .byte &20,&43,&b4,&02,&a4,&8a,&41,&9e
            .byte &45,&c3,&43,&07,&49,&43,&20,&46
            .byte &02,&9d,&6d,&50,&cb,&53,&b0,&43
            .byte &20,&be,&c7,&2e,&0d,&23,&5b,&7a
            .byte &a1,&4c,&ae,&dc,&2c,&1c,&49,&9a
            .byte &20,&4b,&b6,&43,&ad,&4e,&2e,&57
            .byte &bb,&b1,&2c,&af,&d6,&cd,&20,&b0
            .byte &c3,&a4,&be,&bd,&a3,&89,&64,&a4
            .byte &8a,&43,&b3,&43,&ab,&54,&9d,&53
            .byte &b1,&50,&a4,&4c,&bc,&a0,&19,&20
            .byte &76,&a1,&53,&c5,&d7,&2c,&1e,&a9
            .byte &b1,&a0,&c1,&b9,&2e,&0d,&23,&5b
            .byte &7a,&a1,&55,&b0,&4c,&b6,&a2,&6a
            .byte &2e,&56,&ae,&49,&9b,&20,&be,&e8
            .byte &c3,&58,&20,&c5,&d3,&a9,&b7,&2c
            .byte &6d,&4e,&d6,&45,&a4,&81,&c7,&4c
            .byte &20,&af,&a0,&7a,&22,&4f,&c5,&b0
            .byte &43,&22,&2c,&1b,&5a,&5a,&2c,&43
            .byte &4c,&ac,&4b,&20,&8a,&e9,&a7,&49
            .byte &e8,&ab,&53,&d0,&bd,&4c,&59,&2e
            .byte &f7,&b1,&a3,&47,&41,&5a,&99,&20
            .byte &8f,&89,&22,&23,&cf,&47,&b6,&c7
            .byte &20,&57,&0a,&ed,&c5,&b0,&43,&20
            .byte &b8,&aa,&45,&4f,&20,&c0,&cf,&4f
            .byte &20,&0e,&a9,&4b,&a4,&c5,&d3,&a9
            .byte &45,&22,&2c,&5c,&20,&bf,&43,&49
            .byte &44,&9d,&49,&9f,&b4,&a4,&ee,&20
            .byte &7f,&20,&d0,&47,&4e,&49,&46,&49
            .byte &43,&ac,&43,&45,&2e,&0d,&23,&5b
            .byte &7a,&a1,&53,&50,&f6,&49,&9b,&20
            .byte &50,&ac,&07,&a2,&6d,&57,&e2,&44
            .byte &2d,&50,&ac,&cd,&c3,&a0,&64,&53
            .byte &2e,&a1,&56,&ae,&4e,&c9,&ad,&44
            .byte &2c,&50,&a9,&9d,&cc,&da,&9d,&49
            .byte &a4,&dd,&d1,&b1,&a0,&7a,&89,&43
            .byte &af,&07,&9d,&7b,&89,&6a,&20,&8a
            .byte &4f,&43,&43,&55,&ec,&45,&a4,&4d
            .byte &55,&d3,&20,&7b,&89,&94,&41,&ab
            .byte &41,&2e,&0d,&23,&5b,&7e,&89,&dd
            .byte &05,&a3,&4c,&8c,&99,&2e,&b8,&f4
            .byte &52,&a4,&4c,&bc,&a0,&76,&89,&46
            .byte &dd,&b9,&a4,&6f,&8a,&42,&cd,&13
            .byte &2e,&0d,&23,&5b,&7a,&a1,&50,&0a
            .byte &ef,&dc,&57,&41,&a2,&7e,&89,&46
            .byte &02,&53,&9f,&46,&dd,&b9,&2e,&89
            .byte &5e,&20,&64,&20,&b4,&a4,&65,&a4
            .byte &76,&56,&ae,&49,&9b,&20,&6a,&53
            .byte &2e,&0d,&23,&5b,&8f,&89,&af,&a0
            .byte &7b,&89,&50,&0a,&ef,&dc,&57,&41
            .byte &a2,&7e,&89,&46,&02,&53,&9f,&46
            .byte &dd,&b9,&2e,&0d,&23,&5b,&7e,&89
            .byte &19,&ea,&a3,&4c,&8c,&99,&2e,&53
            .byte &b1,&50,&a4,&4c,&bc,&a0,&67,&20
            .byte &76,&89,&94,&42,&cd,&13,&2e,&46
            .byte &55,&52,&8b,&a3,&c7,&b3,&47,&20
            .byte &89,&4c,&8c,&99,&20,&76,&89,&5f
            .byte &2c,&5c,&20,&c5,&4b,&9d,&b5,&9f
            .byte &89,&53,&b4,&50,&9d,&7b,&a1,&53
            .byte &c5,&d7,&20,&c1,&b9,&2e,&0d,&23
            .byte &5b,&8f,&89,&46,&41,&a3,&af,&a0
            .byte &7b,&89,&19,&ea,&a3,&4c,&8c,&99
            .byte &20,&b5,&54,&78,&20,&a1,&53,&c5
            .byte &d7,&2c,&57,&e2,&bf,&9e,&c1,&b9
            .byte &2e,&a1,&4d,&b7,&ef,&47,&9d,&7e
            .byte &89,&c1,&4f,&a3,&ab,&fd,&a4,&22
            .byte &26,&d8,&49,&56,&b2
l6349:      .byte &9d,&4b,&45,&04,&20,&b5,&54,&26
            .byte &22,&2e,&0d,&23,&5b,&7a,&a1,&44
            .byte &c9,&55,&c6,&a0,&42,&e0,&6a,&2c
            .byte &15,&b8,&a2,&8a,&42,&41,&ab,&2e
            .byte &5c,&a3,&c8,&4f,&54,&53,&b1,&50
            .byte &a4,&ab,&53,&b3,&b2,&9d,&7e,&89
            .byte &46,&dd,&b9,&d5,&ae,&44,&53,&2e
            .byte &76,&89,&5e,&20,&8b,&52,&9d,&49
            .byte &a4,&a1,&43,&19,&d5,&ae,&a0,&c1
            .byte &b9,&2e,&0d,&23,&5b,&7a,&a1,&43
            .byte &bb,&4c,&44,&27,&a4,&42,&e0,&6a
            .byte &2e,&89,&64,&a4,&ae,&9d,&1c,&49
            .byte &9a,&4c,&a2,&bf,&43,&b9,&41,&b1
            .byte &a0,&6d,&ec,&43,&54,&55,&ab,&a4
            .byte &7b,&b1,&44,&44,&a2,&08,&ae,&a4
            .byte &8a,&a1,&53,&c5,&d7,&20,&08,&a0
            .byte &49,&a4,&50,&12,&ad,&a0,&41,&47
            .byte &41,&a9,&53,&9f,&89,&5f,&20,&64
            .byte &2e,&a1,&ab,&a0,&47,&dd,&53,&53
            .byte &a2,&c1,&4f,&a3,&4d,&ae,&4b,&45
            .byte &a0,&22,&23,&c2,&a2,&23,&43,&19
            .byte &d5,&ae,&44,&22,&20,&cc,&4b,&45
            .byte &a4,&19,&20,&89,&5e,&20,&64,&2e
            .byte &0d,&23,&5b,&7a,&89,&c5,&53,&b1
            .byte &a3,&42,&e0,&6a,&2e,&49,&9f,&49
            .byte &a4,&53,&50,&f6,&49,&9b,&20,&8a
            .byte &57,&cd,&4c,&20,&4c,&b6,&2e,&41
            .byte &9e,&45,&c3,&47,&ac,&9f,&46,&b5
            .byte &a3,&db,&53,&b1,&a3,&08,&a0,&49
            .byte &a4,&db,&53,&b6,&9c,&45,&a0,&ca
            .byte &58,&9f,&76,&a1,&c1,&4f,&a3,&7a
            .byte &89,&5e,&20,&64,&2e,&0d,&23,&5b
            .byte &7a,&a1,&4c,&ae,&dc,&2c,&cf,&4d
            .byte &4c,&a2,&4c,&b6,&2c,&57,&c7,&4b
            .byte &2d,&7a,&4c,&a9,&45,&9e,&43,&19
            .byte &d5,&ae,&44,&2e,&a1,&e1,&49,&4d
            .byte &a2,&c1,&4f,&a3,&4f,&43,&43,&55
            .byte &ec,&45,&a4,&89,&5d,&20,&64,&2e
            .byte &0d,&23,&5b,&7a,&a1,&53,&c5,&d7
            .byte &20,&c2,&a2,&43,&19,&d5,&ae,&44
            .byte &2c,&cf,&4d,&4c,&a2,&49,&d7,&d9
            .byte &a9,&41,&b1,&a0,&42,&a2,&89,&d4
            .byte &9a,&20,&57,&bb,&d3,&20,&43,&ab
            .byte &04,&a4,&7a,&a8,&52,&b5,&de,&20
            .byte &47,&41,&50,&a4,&d2,&bf,&a3,&89
            .byte &c1,&4f,&a3,&76,&89,&5d,&2e,&0d
            .byte &23,&5b,&7a,&a1,&00,&44,&aa,&9e
            .byte &42,&41,&a8,&6a,&2e,&89,&53,&55
            .byte &b6,&9d,&49,&a4,&41,&9e,&f9,&43
            .byte &4c,&55,&d0,&56,&9d,&d3,&4f,&be
            .byte &4c,&b2,&9d,&be,&4c,&b5,&52,&2c
            .byte &53,&d2,&4b,&20,&a9,&76,&89,&46
            .byte &dd,&b9,&2c,&6d,&af,&47,&c0,&bd
            .byte &a0,&cc,&50,&53,&2c,&a1,&8b,&52
            .byte &c5,&4c,&20,&c2,&57,&cd,&20,&c0
            .byte &e7,&20,&8a,&53,&e5,&9d,&c0,&8b
            .byte &a3,&f9,&50,&af,&d0,&56,&9d,&23
            .byte &50,&c6,&55,&c1,&2d,&23,&56,&49
            .byte &43,&54,&b9,&49,&41,&9e,&03,&41
            .byte &50,&20,&44,&c9,&ad,&53,&21,&0d
            .byte &23,&5b,&8f,&89,&c2,&50,&20,&7b
            .byte &a1,&46,&d4,&9a,&20,&7b,&53,&b1
            .byte &50,&53,&2c,&43,&ae,&bd,&a0,&b5
            .byte &9f,&7b,&89,&4d,&b5,&ba,&41,&a9
            .byte &2e,&8b,&52,&9d,&49,&a4,&a1,&46
            .byte &ab,&0f,&20,&42,&ab,&45,&5a,&9d
            .byte &57,&bb,&d3,&20,&71,&4d,&a4,&76
            .byte &af,&d4,&bd,&9e,&5c,&21,&0d,&23
            .byte &5b,&7e,&a1,&46,&d4,&9a,&20,&7b
            .byte &45,&ae,&a8,&a2,&53,&b1,&50,&53
            .byte &2c,&43,&ae,&bd,&a0,&b5,&9f,&7b
            .byte &89,&4d,&b5,&ba,&41,&a9,&2e,&0d
            .byte &23,&5b,&8f,&89,&d5,&54,&c2,&a7
            .byte &7b,&a1,&46,&d4,&9a,&20,&7b,&53
            .byte &b1,&50,&53,&2c,&f9,&d1,&56,&41
            .byte &b1,&a0,&6e,&89,&4d,&b5,&ba,&41
            .byte &a9,&78,&2e,&0d,&23,&5b,&7e,&a1
            .byte &53,&ec,&c0,&4c,&20,&75,&57,&41
            .byte &a2,&7e,&89,&78,&20,&7b,&89,&4d
            .byte &b5,&ba,&41,&a9,&2e,&0d,&23,&5b
            .byte &8f,&a1,&50,&cb,&b1,&41,&55,&20
            .byte &b4,&4c,&46,&20,&57,&41,&a2,&19
            .byte &20,&89,&4d,&b5,&ba,&41,&a9,&2e
            .byte &a1,&ea,&43,&55,&d4,&ae,&2c,&da
            .byte &55,&9d,&d4,&9a,&20,&50,&55,&4c
            .byte &c6,&a4,&76,&89,&60,&2e,&0d,&23
            .byte &5b,&8f,&89,&5f,&aa,&9e,&e0,&47
            .byte &9d,&7b,&89,&50,&cb,&b1,&41,&55
            .byte &2e,&bb,&de,&20,&42,&ac,&4b,&a4
            .byte &7b,&45,&ae,&a8,&20,&b8,&4f,&50
            .byte &20,&ac,&a2,&46,&55,&52,&8b,&a3
            .byte &d8,&fb,&ab,&53,&53,&2e,&46,&41
            .byte &a3,&76,&89,&60,&20,&5c,&20,&71
            .byte &20,&a1,&50,&55,&4c,&53,&99,&2c
            .byte &da,&55,&9d,&d4,&9a,&2e,&0d,&23
            .byte &5b,&8f,&a1,&53,&c5,&d7,&20,&47
            .byte &df,&54,&c2,&2c,&43,&55,&9f,&a9
            .byte &76,&89,&4d,&b5,&ba,&41,&a9,&2e
            .byte &a1,&da,&55,&45,&2c,&ca,&7e,&d0
            .byte &47,&9e,&ab,&fd,&99,&3a,&22,&3c
            .byte &23,&c5,&4b,&9d,&23,&5c,&a3,&23
            .byte &57,&c9,&48,&20,&23,&48,&aa,&45
            .byte &3c,&22,&2c,&db,&a9,&54,&a4,&76
            .byte &a1,&53,&c5,&d7,&20,&57,&cd,&4c
            .byte &2c,&43,&b3,&b8,&17,&43,&b1,&a0
            .byte &7b,&1c,&49,&f1,&2c,&6d,&a1,&42
            .byte &c0,&53,&a4,&14,&b2,&9d,&c6,&9f
            .byte &a9,&76,&89,&64,&2e,&0d,&23,&5b
            .byte &7a,&a1,&42,&ae,&ab,&9e,&72,&50
            .byte &0a,&53,&2c,&53,&f0,&0b,&5a,&45
            .byte &a0,&08,&54,&05,&45,&9e,&54,&57
            .byte &4f,&20,&42,&ac,&4b,&a4,&7b,&45
            .byte &ae,&a8,&20,&8a,&df,&f1,&2e,&89
            .byte &e1,&b5,&4e,&a0,&49,&a4,&48,&ae
            .byte &a0,&8a,&55,&ca,&56,&af,&2e,&0d
            .byte &23,&5b,&7e,&a1,&47,&c0,&53,&53
            .byte &a2,&53,&dd,&50,&9d,&4c,&bc,&44
            .byte &99,&20,&67,&20,&89,&4d,&b5,&ba
            .byte &41,&a9,&2e,&89,&bd,&dc,&cc,&b0
            .byte &7e,&49,&a4,&52,&49,&d3,&20,&8a
            .byte &47,&ab,&af,&2e,&0d,&23,&5b,&7e
            .byte &a1,&47,&c0,&53,&53,&a2,&50,&cb
            .byte &b1,&41,&55,&20,&4f,&56,&aa,&53
            .byte &b4,&c1,&05,&a0,&42,&a2,&89,&01
            .byte &9a,&a2,&23,&97,&20,&7b,&23,&58
            .byte &41,&ac,&2e,&8b,&52,&9d,&ae,&9d
            .byte &d0,&47,&4e,&a4,&81,&4f,&8b,&52
            .byte &a4,&b4,&56,&9d,&08,&45,&9e,&48
            .byte &aa,&9d,&08,&46,&b9,&9d,&5c,&21
            .byte &0d,&23,&5b,&8f,&89,&d5,&54,&c2
            .byte &a7,&7b,&a1,&47,&c0,&53,&53,&a2
            .byte &53,&dd,&ea,&2e,&89,&47,&c0,&53
            .byte &a4,&48,&aa,&9d,&49,&a4,&57,&bc
            .byte &4b,&2c,&59,&cd,&dd,&a6,&8a,&a9
            .byte &54,&aa,&4d,&99,&c3,&a0,&6d,&42
            .byte &ae,&9d,&50,&b2,&43,&ad,&53,&2e
            .byte &0d,&23,&5b,&7e,&89,&11,&8f,&4c
            .byte &8c,&a4,&42,&af,&bc,&a8,&20,&89
            .byte &23,&97,&20,&7b,&23,&58,&41,&ac
            .byte &2e,&89,&4c,&8c,&a4,&ae,&9d,&53
            .byte &50,&ae,&c6,&4c,&a2,&bd,&dc,&cc
            .byte &b1,&a0,&8a,&b8,&b3,&59,&2e,&0d
            .byte &23,&5b,&7a,&89,&01,&44,&53,&9f
            .byte &7b,&89,&11,&8f,&4c,&8c,&a4,&42
            .byte &af,&bc,&a8,&20,&89,&23,&97,&20
            .byte &7b,&23,&58,&41,&ac,&2e,&89,&e1
            .byte &b5,&4e,&a0,&49,&a4,&48,&ae,&a0
            .byte &8a,&df,&f1,&59,&2c,&8a,&ee,&20
            .byte &bd,&dc,&cc,&b0,&7e,&47,&df,&57
            .byte &53,&2e,&0d,&23,&5b,&7a,&a1,&b8
            .byte &a9,&4b,&99,&20,&44,&b6,&d3,&2e
            .byte &89,&48,&ae,&a0,&94,&49,&a4,&be
            .byte &56,&aa,&45,&a0,&6d,&db,&4f,&4c
            .byte &a4,&7b,&b8,&41,&47,&4e,&ac,&9f
            .byte &d4,&f0,&49,&a0,&8a,&b8,&af,&d3
            .byte &99,&20,&53,&d4,&f2,&2e,&89,&d0
            .byte &f1,&af,&99,&20,&e4,&cd,&4c,&20
            .byte &4c,&99,&aa,&53,&2c,&44,&c9,&47
            .byte &55,&b8,&99,&4c,&59,&2c,&7a,&5c
            .byte &a3,&ee,&b8,&52,&e7,&53,&2e,&a8
            .byte &49,&a4,&c9,&98,&a1,&47,&e2,&a0
            .byte &50,&cb,&43,&9d,&76,&ec,&43,&4e
            .byte &49,&43,&21,&0d,&23,&5b,&8f,&89
            .byte &af,&a0,&7b,&a1,&15,&b8,&a2,&df
            .byte &fd,&2c,&42,&b5,&4e,&bf,&a0,&42
            .byte &a2,&44,&c0,&a9,&41,&47,&9d,&44
            .byte &b6,&43,&ad,&53,&2e,&76,&89,&5d
            .byte &20,&d4,&9d,&89,&11,&8f,&4c,&8c
            .byte &a4,&42,&af,&bc,&a8,&20,&89,&23
            .byte &97,&20,&7b,&23,&58,&41,&ac,&2e
            .byte &0d,&23,&5b,&7e,&a1,&4c,&b3,&47
            .byte &2c,&15,&b8,&a2,&df,&fd,&2e,&4f
            .byte &56,&aa,&47,&df,&57,&9e,&75,&a4
            .byte &4c,&bc,&a0,&5d,&2c,&76,&a1,&df
            .byte &a6,&7b,&43,&b3,&bf,&4d,&ca,&a0
            .byte &48,&9b,&b7,&2e,&8b,&49,&a3,&57
            .byte &e2,&44,&57,&b9,&4b,&20,&49,&a4
            .byte &df,&54,&54,&99,&2c,&8b,&49,&a3
            .byte &1e,&a9,&54,&57,&b9,&4b,&20,&43
            .byte &bb,&50,&ea,&a0,&8a,&46,&cb,&4b
            .byte &99,&2c,&8a,&8b,&49,&a3,&66,&a4
            .byte &53,&c5,&53,&ad,&a0,&4f,&a3,&d5
            .byte &ae,&bf,&44,&2e,&0d,&23,&5b,&8f
            .byte &89,&b8,&ae,&9f,&7b,&a1,&4c,&b3
            .byte &47,&2c,&b8,&c0,&49,&9a,&20,&df
            .byte &fd,&2c,&53,&55,&52,&46,&f6,&45
            .byte &a0,&6d,&ab,&a0,&15,&b8,&2e,&89
            .byte &df,&41,&a0,&49,&a4,&42,&b5,&4e
            .byte &bf,&a0,&42,&a2,&0f,&b5,&4c,&44
            .byte &aa,&2d,&bb,&de,&20,&44,&b6,&43
            .byte &ad,&53,&2c,&43,&55,&9f,&c8,&a3
            .byte &44,&c0,&a9,&41,&47,&9d,&50,&55
            .byte &52,&db,&53,&b7,&2e,&0d,&23,&5b
            .byte &8f,&89,&d5,&54,&c2,&a7,&7b,&89
            .byte &88,&2e,&bb,&de,&20,&6f,&8a,&5e
            .byte &2c,&89,&4b,&45,&04,&20,&97,&a4
            .byte &4f,&bd,&a3,&5c,&2c,&71,&4d,&99
            .byte &20,&76,&57,&b2,&d3,&20,&5c,&a3
            .byte &0c,&aa,&a2,&00,&bd,&21,&89,&74
            .byte &20,&73,&49,&a4,&76,&89,&5d,&2c
            .byte &57,&bb,&4c,&9d,&df,&fd,&a4,&b8
            .byte &ab,&54,&d3,&20,&5f,&20,&8a,&60
            .byte &2e,&0d,&23,&5b,&7a,&a1,&4e,&ae
            .byte &df,&57,&2c,&53,&b4,&44,&a2,&4c
            .byte &ac,&45,&2e,&57,&e7,&a0,&46,&dd
            .byte &57,&aa,&a4,&8a,&47,&c0,&53,&c6
            .byte &a4,&11,&b5,&52,&c9,&48,&20,&08
            .byte &54,&05,&45,&9e,&42,&ae,&9d,&43
            .byte &ae,&54,&2d,&54,&c0,&f1,&53,&2e
            .byte &0d,&23,&5b,&8f,&89,&af,&a0,&7b
            .byte &89,&53,&b4,&44,&a2,&4c,&ac,&45
            .byte &2e,&89,&46,&dd,&57,&aa,&a4,&8a
            .byte &47,&c0,&53,&c6,&a4,&47,&df,&a6
            .byte &54,&c7,&4c,&2c,&48,&aa,&45,&2e
            .byte &a1,&44,&c9,&55,&c6,&a0,&54,&c0
            .byte &f1,&20,&49,&a4,&56,&c9,&49,&da
            .byte &9d,&76,&89,&5d,&2e,&0d,&23,&5b
            .byte &7e,&a1,&44,&c9,&55,&c6,&a0,&54
            .byte &c0,&f1,&2e,&89,&55,&c4,&aa,&47
            .byte &df,&57,&a8,&20,&49,&a4,&a8,&49
            .byte &f1,&20,&8a,&46,&55,&d7,&20,&7b
            .byte &a8,&b9,&4e,&a2,&14,&ac,&54,&a4
            .byte &8a,&ca,&54,&54,&4c,&b7,&2c,&47
            .byte &55,&ae,&ac,&b1,&45,&a0,&76,&52
            .byte &49,&50,&20,&8a,&b8,&99,&2e,&0d
            .byte &23,&5b,&7e,&a1,&4e,&ae,&df,&a6
            .byte &b8,&f4,&52,&57,&41,&a2,&57,&bb
            .byte &d3,&20,&4c,&bc,&44,&a4,&19,&20
            .byte &76,&89,&90,&a2,&50,&cb,&a9,&2c
            .byte &8a,&67,&20,&76,&89,&01,&b8,&a2
            .byte &47,&c0,&bd,&59,&ae,&44,&2e,&0d
            .byte &23,&5b,&7a,&a1,&08,&47,&47,&ae
            .byte &27,&a4,&ed,&bd,&4c,&3a,&a1,&54
            .byte &a9,&a2,&57,&e2,&bf,&9e,&53,&b4
            .byte &f1,&2c,&6d,&df,&54,&54,&99,&20
            .byte &46,&dd,&b9,&d5,&ae,&44,&a4,&8a
            .byte &44,&d6,&50,&20,&64,&53,&2e,&a1
            .byte &08,&47,&47,&41,&a3,&53,&b6,&a4
            .byte &7a,&89,&43,&b9,&4e,&aa,&2c,&43
            .byte &df,&53,&53,&c3,&47,&dc,&44,&2c
            .byte &8a,&48,&d9,&4d,&99,&20,&54,&55
            .byte &ca,&82,&4c,&59,&2e,&0d,&23,&5b
            .byte &7e,&a1,&57,&e2,&bf,&9e,&47,&ac
            .byte &47,&14,&ac,&4b,&20,&76,&89,&95
            .byte &2e,&a1,&ab,&44,&2d,&ee,&c6,&a0
            .byte &23,&d1,&50,&cc,&a9,&2c,&6d,&a1
            .byte &46,&c7,&53,&9d,&c3,&47,&20,&8a
            .byte &a1,&b8,&55,&46,&46,&45,&a0,&50
            .byte &ae,&df,&9f,&e3,&49,&c3,&a0,&76
            .byte &bb,&a4,&14,&59,&57,&e2,&a0,&0f
            .byte &b5,&4c,&44,&aa,&2c,&fc,&18,&a4
            .byte &a1,&d5,&54,&54,&4c,&9d,&7b,&52
            .byte &d9,&2c,&8a,&ea,&aa,&a4,&8f,&5c
            .byte &2e,&0d,&23,&5c,&20,&d5,&ae,&a0
            .byte &89,&56,&0a,&9f,&ef,&e7,&99,&20
            .byte &95,&2c,&c8,&d7,&4f,&05,&a0,&42
            .byte &a2,&89,&23,&d1,&50,&cc,&a9,&2e
            .byte &89,&ac,&d3,&4f,&a3,&49,&a4,&d4
            .byte &46,&b1,&44,&2c,&89,&90,&20,&43
            .byte &b2,&43
l6b63:      .byte &ad,&a4,&7a,&89,&ef,&e7,&a4,&8a
            .byte &8b,&a2,&1a,&d7,&4f,&a6,&b5,&54
            .byte &2e,&53,&dd,&57,&4c,&59,&2c,&89
            .byte &95,&20,&4c,&bc,&bd,&a4,&89,&23
            .byte &c9,&4c,&8a,&7b,&23,&58,&41,&ac
            .byte &21,&5c,&20,&b4,&56,&9d,&b7,&d1
            .byte &50,&e0,&21,&5b,&46,&ab,&9d,&8f
            .byte &cb,&b8,&21,&0d,&23,&5b,&8f,&a1
            .byte &43,&c3,&ae,&99,&20,&7a,&89,&c8
            .byte &ab,&b8,&2e,&a1,&93,&46,&c7,&4c
            .byte &20,&d1,&53,&d1,&bf,&a4,&67,&20
            .byte &89,&53,&b1,&04,&20,&72,&64,&2c
            .byte &df,&ae,&99,&20,&6d,&db,&57,&aa
            .byte &21,&a1,&c0,&a9,&d5,&a6,&ae,&43
            .byte &a4,&a8,&52,&b5,&de,&20,&89,&53
            .byte &50,&c0,&a2,&41,&d5,&bd,&2e,&89
            .byte &93,&a4,&44,&c9,&41,&eb,&bc,&a3
            .byte &a9,&76,&a1,&43,&ab,&56,&49,&43
            .byte &45,&2c,&46,&b9,&4d,&99,&20,&55
            .byte &c4,&aa,&e1,&b5,&4e,&a0,&52,&49
            .byte &56,&aa,&a4,&8a,&b8,&ab,&d6,&53
            .byte &2e,&0d,&23,&5b,&8f,&89,&d5,&54
            .byte &c2,&a7,&7b,&a1,&90,&99,&20,&b8
            .byte &f4,&52,&d1,&53,&9d,&dd,&4f,&4b
            .byte &99,&20,&b5,&9f,&b3,&76,&a1,&ea
            .byte &42,&da,&9d,&42,&bc,&d3,&2e,&0d
            .byte &23,&5b,&7e,&a1,&ea,&42,&da,&9d
            .byte &85,&8f,&89,&af,&07,&ac,&43,&9d
            .byte &76,&a1,&53,&59,&53,&b1,&a7,&7b
            .byte &d1,&56,&b7,&2e,&7a,&89,&cf,&a7
            .byte &d4,&9a,&20,&7b,&89,&a9,&54,&aa
            .byte &49,&b9,&2c,&53,&b1,&50,&a4,&ae
            .byte &9d,&56,&c9,&49,&42,&c3,&2c,&43
            .byte &d4,&4d,&42,&99,&20,&19,&20,&89
            .byte &a9,&ca,&a3,&df,&f1,&20,&64,&53
            .byte &2e,&0d,&23,&5b,&7e,&a1,&b8,&b3
            .byte &a2,&53,&43,&ab,&9d,&53,&dd,&ea
            .byte &2e,&89,&e1,&b5,&4e,&a0,&49,&a4
            .byte &46,&02,&a7,&8a,&ef,&46,&9d,&48
            .byte &aa,&45,&2c,&1b,&9f,&46,&55,&52
            .byte &8b,&a3,&19,&20,&89,&88,&20,&8b
            .byte &52,&9d,&ae,&9d,&dd,&4f,&53,&9d
            .byte &df,&f1,&a4,&8a,&bb,&44,&bf,&9e
            .byte &50,&b6,&46,&c7,&4c,&53,&2e,&70
            .byte &5c,&2c,&89,&74,&20,&73,&be,&56
            .byte &aa,&a4,&89,&56,&c7,&c3,&59,&2e
            .byte &0d,&23,&5b,&7e,&a1,&4c,&b3,&47
            .byte &20,&57,&e2,&bf,&9e,&4a,&45,&54
            .byte &f3,&2c,&f8,&8b,&a3,&78,&20,&7b
            .byte &57,&bb,&d3,&2c,&ae,&9d,&57,&bb
            .byte &b1,&2c,&53,&b1,&cd,&20,&c0,&e7
            .byte &99,&53,&2e,&89,&4a,&45,&54,&54
            .byte &a2,&b8,&ab,&54,&43,&ad,&a4,&b5
            .byte &9f,&4f,&bd,&a3,&89,&53,&bc,&2e
            .byte &0d,&23,&5b,&7a,&89,&53,&50,&ae
            .byte &c6,&4c,&a2,&bd,&dc,&cc,&b1,&a0
            .byte &11,&8f,&4c,&8c,&53,&2e,&76,&89
            .byte &5d,&2c,&89,&23,&97,&20,&7b,&23
            .byte &58,&41,&41,&9e,&ab,&f6,&ad,&a4
            .byte &a9,&76,&89,&53,&4b,&59,&2e,&60
            .byte &20,&7b,&5c,&20,&49,&a4,&a1,&53
            .byte &c5,&d7,&2c,&57,&e2,&bf,&9e,&53
            .byte &b4,&f1,&2c,&b6,&a4,&df,&7b,&42
            .byte &df,&4b,&45,&9e,&8a,&b6,&a4,&c1
            .byte &4f,&a3,&48,&ac,&47,&99,&20,&dd
            .byte &4f,&c6,&4c,&a2,&6e,&17,&b8,&a2
            .byte &48,&99
l6d75:      .byte &b7,&2e,&a1,&62,&9d,&48,&d9,&4d
            .byte &99,&20,&e6,&ac,&41,&b1,&a4,&6e
            .byte &57,&49,&a8,&a9,&2e,&0d,&23,&5b
            .byte &7e,&a1,&56,&41,&b8,&2c,&90,&fc
            .byte &04,&9f,&50,&cb,&a9,&2c,&5f,&20
            .byte &7b,&89,&73,&42,&b5,&c4,&ae,&59
            .byte &2e,&44,&12,&9f,&bf,&56,&e7,&a4
            .byte &fc,&02,&4c,&20,&8a,&44,&ae,&9f
            .byte &41,&42,&b5,&9f,&89,&4c,&8c,&53
            .byte &d1,&ea,&2c,&53,&ed,&57,&aa,&99
            .byte &20,&5c,&20,&6d,&a1,&46,&a9,&45
            .byte &2c,&10,&b6,&9d,&db,&57,&44,&aa
            .byte &2e,&46,&c0,&e7,&20,&54,&ab,&b7
            .byte &2c,&c2,&4f,&20,&53,&c5,&d7,&20
            .byte &76,&43,&d4,&4d,&42,&2c,&ae,&43
            .byte &20,&8b,&49,&a3,&42,&ae,&9d,&d4
            .byte &4d,&42,&a4,&76,&89,&e1,&b5,&c4
            .byte &2e,&0d,&23,&5b,&7e,&a1,&50,&cb
            .byte &a9,&3a,&57,&49,&bf,&2c,&11,&8f
            .byte &8a,&90,&fc,&04,&54,&2e,&76,&89
            .byte &60,&20,&49,&a4,&a1,&4e,&ae,&df
            .byte &a6,&43,&c0,&57,&4c,&57,&41,&a2
            .byte &4c,&bc,&44,&99,&20,&a9,&76,&89
            .byte &74,&20,&c8,&ab,&b8,&2e,&89,&47
            .byte &41,&c3,&a4,&55,&d8,&e2,&9f,&0e
            .byte &59,&2c,&1c,&b6,&54,&4c,&9d,&14
            .byte &ac,&54,&a4,&8a,&da,&4f,&a6,&8b
            .byte &a7,&f6,&df,&53,&a4,&89,&4c,&8c
            .byte &2e,&0d,&2e,&0d,&2e,&0d,&00,&e0
            .byte &36,&83,&36,&02,&35,&83,&37,&00
            .byte &38,&82,&36,&00
l6e69:      .byte &3b,&01,&37,&02,&3b,&03,&38,&04
            .byte &3b,&05,&3b,&06,&37,&87,&37,&00
            .byte &3b,&01,&38,&02,&38,&03,&3a,&04
            .byte &3b,&05,&3b,&06,&38,&87,&38,&00
            .byte &3b,&01,&39,&02,&3b,&03,&39,&04
            .byte &3c,&05,&3b,&06,&38,&87,&39,&00
            .byte &38,&01,&38,&02,&39,&03,&3b,&04
            .byte &39,&05,&38,&06,&38,&87,&38,&00
            .byte &3d,&86,&3a,&01,&3c,&02,&3f,&03
            .byte &3e,&89,&94,&00,&40,&01,&42,&82
            .byte &3d,&00,&41,&01,&43,&83,&3d,&04
            .byte &cf,&87,&3e,&05,&cf,&86,&3f,&00
            .byte &3e,&81,&44,&00,&3f,&81,&45,&00
            .byte &42,&81,&46,&00,&43,&81,&48,&00
            .byte &44,&82,&47,&02,&48,&83,&46,&00
            .byte &45,&83,&47,&00,&92,&03,&93,&04
            .byte &d5,&85,&91,&80,&7f,&81,&7e,&81
            .byte &af,&00,&88,&02,&4e,&84,&89,&00
            .byte &89,&03,&4d,&04,&52,&85,&88,&00
            .byte &8b,&02,&50,&03,&de,&04,&51,&85
            .byte &8a,&00,&51,&03,&4f,&85,&8b,&00
            .byte &54,&01,&50,&05,&90,&07,&4f,&83
            .byte &8b,&00,&8d,&02,&53,&03,&89,&04
            .byte &8e,&05,&8c,&87,&4e,&00,&8e,&02
            .byte &8a,&03,&52,&04,&8f,&05,&8d,&86
            .byte &de,&00,&97,&01,&51,&03,&90,&05
            .byte &97,&87,&8b,&00,&97,&01,&88,&02
            .byte &8c,&04,&97,&86,&89,&00,&b8,&01
            .byte &63,&02,&57,&03,&62,&06,&64,&87
            .byte &61,&01,&64,&02,&58,&03,&56,&06
            .byte &65,&87,&63,&01,&65,&02,&dc,&03
            .byte &57,&06,&66,&87,&64,&01,&67,&02
            .byte &5e,&03,&dc,&06,&5b,&87,&66,&00
            .byte &6b,&81,&cf,&00,&5e,&02,&93,&03
            .byte &67,&85,&59,&00,&67,&03,&68,&85
            .byte &66,&00,&68,&03,&6b,&85,&69,&01
            .byte &5b,&03,&59,&87,&67,&00,&6a,&02
            .byte &6b,&84,&69,&00,&63,&02,&6a,&84
            .byte &64,&00,&62,&02,&63,&84,&56,&01
            .byte &61,&02,&56,&86,&63,&00,&56,&01
            .byte &60,&02,&64,&03,&61,&04,&57,&05
            .byte &62,&86,&6a,&00,&57,&01,&6a,&02
            .byte &65,&03,&63,&04,&58,&05,&56,&06
            .byte &69,&87,&60,&00,&58,&01,&69,&02
            .byte &66,&03,&64,&04,&dc,&05,&57,&06
            .byte &68,&87,&6a,&00,&dc,&01,&68,&02
            .byte &67,&03,&65,&04,&59,&05,&58,&06
            .byte &5c,&87,&69,&00,&59,&01,&5c,&02
            .byte &5b,&03,&66,&04,&5e,&05,&dc,&87
            .byte &68,&00,&66,&01,&5d,&02,&5c,&03
            .byte &69,&04,&67,&05,&65,&87,&6b,&00
            .byte &65,&01,&6b,&02,&68,&03,&6a,&04
            .byte &66,&05,&64,&06,&5d,&87,&5f,&00
            .byte &64,&01,&5f,&02,&69,&03,&60,&04
            .byte &65,&05,&63,&86,&6b,&00,&69,&01
            .byte &5a,&02,&5d,&03,&5f,&04,&68,&85
            .byte &6a,&01,&98,&84,&80,&87,&76,&86
            .byte &7e,&84,&70,&01,&6f,&03,&71,&86
            .byte &7a,&00,&72,&82,&70,&01,&71,&82
            .byte &73,&03,&72,&84,&81,&01,&75,&82
            .byte &76,&00,&74,&06,&80,&87,&7a,&00
            .byte &6d,&02,&78,&83,&74,&04,&78,&87
            .byte &80,&01,&7f,&02,&79,&03,&76,&87
            .byte &77,&03,&78,&86,&7b,&00,&75,&85
            .byte &70,&00,&79,&02,&7c,&83,&7f,&03
            .byte &7b,&86,&7d,&00,&7e,&85,&7c,&00
            .byte &4b,&01,&7d,&85,&6e,&01,&4a,&02
            .byte &7b,&85,&78,&01,&6c,&04,&77,&85
            .byte &75,&07,&73,&89,&82,&08,&81,&89
            .byte &dd,&01,&84,&83,&d5,&00,&83,&81
            .byte &85,&00,&84,&83,&87,&04,&87,&87
            .byte &d4,&08,&85,&89,&86,&00,&55,&01
            .byte &4d,&02,&89,&03,&d7,&04,&8c,&86
            .byte &4e,&00,&8c,&01,&4e,&02,&52,&03
            .byte &88,&04,&8d,&05,&55,&87,&4d,&00
            .byte &8f,&01,&de,&02,&8b,&03,&53,&04
            .byte &90,&05,&8e,&86,&4f,&00,&90,&01
            .byte &4f,&02,&51,&03,&8a,&04,&54,&05
            .byte &8f,&06,&50,&87,&de,&00,&97,&01
            .byte &89,&02,&8d,&03,&55,&04,&97,&05
            .byte &97,&06,&52,&87,&88,&00,&97,&01
            .byte &52,&02,&8e,&03,&8c,&04,&97,&05
            .byte &97,&06,&53,&87,&89,&00,&97,&01
            .byte &53,&02,&8f,&03,&8d,&04,&97,&05
            .byte &97,&06,&8a,&87,&52,&00,&97,&01
            .byte &8a,&02,&90,&03,&8e,&04,&97,&05
            .byte &97,&06,&8b,&87,&53,&00,&97,&01
            .byte &8b,&02,&54,&03,&8f,&04,&97,&05
            .byte &97,&06,&51,&87,&8a,&01,&93,&02
            .byte &92,&86,&49,&01,&49,&02,&d5,&03
            .byte &91,&87,&93,&00,&91,&02,&49,&03
            .byte &5b,&84,&92,&88,&3d,&81,&cd,&80
            .byte &a8,&81,&55,&00,&6c,&81,&dc,&63
            .byte &9a,&84,&af,&62,&99,&83,&9b,&02
            .byte &9a,&03,&9c,&e9,&9f,&02,&9b,&83
            .byte &9d,&60,&9e,&02,&9c,&88,&a2,&e1
            .byte &9d,&04,&a1,&05,&a0,&e8,&9b,&86
            .byte &9f,&87,&9f,&02,&a3,&09,&9d,&88
            .byte &a7,&02,&a4,&83,&a2,&01,&a9,&02
            .byte &a5,&83,&a3,&01,&aa,&02,&a6,&83
            .byte &a4,&01,&ab,&83,&a5,&02,&a8,&89
            .byte &a2,&61,&96,&83,&a7,&00,&a4,&e1
            .byte &ac,&00,&a5,&e1,&ad,&00,&a6,&e1
            .byte &ae,&e0,&a9,&e0,&aa,&e0,&ab,&00
            .byte &4c,&07,&99,&89,&b0,&08,&af,&89
            .byte &b1,&02,&b2,&88,&b0,&03,&b1,&86
            .byte &b3,&01,&b4,&85,&b2,&00,&b3,&01
            .byte &b7,&02,&b6,&83,&b5,&82,&b4,&83
            .byte &b4,&00,&b4,&03,&b9,&86,&b8,&01
            .byte &56,&85,&b7,&04,&b7,&87,&ba,&01
            .byte &bc,&03,&bb,&84,&b9,&82,&ba,&00
            .byte &ba,&81,&bd,&00,&bc,&01,&c5,&03
            .byte &be,&87,&c4,&01,&c4,&02,&bd,&86
            .byte &c5,&00,&c7,&01,&cb,&03,&c0,&85
            .byte &c6,&00,&c6,&02,&bf,&03,&c1,&04
            .byte &c7,&85,&c2,&00,&c2,&02,&c0,&e3
            .byte &d6,&00,&c3,&01,&c1,&02,&c6,&04
            .byte &c4,&86,&c0,&01,&c2,&02,&c4,&86
            .byte &c6,&00,&be,&01,&c6,&02,&c5,&03
            .byte &c3,&04,&bd,&06,&c7,&87,&c2,&00
            .byte &bd,&01,&c7,&03,&c4,&05,&be,&87
            .byte &c6,&00,&c4,&01,&c0,&02,&c7,&03
            .byte &c2,&04,&c5,&05,&c3,&06,&bf,&87
            .byte &c1,&00,&c5,&01,&bf,&03,&c6,&05
            .byte &c4,&87,&c0,&02,&c9,&88,&cb,&02
            .byte &ca,&03,&c8,&88,&cc,&03,&c9,&88
            .byte &cd,&00,&bf,&02,&cc,&89,&c8,&00
            .byte &95,&02,&cd,&03,&cb,&89,&c9,&00
            .byte &95,&02,&ce,&03,&cc,&89,&ca,&02
            .byte &cf,&83,&cd,&00,&5a,&02,&d0,&03
            .byte &ce,&06,&41,&07,&40,&88,&df,&02
            .byte &d1,&83,&cf,&02,&d2,&83,&d0,&00
            .byte &d3,&83,&d1,&01,&d2,&84,&d4,&01
            .byte &d3,&82,&86,&08,&92,&89,&83,&e2
            .byte &c1,&02,&88,&85,&d8,&02,&d7,&85
            .byte &d9,&02,&d8,&83,&da,&02,&d9,&83
            .byte &db,&82,&da,&10,&98,&01,&66,&02
            .byte &59,&03,&58,&06,&67,&87,&65,&02
            .byte &de,&88,&82,&00,&8a,&02,&4f,&03
            .byte &dd,&04,&8b,&85,&53,&08,&94,&89
            .byte &cf,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&ff
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
l736f:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &08,&07,&06,&44,&04,&7b,&72,&00
            .byte &00
l7400:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
l740a:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
l7414:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
.doorflag   .byte &01         ; 00 == xaan open
                              ; 01 == prison closed
                              ; 02 == prison opened
l741f:      .byte &00
l7420:      .byte &00
l7421:      .byte &00
l7422:      .byte &00
.grdprison  .byte &00         ; 1 == prison door open
l7424:      .byte &00
.guardflag  .byte &00         ; 
l7426:      .byte &00
l7427:      .byte &00
l7428:      .byte &00
l7429:      .byte &00,&00,&00,&00,&00,&00,&00,&00
l7431:      .byte &00
l7432:      .byte &00
l7433:      .byte &00
l7434:      .byte &00
l7435:      .byte &00,&00,&00,&00,&00,&00,&00,&00
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
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00
.objflags   .byte &00,&00,&55,&45,&00,&04,&04,&03
            .byte &44,&07,&00,&00,&00,&45,&20,&34
            .byte &34,&00,&45,&04,&10,&00,&34,&04
            .byte &34,&04,&20,&04,&00,&24,&34,&06
            .byte &20,&b4,&05,&05,&05,&10,&20,&05
            .byte &00,&00
.inventory  .byte &00,&00,&34,&d6
l74fa:      .byte &ac
l74fb:      .byte &ea
.broochloc  .byte &ff
.chainloc   .byte &02
l74fe:      .byte &35
l74ff:      .byte &27
l7500:      .byte &12
l7501:      .byte &6a,&ad,&ab
.foodloc    .byte &22
l7505:      .byte &e1
l7506:      .byte &0d
l7507:      .byte &ec
.guardloc   .byte &35
.hatloc     .byte &76
l750a:      .byte &e2
.lamploc    .byte &47
l750c:      .byte &e3
l750d:      .byte &c9
l750e:      .byte &ff
l750f:      .byte &b6
.oilloc     .byte &df
l7511:      .byte &70
l7512:      .byte &9e
l7513:      .byte &01
l7514:      .byte &6e
shovelloc:      .byte &24
l7516:      .byte &ae
l7517:      .byte &69,&a1,&91,&83
.umbrellaloc .byte &3d
.waterloc   .byte &98
l751d:      .byte &b5,&00,&00
l7520:      .byte &00,&00,&1f,&75,&76,&77,&78,&44
            .byte &42,&41,&50,&79,&7a,&1f,&43,&47
            .byte &6a,&7b
.guardalive .byte &55         ; &55 = guard alive
            .byte &6b,&79
.lampflag   .byte &3f         ; lamp flag 
            .byte &6c,&7c,&7d,&7e,&45,&7f,&80
            .byte &6d,&49,&48,&81,&46,&1f,&39,&1f
.umbrflag   .byte &3a         ; &3a = closed, &3b = opened
            .byte &1f,&6f,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&02
            .byte &03,&04,&05,&06,&06,&06,&06,&07
            .byte &08,&09,&0a,&0b,&0c,&0d,&0e,&0f
            .byte &10,&11,&12,&13,&14,&15,&16,&17
            .byte &18,&18,&18,&18,&18,&18,&18,&19
            .byte &19,&1b,&1a,&1a,&1a,&1c,&1e,&1d
            .byte &1d,&1d,&1d,&1d,&1d,&1d,&1f,&1f
            .byte &1f,&1f,&1f,&1f,&1f,&1f,&1f,&20
            .byte &21,&21,&21,&22,&22,&22,&22,&22
            .byte &22,&22,&22,&22,&22,&22,&22,&22
            .byte &22,&23,&24,&25,&26,&27,&28,&28
            .byte &28,&28,&29,&2a,&2a,&2a,&2a,&2b
            .byte &2b,&2b,&2b,&2b,&64,&2c,&65,&2d
            .byte &2e,&2f,&30
l75b8:      .byte &00,&31,&32,&33,&34,&35,&36,&37
            .byte &38,&39,&3a,&3b,&3b,&3b,&3c,&3d
            .byte &3e,&3f,&40,&41,&42,&43,&44,&45
            .byte &46,&47,&48,&48,&49,&4b,&4a,&4c
            .byte &4c,&4d,&4d,&4e,&4f,&50,&50,&50
            .byte &50,&63,&51,&51,&51,&51,&51,&51
            .byte &52,&52,&52,&53,&54,&54,&55,&56
            .byte &57,&57,&58,&59,&59,&5a,&5b,&62
            .byte &62,&62,&5c,&5d,&5e,&5f,&60,&61
            .byte &c4,&f9,&37,&b9,&ce,&74,&06,&2c
            .byte &81,&2b,&aa,&2e,&ca,&2f,&41,&57
            .byte &00,&09,&06,&c4,&ae,&78,&7c,&19
            .byte &42,&42,&4c,&4c,&59,&44,&44,&9b
            .byte &e9,&3c,&22,&56,&56,&60,&60,&a6
            .byte &a5,&8c,&c4,&c4,&2f,&06,&6a,&35
            .byte &3c,&8a,&3c,&4c,&96,&96,&c9,&96
            .byte &17,&18,&1f,&18,&19,&1e,&13,&1a
            .byte &1a,&1e,&1a,&14,&14,&12,&13,&22
            .byte &12,&1a,&18,&17,&19,&1f,&14,&1e
            .byte &1e,&1e,&1e,&1e,&18,&16,&16,&0c
            .byte &1f,&18,&1e,&1e,&1e,&1e,&1e,&17
            .byte &13,&21,&17,&1f,&12,&13,&1e,&1e
            .byte &18,&0c,&18,&13,&0c,&0c,&19,&0c
            .byte &00,&00,&00,&40,&61,&74,&74,&61
            .byte &63,&6b,&40,&62,&72,&65,&61,&6b
            .byte &40,&62,&6f,&61,&72,&64,&40,&63
            .byte &6c,&6f,&73,&65,&40,&63,&6c,&69
            .byte &6d,&62,&40,&64,&6f,&77,&6e,&40
            .byte &64,&72,&6f,&70,&40,&64,&69,&67
            .byte &40,&64,&72,&69,&6e,&6b,&40,&65
            .byte &61,&73,&74,&40,&65,&61,&74,&40
            .byte &65,&78,&61,&6d,&69,&6e,&65,&40
            .byte &66,&69,&6c,&6c,&40,&67,&65,&74
            .byte &40,&67,&6f,&40,&68,&65,&6c,&70
            .byte &40,&69,&6e,&76,&65,&6e,&74,&6f
            .byte &72,&79,&40,&6a,&75,&6d,&70,&40
            .byte &6b,&6e,&6f,&63,&6b,&40,&6b,&69
            .byte &6c,&6c,&40,&6b,&61,&74,&72,&6f
            .byte &73,&40,&6c,&6f,&6f,&6b,&40,&6c
            .byte &61,&6d,&70,&40,&6e,&6f,&72,&74
            .byte &68,&40,&6e,&65,&40,&6e,&6f,&72
            .byte &74,&68,&65,&61,&73,&74,&40,&6e
            .byte &77,&40,&6e,&6f,&72,&74,&68,&77
            .byte &65,&73,&74,&40,&6f,&70,&65,&6e
            .byte &40,&70,&75,&74,&40,&70,&6c,&61
            .byte &63,&65,&40,&71,&75,&69,&74,&40
            .byte &72,&65,&73,&74,&6f,&72,&65,&40
            .byte &72,&75,&62,&40,&73,&6f,&75,&74
            .byte &68,&40,&73,&65,&40,&73,&6f,&75
            .byte &74,&68,&65,&61,&73,&74,&40,&73
            .byte &77,&40,&73,&6f,&75,&74,&68,&77
            .byte &65,&73,&74,&40,&73,&69,&6e,&67
            .byte &40,&73,&65,&61,&72,&63,&68,&40
            .byte &73,&63,&6f,&72,&65,&40,&73,&74
            .byte &72,&61,&6e,&67,&6c,&65,&40,&73
            .byte &61,&76,&65,&40,&74,&61,&6b,&65
            .byte &40,&74,&68,&72,&6f,&77,&40,&75
            .byte &70,&40,&77,&65,&73,&74,&40,&77
            .byte &69,&73,&68,&40,&77,&61,&69,&74
            .byte &40,&77,&61,&76,&65,&40,&77,&65
            .byte &61,&72,&40,&73,&69,&74,&40,&6c
            .byte &69,&65,&40,&70,&72,&61,&79,&40
            .byte &0d,&40,&58,&40,&58,&40,&61,&6c
            .byte &63,&6f,&76,&65,&40,&62,&65,&67
            .byte &67,&61,&72,&40,&62,&6c,&61,&6e
            .byte &6b,&65,&74,&40,&62,&72,&61,&63
            .byte &65,&6c,&65,&74,&40,&62,&72,&6f
            .byte &6f,&63,&68,&40,&63,&68,&61,&69
            .byte &6e,&40,&63,&6c,&6f,&61,&6b,&40
            .byte &63,&6f,&69,&6e,&40,&63,&6f,&6d
            .byte &70,&61,&73,&73,&40,&64,&69,&61
            .byte &6d,&6f,&6e,&64,&40,&64,&6f,&6c
            .byte &6c,&40,&64,&72,&65,&73,&73,&65
            .byte &72,&40,&66,&6f,&6f,&64,&40,&67
            .byte &6c,&61,&73,&73,&65,&73,&40,&67
            .byte &6c,&6f,&76,&65,&73,&40,&67,&6f
            .byte &62,&6c,&65,&74,&40,&67,&75,&61
            .byte &72,&64,&40,&68,&61,&74,&40,&69
            .byte &6e,&67,&6f,&74,&40,&6c,&61,&6d
            .byte &70,&40,&6c,&65,&67,&67,&69,&6e
            .byte &67,&73,&40,&6c,&6f,&63,&6b,&65
            .byte &74,&40,&6d,&69,&74,&74,&65,&6e
            .byte &73,&40,&6e,&65,&63,&6b,&6c,&61
            .byte &63,&65,&40,&6f,&69,&6c,&40,&72
            .byte &69,&6e,&67,&40,&72,&75,&67,&40
            .byte &73,&61,&63,&6b,&69,&6e,&67,&40
            .byte &73,&68,&6f,&65,&73,&40,&73,&68
            .byte &6f,&76,&65,&6c,&40,&73,&6f,&61
            .byte &70,&40,&73,&6f,&63,&6b,&73,&40
            .byte &74,&61,&62,&6c,&65,&40,&74,&65
            .byte &6c,&65,&70,&72,&69,&6e,&74,&65
            .byte &72,&40,&74,&6f,&6f,&6c,&73,&68
            .byte &65,&64,&40,&75,&6d,&62,&72,&65
            .byte &6c,&6c,&61,&40,&77,&61,&74,&65
            .byte &72,&40,&77,&65,&6c,&6c,&40,&64
            .byte &6f,&6f,&72,&40,&6c,&75,&6c,&6c
            .byte &61,&62,&79,&40,&73,&6f,&6e,&67
            .byte &40,&73,&68,&69,&70,&40,&74,&6f
            .byte &77,&65,&72,&40,&74,&72,&65,&65
            .byte &40,&63,&6c,&69,&66,&66,&40,&6d
            .byte &6f,&75,&6e,&74,&61,&69,&6e,&40
            .byte &0d,&00,&00,&00,&40,&59,&4f,&55
            .byte &20,&41,&52,&45,&20,&40,&59,&4f
            .byte &55,&40,&4e,&4f,&52,&54,&48,&40
            .byte &53,&4f,&55,&54,&48,&40,&45,&41
            .byte &53,&54,&40,&57,&45,&53,&54,&40
            .byte &47,&55,&41,&52,&44,&20,&40,&53
            .byte &54,&52,&41,&4e,&47,&40,&43,&4f
            .byte &52,&52,&49,&44,&4f,&52,&20,&40
            .byte &57,&41,&4c,&4c,&40,&45,&58,&49
            .byte &54,&40,&57,&49,&4e,&44,&4f,&57
            .byte &40,&44,&4f,&57,&4e,&40,&4f,&50
            .byte &45,&4e,&40,&43,&4c,&4f,&53,&45
            .byte &40,&52,&4f,&4f,&4d,&40,&4c,&4f
            .byte &43,&4b,&45,&44,&40,&50,&52,&49
            .byte &53,&4f,&4e,&20,&43,&45,&4c,&4c
            .byte &40,&57,&49,&54,&48,&20,&40,&46
            .byte &52,&4f,&4d,&20,&40,&41,&42,&4f
            .byte &56,&45,&20,&40,&42,&45,&4c,&4f
            .byte &57,&20,&40,&53,&45,&45,&40,&4d
            .byte &4f,&55,&4e,&54,&41,&49,&4e,&20
            .byte &40,&46,&4f,&52,&45,&53,&54,&20
            .byte &40,&44,&41,&52,&4b,&40,&50,&41
            .byte &54,&48,&40,&54,&4f,&20,&40,&43
            .byte &41,&56,&45,&52,&4e,&40,&53,&49
            .byte &44,&45,&40,&54,&52,&45,&41,&53
            .byte &55,&52,&45,&20,&40,&49,&4e,&20
            .byte &40,&4f,&46,&20,&40,&43,&4c,&49
            .byte &46,&46,&40,&4d,&41,&5a,&45,&40
            .byte &4f,&4e,&20,&40,&41,&44,&56,&45
            .byte &4e,&54,&55,&52,&45,&40,&43,&4f
            .byte &50,&59,&52,&49,&47,&48,&54,&20
            .byte &28,&43,&29,&20,&31,&39,&38,&34
            .byte &40,&54,&48,&41,&54,&20,&40,&4c
            .byte &45,&53,&53,&40,&47,&55,&4c,&4c
            .byte &59,&20,&40,&54,&52,&45,&4e,&43
            .byte &48,&40,&42,&45,&41,&43,&48,&20
            .byte &40,&54,&55,&4e,&4e,&45,&4c,&20
            .byte &40,&41,&57,&41,&59,&40,&48,&49
            .byte &4c,&4c,&40,&54,&48,&45,&20,&40
            .byte &41,&4e,&44,&20,&40,&54,&48,&45
            .byte &40,&41,&4e,&44,&40,&52,&49,&44
            .byte &40,&4f,&4e,&4c,&59,&20,&40,&41
            .byte &54,&20,&40,&57,&49,&4e,&44,&40
            .byte &54,&59,&50,&45,&40,&42,&41,&43
            .byte &4b,&20,&40,&57,&41,&54,&45,&52
            .byte &40,&46,&4c,&4f,&4f,&52,&20,&40
            .byte &53,&48,&49,&50,&40,&53,&41,&4e
            .byte &44,&40,&54,&4f,&57,&45,&52,&40
            .byte &4e,&27,&54,&20,&40,&49,&4e,&47
            .byte &40,&47,&48,&54,&40,&4f,&55,&53
            .byte &40,&49,&4f,&4e,&40,&45,&20,&40
            .byte &4e,&20,&40,&54,&20,&40,&44,&20
            .byte &40,&41,&20,&40,&59,&20,&40,&52
            .byte &20,&40,&53,&20,&40,&49,&20,&40
            .byte &57,&20,&40,&4d,&20,&40,&54,&48
            .byte &40,&49,&4e,&40,&45,&52,&40,&52
            .byte &45,&40,&41,&4e,&40,&48,&45,&40
            .byte &41,&52,&40,&45,&4e,&40,&54,&49
            .byte &40,&54,&45,&40,&41,&54,&40,&4f
            .byte &4e,&40,&48,&41,&40,&4f,&55,&40
            .byte &49,&54,&40,&45,&53,&40,&53,&54
            .byte &40,&4f,&52,&40,&4e,&54,&40,&48
            .byte &49,&40,&45,&41,&40,&56,&45,&40
            .byte &43,&4f,&40,&44,&45,&40,&52,&41
            .byte &40,&44,&4f,&40,&54,&4f,&40,&4c
            .byte &45,&40,&4e,&44,&40,&4d,&41,&40
            .byte &53,&45,&40,&41,&4c,&40,&46,&4f
            .byte &40,&49,&53,&40,&4e,&45,&40,&4c
            .byte &41,&40,&54,&41,&40,&45,&4c,&40
            .byte &49,&53,&40,&44,&49,&40,&53,&49
            .byte &40,&43,&41,&40,&55,&4e,&40,&43
            .byte &48,&40,&4c,&49,&40,&42,&4f,&40
            .byte &41,&4d,&40,&4c,&4c,&40,&50,&52
            .byte &40,&55,&4d,&40,&42,&4c,&40,&50
            .byte &4f,&40,&47,&45,&40,&4c,&4f,&40
            .byte &47,&48,&40,&52,&4f,&40,&45,&44
            .byte &40,&47,&52,&40,&4f,&4f,&40,&4e
            .byte &41,&40,&53,&4d,&40,&4f,&4d,&40
            .byte &45,&4d,&40,&49,&4c,&40,&4d,&50
            .byte &40,&48,&55,&40,&50,&45,&40,&50
            .byte &50,&40,&50,&49,&40,&48,&4f,&40
            .byte &4e,&4f,&40,&53,&41,&40,&51,&55
            .byte &40,&43,&4b,&40,&4d,&45,&40,&54
            .byte &59,&40,&41,&49,&40,&47,&4f,&40
            .byte &41,&43,&40,&41,&46,&40,&45,&49
            .byte &40,&45,&58,&40,&55,&54,&40,&4f
            .byte &47,&40,&53,&57,&40,&41,&44,&40
            .byte &53,&4c,&40,&41,&4b,&40,&4d,&4f
            .byte &40,&4d,&49,&40,&49,&52,&40,&53
            .byte &4f,&40,&45,&50,&40,&57,&45,&40
            .byte &47,&49,&40,&54,&52,&40,&42,&45
            .byte &40,&50,&48,&40,&41,&53,&40,&45
            .byte &45,&40,&45,&56,&40,&44,&52,&40
            .byte &53,&48,&40,&57,&48,&40,&46,&4c
            .byte &40,&55,&53,&40,&4f,&57,&40,&50
            .byte &4c,&40,&44,&55,&40,&44,&41,&40
            .byte &52,&55,&40,&49,&47,&40,&55,&50
            .byte &40,&42,&49,&40,&42,&55,&40,&42
            .byte &52,&40,&46,&52,&40,&50,&41,&40
            .byte &41,&59,&40,&0d
