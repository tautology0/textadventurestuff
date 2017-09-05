;
; User equates
;
OSCLI       = &FFF7
OSBYTE      = &FFF4
OSWRCH      = &FFEE
OSNEWL      = &FFE7
OSRDCH      = &FFE0
;
; Code equates
;
L000D       = &000D
L0020       = &0020
L0029       = &0029
L002B       = &002B
L003A       = &003A
L0044       = &0044
L0045       = &0045
L0051       = &0051
L0058       = &0058
L0060       = &0060
L0061       = &0061
L0068       = &0068
L006A       = &006A
L006B       = &006B
L006D       = &006D
L0074       = &0074
L007B       = &007B
L007C       = &007C
L007D       = &007D
L007E       = &007E
L007F       = &007F
L0084       = &0084
L0085       = &0085
L0088       = &0088
L0089       = &0089
L008A       = &008A
L008B       = &008B
L008C       = &008C
L008D       = &008D
L008E       = &008E
L0522       = &0522
L0523       = &0523
L0525       = &0525
L0526       = &0526
L0527       = &0527
L0900       = &0900
L0922       = &0922
L09CF       = &09CF
L0A00       = &0A00
L0B00       = &0B00
L0B22       = &0B22
L0B28       = &0B28
L0B3D       = &0B3D
L0BD8       = &0BD8
L0BE9       = &0BE9
L0C00       = &0C00
L0C3E       = &0C3E
L0C72       = &0C72
L0C80       = &0C80
L0C85       = &0C85
L0C91       = &0C91
L0C96       = &0C96
L0CCE       = &0CCE
L1855       = &1855
L1C03       = &1C03
L1C16       = &1C16
L20AC       = &20AC
;
; Start of code
;
            *= &1200
;
            bne L1224
            ldx #&0B
            jsr L09CF
            ldx #&00
            lda #&01
            jsr L158E
            ldx #&0C
            jsr L09CF
            ldx #&01
            lda #&01
            jsr L158E
            cpy #&00
            bne L1223
L121E:      lda #&7F
            jmp L15AB
L1223:      rts
L1224:      jmp L0C91
L1227:      lda #&3F
            sta L7535
            jmp L1290
            bne L1236
L1231:      ldx #&0A
            jmp L0C72
L1236:      cpx #&FF
            beq L1243
            cpx #&28
            bcc L1246
L123E:      ldx #&11
            jmp L0C72
L1243:      jmp L0C85
L1246:      stx L0525
            lda L74F6,X
            beq L1272
            cmp L0088
            beq L127C
            cmp #&01
            beq L127C
            cmp #&28
            bcs L1268
            tax
            lda L74F6,X
            beq L127C
            cmp #&01
            beq L127C
            cmp L0088
            beq L127C
L1268:      ldx #&0E
L126A:      jsr L09CF
            ldx #&12
            jmp L0C72
L1272:      ldx #&0F
L1274:      jsr L09CF
            ldx #&1A
            jmp L126A
L127C:      lda L008B
            cmp #&07
            bcs L12AE
            ldx L0525
            cpx #&1A
            beq L1227
            cpx #&26
            bne L1290
            jmp L12FE
L1290:      lda L74CC,X
            and #&0F
            bne L12B3
L1297:      jsr L1854
L129A:      inc L008B
            ldx L0525
            lda L74F6,X
            cmp #&01
            bne L12A8
            dec L008C
L12A8:      lda #&00
            sta L74F6,X
            rts
L12AE:      ldx #&16
            jmp L0C72
L12B3:      cmp #&04
            beq L1297
            cmp #&05
            beq L12D6
            cmp #&06
            beq L12DB
            cmp #&07
            beq L12EF
            tay
            txa
            pha
            tya
            clc
            adc #&12
            tax
            jsr L0C72
            pla
            tax
            dec L74CC,X
            beq L129A
            rts
L12D6:      ldx #&1C
            jmp L0C72
L12DB:      lda L7514
            cmp #&01
            bne L12EA
            lda #&00
            sta L74CC,X
            jmp L1297
L12EA:      ldx #&68
            jmp L0C72
L12EF:      lda L751C
            cmp #&27
            bne L12EA
            lda #&00
            sta L74CC,X
            jmp L1297
L12FE:      ldx #&71
            jmp L0C72
L1303:      jmp L1243
            bne L130B
            jmp L1231
L130B:      ldy L0088
L130D:      sty L008A
            cpx #&FF
            beq L1303
            cpx #&28
            bcc L131A
            jmp L123E
L131A:      lda L008B
            bne L132D
            ldx #&10
            jsr L09CF
            ldx #&1A
            jsr L09CF
            ldx #&18
            jmp L0C72
L132D:      lda L74F6,X
            beq L1337
L1332:      ldx #&10
            jmp L1274
L1337:      dec L008B
            lda L008A
            sta L74F6,X
            jmp L1854
            ldx #&19
            jmp L0C72
L1346:      jmp L142E
L1349:      jmp L0C85
            bne L1351
            jmp L1231
L1351:      cpx #&FF
            beq L1349
            cpx #&28
            bcc L135C
            jmp L123E
L135C:      lda L74CC,X
            and #&0F
            cmp #&04
            beq L1368
            jmp L123E
L1368:      lda L74F6,X
            beq L1374
            cpx #&01
            beq L139B
            jmp L1332
L1374:      lda L008C
            cmp #&07
            bcs L1396
            cpx #&13
            bne L138A
            lda L751C
            cmp #&13
            bne L138A
            ldx #&72
            jmp L0C72
L138A:      lda #&01
            sta L74F6,X
            inc L008C
            dec L008B
            jmp L1854
L1396:      ldx #&17
            jmp L0C72
L139B:      ldx #&0F
            jsr L09CF
            ldx #&1B
            jmp L126A
            bne L1346
L13A7:      ldx #&52
            jsr L09CF
            ldx L0088
            lda #&00
            jsr L158E
            cpy #&00
            bne L13BA
            jmp L121E
L13BA:      rts
L13BB:      sty L0526
            lda #&83
            jsr OSWRCH
            txa
            pha
            lda #&30
            sta L0527
            lda #&00
            ldx L0526
            beq L13DF
            sed
            clc
L13D3:      adc #&01
            bcc L13DB
            inc L0527
            clc
L13DB:      dex
            bne L13D3
            cld
L13DF:      tay
            lda L0527
            cmp #&30
            beq L140B
L13E7:      jsr OSWRCH
            tya
            lsr A
            lsr A
            lsr A
            lsr A
            clc
            adc #&30
            cmp #&30
            beq L1410
L13F6:      jsr OSWRCH
            tya
            and #&0F
            adc #&30
            jsr OSWRCH
            pla
            tax
            ldy L0526
            lda #&86
            jmp OSWRCH
L140B:      lda #&83
            jmp L13E7
L1410:      ldx L0527
            cpx #&31
            bcs L13F6
            lda #&83
            jmp L13F6
L141C:      ldy L008D
            jsr L13BB
            lda #&2F
            jsr OSWRCH
            ldy #&FA
            jsr L13BB
            jmp L15B3
L142E:      bne L1433
            jmp L1231
L1433:      cpx #&FF
            bne L143A
L1437:      jmp L0C85
L143A:      cpx #&28
            bcc L1441
            jmp L123E
L1441:      lda L74F6,X
            beq L1451
            cmp #&01
            beq L1451
            cmp L0088
            beq L1451
            jmp L1268
L1451:      cpx #&0A
            bne L1458
            jmp L197B
L1458:      lda L7520,X
            stx L0525
            tax
            jsr L09CF
L1462:      ldx #&52
            jsr L09CF
            lda #&02
            ldx L0525
            jsr L158E
            cpy #&00
            bne L1476
            jmp L121E
L1476:      rts
L1477:      ldx #&20
            jmp L0C72
            bne L14C7
            lda L750B
            bne L1477
            ldx L7535
            cpx #&3F
            beq L14C1
            cpx #&40
            beq L14B7
            lda L008E
            beq L14C1
            cpx #&3D
            beq L14A8
            cpx #&3E
            beq L14A8
            lda L008E
            cmp #&28
            bcc L14BC
            ldx #&3D
L14A2:      stx L7535
            jmp L0C72
L14A8:      lda L7420
            beq L14B2
            ldx #&69
            jsr L09CF
L14B2:      ldx #&3C
            jmp L14A2
L14B7:      ldx #&40
            jmp L14A2
L14BC:      ldx #&3E
            jmp L14A2
L14C1:      jmp L14A2
L14C4:      jmp L1231
L14C7:      jmp L1224
            beq L14C4
            cpx #&FF
            beq L150D
            cpx #&15
            beq L14E2
            cpx #&27
            bne L14DB
            jmp L195D
L14DB:      cpx #&13
            bne L14C7
            jmp L1938
L14E2:      lda L750B
            bne L1477
            lda L7510
            beq L14FE
            ldx #&10
            jsr L09CF
            ldx #&1A
            jsr L09CF
            ldx #&1A
            jsr L0CCE
            jmp L15B3
L14FE:      lda #&3C
            sta L7535
            lda #&15
            sta L7510
            dec L008B
            jmp L0C96
L150D:      jmp L1437
L1510:      lda #&00
            sta L7427
            ldx L7535
            cpx #&3D
            beq L1521
            cpx #&3E
            beq L1521
            rts
L1521:      lda #&01
            sta L7427
            lda L008E
            cmp #&01
            beq L1535
            cmp #&27
            bcc L1541
            beq L1549
            dec L008E
            rts
L1535:      dec L008E
            lda #&FF
            sta L7510
            ldx #&3F
            jmp L14A2
L1541:      ldx #&3E
            stx L7535
            dec L008E
            rts
L1549:      dec L008E
            jmp L14BC
            jmp L1231
L1551:      tya
            pha
            stx L0525
            lda L74CC,X
            and #&3F
            lsr A
            lsr A
            lsr A
            lsr A
            clc
            adc #&4B
            tax
            jsr L09CF
            jsr L0B28
            cpx #&1C
            bcs L1588
L156D:      ldx L0525
            jsr L0CCE
            pla
            tay
            iny
            cpy L006A
            beq L1583
            tya
            pha
            ldx #&4F
            jsr L09CF
            pla
            tay
L1583:      dey
            ldx L0525
            rts
L1588:      jsr L0B22
            jmp L156D
L158E:      sta L0523
            stx L008A
            ldy #&00
            sty L0522
            jsr L15C1
            dey
            beq L15B9
            sty L006A
            inc L0522
            jsr L15C1
L15A6:      lda #&7F
            jsr OSWRCH
L15AB:      jsr OSWRCH
            lda #&2E
            jsr OSWRCH
L15B3:      jsr OSNEWL
            jmp OSNEWL
L15B9:      ldx #&0D
            jsr L09CF
            ldy #&00
            rts
L15C1:      ldy #&01
            ldx #&02
L15C5:      lda L74F6,X
            cmp L008A
            bne L15EB
            lda L0523
            beq L160D
            lda L0522
            beq L15E6
            lda L0523
            cmp #&02
            beq L15E3
            jsr OSNEWL
            jsr L13BB
L15E3:      jsr L1551
L15E6:      iny
            cpy L006A
            beq L15F1
L15EB:      inx
            cpx #&28
            bne L15C5
            rts
L15F1:      lda L0522
            beq L15EB
            stx L0525
            tya
            pha
            lda #&20
            jsr OSWRCH
            ldx #&36
            jsr L09CF
            pla
            tay
            ldx L0525
            jmp L15EB
L160D:      lda L7420
            beq L1628
            lda L74CC,X
            bmi L1630
            lda L750B
            beq L1623
            cmp L008A
            beq L1623
L1620:      jmp L15EB
L1623:      lda L7427
            beq L1620
L1628:      lda L0522
            beq L15E6
            jmp L15E3
L1630:      lda L750B
            beq L163C
            cmp L008A
            beq L163C
            jmp L1628
L163C:      lda L7427
            beq L1628
            jmp L1620
            bne L1649
            jmp L1231
L1649:      cpx #&FF
            bne L1650
            jmp L0C85
L1650:      cpx #&28
            bcc L1657
L1654:      jmp L123E
L1657:      lda L74F6,X
            beq L165F
            jmp L1332
L165F:      stx L0525
            ldx #&53
            jsr L0C72
            jsr L0B3D
            jsr OSNEWL
            jsr L0BD8
            jsr L0C80
            beq L16AC
            cpx #&FF
            beq L16BB
            cpx L0525
            beq L1654
            cpx #&15
            beq L16B1
            lda L74CC,X
            and #&40
            beq L1654
            lda L74F6,X
            beq L1699
            cmp #&01
            beq L1699
            cmp L0088
            beq L1699
            jmp L1268
L1699:      txa
            tay
            ldx L0525
            lda #&05
            sta L1855
            jsr L130D
            lda #&67
            sta L1855
            rts
L16AC:      ldx #&54
            jmp L0C72
L16B1:      lda L0525
            cmp #&1A
            bne L1654
            jmp L14E2
L16BB:      jmp L1224
L16BE:      lda #&00
            sta L0089
            sta L7424
            sta L7422
            sta L7425
            sta L7423
            sta L7428
            sta L007B
            lda #&89
            sta L006B
            jsr L0B3D
            jsr L0BE9
            jsr L0BD8
            jsr L0C3E
            jsr L1510
            lda L0089
            cmp #&09
            beq L1722
            jsr L1AD3
            lda L007B
            bne L1722
            lda L7425
            bne L1700
            lda L7428
            bne L1700
            jmp L1754
L1700:      lda L741F
            bne L1732
L1705:      lda L7421
            bne L170B
            rts
L170B:      lda L74FE
            cmp #&01
            beq L1722
            ldx #&24
            jsr L0C72
            ldy L7426
            iny
            cpy #&05
            beq L1723
            sty L7426
L1722:      rts
L1723:      ldx #&26
L1725:      jsr L09CF
L1728:      lda #&01
            sta L7422
            ldx #&27
            jmp L0C72
L1732:      lda L7545
            cmp #&3A
            beq L173C
            jmp L1705
L173C:      lda L751B
            beq L1748
            cmp L0088
            beq L174A
            jmp L1705
L1748:      dec L008B
L174A:      lda #&FF
            sta L751B
            ldx #&4A
            jmp L0C72
L1754:      lda L7508
            cmp L0088
            bne L1700
            lda L7532
            cmp #&55
            bne L1700
            lda L0088
            cmp #&34
            beq L176F
            cmp #&3C
            beq L176F
            jmp L1700
L176F:      lda L0088
            cmp #&34
            beq L1787
            lda L7424
            beq L178F
            lda #&57
            sta L7532
            ldx #&58
            jsr L0C72
            jmp L1700
L1787:      lda L7423
            beq L1794
            jmp L1700
L178F:      ldx #&59
            jmp L1725
L1794:      lda #&35
            sta L7508
            lda #&01
            sta L741E
            ldx #&5A
            jsr L0C72
            jmp L1700
            beq L17B5
            cpx #&29
            beq L17BA
            cpx #&2A
            beq L17B5
            ldx #&5B
            jmp L0C72
L17B5:      ldx #&5C
            jmp L0C72
L17BA:      lda #&01
            sta L7424
            ldx #&5D
            jmp L0C72
            bne L17C9
            jmp L1231
L17C9:      cpx #&FF
            bne L17D0
            jmp L1243
L17D0:      cpx #&12
            beq L17D7
            jmp L123E
L17D7:      lda L7508
            cmp L0088
            beq L17E1
            jmp L1268
L17E1:      lda L74FD
            bne L1801
            lda #&01
            sta L7423
            lda #&56
            sta L7532
            ldx #&5E
            jsr L09CF
            dec L008B
            ldx #&FF
            stx L74FD
            ldx #&61
            jmp L0C72
L1801:      ldx #&5F
            jmp L0C72
            beq L1817
            cpx #&FF
            bne L180F
            jmp L1243
L180F:      cpx #&28
            bcc L1837
            cpx #&28
            bne L1837
L1817:      lda L741E
            cmp #&01
            beq L1821
            jmp L123E
L1821:      lda L0088
            cmp #&34
            bne L1837
            sta L7508
            lda #&00
            sta L741E
            ldx #&62
            stx L7425
            jmp L0C72
L1837:      ldx #&1D
            jmp L0C72
            beq L1837
            cpx #&FF
            bne L1845
            jmp L1243
L1845:      cpx #&28
            bcc L184C
            jmp L123E
L184C:      lda L74F6,X
            beq L1837
            jmp L1332
L1854:      ldx #&67
            jmp L0C72
            bne L185E
            jmp L1231
L185E:      cpx #&FF
            bne L1865
            jmp L1243
L1865:      cpx #&25
            beq L1870
            cpx #&28
            beq L1880
            jmp L1224
L1870:      lda L751B
            beq L1878
            jmp L1332
L1878:      ldx #&3A
            stx L7545
            jmp L0C72
L1880:      lda L741E
            cmp #&02
            bne L188A
            jmp L1268
L188A:      cmp #&01
            beq L1891
            jmp L123E
L1891:      lda L0088
            cmp #&34
            bne L189C
L1897:      ldx #&65
            jmp L0C72
L189C:      cmp #&99
            beq L1897
            lda #&00
            sta L741E
L18A5:      lda L741E
            beq L18AF
            cmp #&01
            beq L18B4
            rts
L18AF:      ldx #&63
            jmp L0C72
L18B4:      ldx #&64
            jmp L0C72
            bne L18BE
            jmp L1231
L18BE:      cpx #&FF
            bne L18C5
            jmp L1243
L18C5:      cpx #&25
            beq L18D0
            cpx #&28
            beq L18E0
            jmp L1224
L18D0:      lda L751B
            beq L18D8
            jmp L1332
L18D8:      ldx #&3B
            stx L7545
            jmp L0C72
L18E0:      lda L741E
            cmp #&02
            bne L18EA
            jmp L1268
L18EA:      cmp #&00
            beq L18F1
            jmp L123E
L18F1:      lda #&01
            sta L741E
            jmp L18A5
            bne L18FE
            jmp L1231
L18FE:      cpx #&FF
            bne L1905
            jmp L1243
L1905:      cpx #&28
            bcc L190C
            jmp L123E
L190C:      lda L74F6,X
            beq L1914
            jmp L1332
L1914:      dec L008B
            lda #&FF
            sta L74F6,X
            cpx #&0C
            beq L1929
            ldx #&67
L1921:      jsr L09CF
            ldx #&6E
            jmp L0C72
L1929:      ldx #&67
            jsr L09CF
            ldx #&9D
            lda L0088
            sta L74FC
            jmp L1921
L1938:      lda L7509
            beq L1940
            jmp L1477
L1940:      lda L751C
            cmp #&13
            beq L1958
            cmp L0088
            bne L1953
            lda #&13
            sta L751C
            jmp L0C96
L1953:      ldx #&70
            jmp L0C72
L1958:      ldx #&72
            jmp L0C72
L195D:      lda L751D
            cmp L0088
            beq L1967
            jmp L1268
L1967:      lda L751C
            cmp #&13
            bne L1953
            lda L7509
            bne L1953
            lda #&27
            sta L751C
            jmp L0C96
L197B:      lda L0088
            cmp #&38
            bcc L19AB
            cmp #&3C
            bcs L19AB
            ldx #&51
            jsr L09CF
            ldx #&30
            lda L0088
            cmp #&38
            beq L199A
            cmp #&39
            beq L19A3
            cmp #&3B
            beq L19A7
L199A:      jsr L09CF
            jsr L15A6
            jmp L1462
L19A3:      dex
            jmp L199A
L19A7:      dex
            jmp L19A3
L19AB:      jmp L1458
            lda L0088
            cmp #&99
            beq L19B7
            jmp L1837
L19B7:      lda L741E
            bne L19BF
            jmp L1837
L19BF:      lda #&00
            sta L741E
            ldx #&9F
            jmp L0C72
            ldx #&86
            jmp L0C72
            bne L19D3
            jmp L1231
L19D3:      cpx #&FF
            bne L19DA
            jmp L1243
L19DA:      lda L0088
            cmp #&46
            bcc L19E4
            cmp #&6C
            bcc L19E9
L19E4:      ldx #&23
            jmp L0C72
L19E9:      cmp #&5A
            bcc L19F9
            cpx #&2D
            beq L19F4
L19F1:      jmp L123E
L19F4:      ldx #&38
            jmp L0C72
L19F9:      cpx #&2E
            beq L1A01
            cpx #&2F
            bne L19F1
L1A01:      ldx #&29
            jsr L09CF
            jmp L1728
            beq L1A0E
L1A0B:      jmp L1224
L1A0E:      lda L0088
            cmp #&46
            bcc L1A1C
            cmp #&49
            bcc L1A1F
            cmp #&4D
            bcc L1A27
L1A1C:      jmp L0C96
L1A1F:      ldx #&37
L1A21:      jsr L09CF
            jmp L1728
L1A27:      ldx #&25
            jmp L1A21
            bne L1A0B
            lda L7515
            beq L1A38
            ldx #&21
            jmp L0C72
L1A38:      lda L0088
            cmp #&83
            bcc L1A4C
            cmp #&87
            bcc L1A51
            beq L1A4C
            cmp #&8C
            bcc L1A59
            cmp #&91
            bcc L1A5E
L1A4C:      ldx #&22
            jmp L0C72
L1A51:      jsr L1A66
            ldx #&82
            jmp L0C72
L1A59:      ldx #&83
            jmp L0C72
L1A5E:      jsr L1A66
            ldx #&84
            jmp L0C72
L1A66:      ldx #&27
            lda L0088
            clc
            adc #&5D
            sta L0526
L1A70:      lda L74F6,X
            cmp L0526
            bne L1A7D
            lda L0088
            sta L74F6,X
L1A7D:      dex
            bpl L1A70
            rts
            bne L1A86
            jmp L1231
L1A86:      cpx #&FF
            bne L1A8D
            jmp L1243
L1A8D:      cpx #&26
            beq L1A94
            jmp L123E
L1A94:      lda L751C
            cmp L0088
            beq L1AA2
            cmp #&13
            beq L1AA2
            jmp L1268
L1AA2:      lda #&FF
            sta L751C
            jmp L1854
            bne L1AAF
            jmp L1231
L1AAF:      cpx #&FF
            bne L1AB6
            jmp L1243
L1AB6:      cpx #&0E
            beq L1ABD
            jmp L123E
L1ABD:      lda L7504
            beq L1AC9
            cmp L0088
            beq L1ACB
            jmp L1268
L1AC9:      dec L008B
L1ACB:      lda #&FF
            sta L7504
            jmp L1854
L1AD3:      jsr L20D0
            lda L0088
            jsr L1CFF
            lda L007C
            beq L1AE2
            jmp L1728
L1AE2:      lda L0088
            cmp #&63
            bcc L1AF4
            cmp #&83
            bcs L1AF4
            lda #&01
            sta L7420
            jmp L1AF9
L1AF4:      lda #&00
            sta L7420
L1AF9:      lda L0088
            cmp #&35
            bcc L1B13
            cmp #&56
            bcc L1B0B
            cmp #&88
            bcc L1B13
            cmp #&94
            bcs L1B13
L1B0B:      lda #&01
            sta L7421
            jmp L1B18
L1B13:      lda #&00
            sta L7421
L1B18:      lda L0088
            cmp #&46
            bcc L1B32
            cmp #&56
            bcc L1B2A
            cmp #&88
            bcc L1B32
            cmp #&94
            bcs L1B32
L1B2A:      lda #&01
            sta L741F
            jmp L1B37
L1B32:      lda #&00
            sta L741F
L1B37:      lda L0088
            cmp #&83
            bcc L1B73
            cmp #&88
            bcs L1B73
            lda L7505
            cmp #&01
            bne L1B73
            lda #&CF
            sta L0088
            ldx #&85
            jsr L0C72
            ldx #&27
L1B53:      lda L74F6,X
            beq L1B68
            cmp #&01
            beq L1B70
L1B5C:      dex
            bpl L1B53
            lda #&00
            sta L008B
            sta L008C
            jmp L1C00
L1B68:      lda #&BB
            sta L74F6,X
            jmp L1B5C
L1B70:      jmp L1B68
L1B73:      rts
            .byte &32,&3A,&53,&54
            eor (L0074,X)
            adc L006D
            bvs L1BF6
            and L003A
            .byte &54
            eor (L0058,X)
            .byte &3A,&43
            bvc L1BDF
            .byte &23
            bmi L1BC4
            .byte &42
            eor L0051
            ror L736F
            adc L0061
            .byte &72,&63
            pla
            .byte &3A
            jmp L5844
            .byte &23
            bmi L1BA9
            .byte &00
            ldx L2E5A,Y
            jmp L4F4F
            bvc L1BDF
            jmp L4144
            plp
L1BA9:      eor L0058
            and L0029
            bit L3A59
            .byte &42
            eor L6349
            .byte &6B
            ror L6D75
            .byte &3A
            rol L6E69
            .byte &63,&3A
            jmp L4144
            .byte &23,&32,&3A
L1BC4:      .byte &43
            jmp L3A43
            eor (L0044,X)
            .byte &43
            eor L0058
            and L003A
            .byte &53,&54
            eor (L0045,X)
            cli
            and L003A
            jmp L4144
            .byte &23
            bmi L1C16
            eor (L0044,X)
            .byte &43
L1BDF:      eor L0058
            and L002B
            and (L003A),Y
            .byte &53,&54
            eor (L0045,X)
            cli
            and L002B
            and (L003A),Y
            lsr A
            eor L4C50
            .byte &4F,&4F
            bvc L1C03
L1BF6:      .byte &00
            iny
            .byte &1F
            rol L6B63
            ror L6D75
            .byte &3A
L1C00:      lda #&5C
            sta L007E
            lda #&6E
            sta L007F
            ldy #&00
            tya
L1C0B:      sta L7400,Y
            iny
            cpy #&1F
            bne L1C0B
            lda #&02
            sta L741E
            ldy #&00
            lda L0088
            sec
            sbc #&34
            sta L007D
            tax
            cpx #&00
            beq L1C43
            ldx #&00
L1C28:      lda (L007E),Y
            bmi L1C3C
L1C2C:      lda #&02
            clc
            adc L007E
            sta L007E
            lda #&00
            adc L007F
            sta L007F
            jmp L1C28
L1C3C:      inx
            cpx L007D
            bne L1C2C
            iny
            iny
L1C43:      lda (L007E),Y
            and #&0F
            tax
            inc L7400,X
            lda (L007E),Y
            and #&F0
            sta L7414,X
            iny
            lda (L007E),Y
            sta L740A,X
            iny
            lda L7414,X
            and #&40
            beq L1C65
            lda #&01
            sta L741E
L1C65:      lda L7414,X
            bmi L1C6D
            jmp L1C43
L1C6D:      rts
L1C6E:      lda #&7F
            jsr OSWRCH
            jsr OSWRCH
            tya
            jmp OSWRCH
L1C7A:      ldx #&2A
            jmp L1C97
L1C7F:      ldx #&00
            ldy #&00
L1C83:      lda L7400,X
            beq L1C89
            iny
L1C89:      inx
            cpx #&0A
            bne L1C83
            dey
            sty L006A
            cpy #&00
            beq L1C7A
            ldx #&2B
L1C97:      jsr L09CF
            ldy #&00
            ldx #&00
L1C9E:      lda L7400,Y
            beq L1CD0
            lda L7414,Y
            and #&10
            beq L1CAF
            dec L006A
            jmp L1CD0
L1CAF:      stx L007D
            tya
            pha
            clc
            adc #&2C
            tax
            jsr L09CF
            ldx L007D
            inx
            cpx L006A
            bne L1CCE
            ldy #&20
            jsr L1C6E
            ldx #&36
            jsr L09CF
            ldx L007D
            inx
L1CCE:      pla
            tay
L1CD0:      iny
            cpy #&0A
            bne L1C9E
            ldy #&2E
            jsr L1C6E
            lda #&20
            jsr OSNEWL
            rts
L1CE0:      lda #&3C
            sta L7508
            lda #&55
            sta L7532
            jmp L1D03
L1CED:      lda L0088
            cmp #&DA
            beq L1D5D
            cmp #&36
            beq L1CE0
            cmp #&94
            bcc L1D03
            cmp #&98
            bcc L1D21
L1CFF:      cmp #&98
            beq L1D08
L1D03:      lda #&00
            sta L007C
            rts
L1D08:      lda #&00
            sta L75B8
            lda L751B
            bne L1D21
            lda L7545
            cmp #&3B
            beq L1D21
            lda #&01
            sta L75B8
            jmp L1D03
L1D21:      lda #&01
            sta L007C
            rts
L1D26:      lda #&01
            sta L7420
            jsr L1FA0
            bne L1D03
            ldx #&28
L1D32:      jsr L09CF
            jmp L1D21
L1D38:      lda #&01
            sta L7420
            jsr L1FA0
            bne L1D03
            ldx #&74
            jmp L1D32
L1D47:      lda L0088
            cmp #&63
            bcc L1D55
            cmp #&6C
            bcc L1D26
            cmp #&83
            bcc L1D38
L1D55:      lda #&00
            sta L7420
            jmp L1D03
L1D5D:      ldx #&87
            lda #&01
            cmp L7513
            beq L1DA7
            cmp L7506
            beq L1DB7
            cmp L74FE
            bne L1DBF
            cmp L7505
            bne L1DC7
            cmp L7509
            bne L1DCF
            cmp L750C
            bne L1DD7
            cmp L750E
            bne L1DDF
            cmp L7514
            bne L1DE7
            cmp L7517
            bne L1DEF
            lda #&00
            cmp L750C
            beq L1DA7
            cmp L7506
            beq L1DB7
            ldx #&92
            jsr L09CF
            ldx #&93
            jsr L0C72
            jmp L1D03
L1DA7:      jsr L09CF
            ldx #&88
L1DAC:      jsr L09CF
            ldx #&91
            jsr L0C72
            jmp L1D21
L1DB7:      jsr L09CF
            ldx #&89
            jmp L1DAC
L1DBF:      jsr L09CF
            ldx #&8C
            jmp L1DAC
L1DC7:      jsr L09CF
            ldx #&8B
            jmp L1DAC
L1DCF:      jsr L09CF
            ldx #&8A
            jmp L1DAC
L1DD7:      jsr L09CF
            ldx #&8D
            jmp L1DAC
L1DDF:      jsr L09CF
            ldx #&90
            jmp L1DAC
L1DE7:      jsr L09CF
            ldx #&8F
            jmp L1DAC
L1DEF:      jsr L09CF
            ldx #&8E
            jmp L1DAC
            nop
            nop
L1DF9:      beq L1DFE
            jmp L1224
L1DFE:      lda L7508
            cmp L0088
            bne L1E11
            lda L7532
            cmp #&55
            bne L1E11
            ldx #&60
            jmp L0C72
L1E11:      ldx #&00
            rts
L1E14:      beq L1E11
            jmp L1224
            jsr L1DF9
            bne L1E21
            jmp L1E7E
L1E21:      rts
            jsr L1E14
            bne L1E21
            inx
            jmp L1E7E
            jsr L1E14
            bne L1E21
            inx
            inx
            jmp L1E7E
L1E35:      jsr L1E14
            bne L1E21
            jmp L1EE1
L1E3D:      ldx #&03
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&04
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&05
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&06
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&07
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&08
            jmp L1E7E
            jsr L1E14
            bne L1E21
            ldx #&09
            jmp L1E7E
L1E7E:      lda L7400,X
            beq L1E94
            lda L7414,X
            and #&40
            beq L1EA2
            lda L741E
            beq L1E99
            ldx #&64
            jmp L0C72
L1E94:      ldx #&73
            jmp L0C72
L1E99:      txa
            pha
            ldx #&66
            jsr L09CF
            pla
            tax
L1EA2:      lda L740A,X
            sta L0088
            inc L7428
            jsr L1C00
            jsr L2137
            jsr L1D47
            lda L007C
            beq L1EBA
            jmp L1728
L1EBA:      lda L0088
            jsr L1CFF
            jsr L1F57
            jsr L1CED
            lda L007C
            beq L1ED3
            lda L0088
            cmp #&98
            bne L1ED0
            rts
L1ED0:      jmp L1728
L1ED3:      lda L0088
            cmp #&DB
            beq L1EDC
            jmp L1F7B
L1EDC:      lda #&01
            sta L007B
            rts
L1EE1:      lda L0088
            cmp #&DA
            beq L1EEA
            jmp L1E3D
L1EEA:      cmp L74FB
            bne L1F2D
            cmp L74FC
            bne L1F2D
            cmp L74FF
            bne L1F2D
            cmp L7501
            bne L1F2D
            cmp L7507
            bne L1F2D
            cmp L750A
            bne L1F2D
            cmp L750D
            bne L1F2D
            cmp L750F
            bne L1F2D
            cmp L7511
            bne L1F2D
            cmp L7512
            bne L1F2D
            txa
            pha
            ldx #&95
            jsr L09CF
            ldx #&93
            jsr L0C72
            pla
            tax
            jmp L1E3D
L1F2D:      ldx #&94
            jsr L09CF
            ldx #&93
            jmp L0C72
            bne L1F3C
            jmp L1231
L1F3C:      cpx #&FF
            bne L1F43
            jmp L0C85
L1F43:      cpx #&2B
            beq L1F4B
            jmp L1224
            nop
L1F4B:      lda L0088
            cmp #&DA
            bne L1F54
            jmp L1E35
L1F54:      jmp L1837
L1F57:      jsr L1FA0
            beq L1F69
            jsr L1F86
            lda L741E
            beq L1F6E
            cmp #&01
            beq L1F73
            rts
L1F69:      ldx #&69
            jmp L09CF
L1F6E:      ldx #&63
            jmp L09CF
L1F73:      ldx #&64
            jmp L09CF
L1F78:      jsr L1F57
L1F7B:      lda L7427
            beq L1F83
            jsr L1C7F
L1F83:      jmp L13A7
L1F86:      lda #&53
            sta L0085
            lda #&00
            sta L0084
            ldx L0088
            lda L7520,X
            tax
            jsr L2131
            lda #&45
            sta L0085
            lda #&00
            sta L0084
            rts
L1FA0:      lda L7420
            beq L1FB9
            lda L7535
            cmp #&3C
            beq L1FBF
            cmp #&3F
            beq L1FBF
            lda L750B
            beq L1FB9
            cmp L0088
            bne L1FBF
L1FB9:      lda #&01
L1FBB:      sta L7427
            rts
L1FBF:      lda #&00
            jmp L1FBB
            ldx #&07
            jsr L0C72
            jsr L200F
            beq L1FD3
L1FCE:      ldx #&08
            jmp L0C72
L1FD3:      ldx #&00
L1FD5:      lda L0088,X
            sta L7429,X
            inx
            cpx #&08
            bne L1FD5
            ldx #&C0
            ldy #&22
            jsr OSCLI
            jmp L0C96
            ldx #&07
            jsr L0C72
            jsr L200F
            beq L1FF6
            jmp L1FCE
L1FF6:      ldx #&D1
            ldy #&22
            jsr OSCLI
            ldx #&00
L1FFF:      lda L7429,X
            sta L0088,X
            inx
            cpx #&08
            bne L1FFF
            jsr L0C96
            jmp L1F78
L200F:      jsr OSRDCH
            cmp #&1B
            beq L2024
            cmp #&59
            bne L201D
            lda #&00
            rts
L201D:      cmp #&4E
            bne L200F
            lda #&01
            rts
L2024:      lda #&7E
            jsr OSBYTE
            jmp L200F
L202C:      ldx #&00
L202E:      lda L7400,X
            sta L3000,X
            lda L7500,X
            sta L3100,X
            dex
            bne L202E
            rts
L203E:      ldx #&2F
            lda #&00
L2042:      sta L0060,X
            dex
            bpl L2042
            lda #&FF
            sta L008E
            lda #&01
            sta L008C
            lda #&34
            sta L0088
            lda #&45
            sta L0084
            rts
L2058:      jsr L203E
            ldx #&00
L205D:      lda L3000,X
            sta L7400,X
            lda L3100,X
            sta L7500,X
            dex
            bne L205D
            jsr L223D
            jsr L1C00
            jmp L1F78
L2075:      jsr L202C
L2078:      lda #&0C
            jsr OSWRCH
            jsr L2058
L2080:      jsr L16BE
            lda L0089
            cmp #&09
            beq L20C7
            lda L7422
            bne L2095
            lda L007B
            bne L209E
            jmp L2080
L2095:      jsr L218C
L2098:      jsr L20A6
            jmp L2078
L209E:      ldx #&A0
            jsr L0C72
            jmp L2098
L20A6:      lda #&85
            sta L0922
            ldx #&96
            jsr L2131
            jsr L20CA
L20B3:      jsr OSRDCH
            cmp #&1B
            beq L20BF
            cmp #&0D
            bne L20B3
            rts
L20BF:      lda #&7E
            jsr OSBYTE
            jmp L20B3
L20C7:      jmp L2078
L20CA:      lda #&86
            sta L0922
            rts
L20D0:      lda L0088
            cmp #&D6
            beq L20D7
            rts
L20D7:      lda L7504
            cmp #&D6
            beq L20F1
            cmp #&03
            beq L20F1
            ldx #&97
            jsr L09CF
            ldx #&98
L20E9:      jsr L09CF
            ldx #&9B
            jmp L0C72
L20F1:      lda L7516
            cmp #&D6
            beq L2106
            cmp #&03
            beq L2106
            ldx #&97
            jsr L09CF
            ldx #&99
            jmp L20E9
L2106:      lda L74FA
            cmp #&D6
            beq L211B
            cmp #&03
            beq L211B
            ldx #&97
            jsr L09CF
            ldx #&9A
            jmp L20E9
L211B:      lda L750E
            cmp #&FF
            beq L2127
            ldx #&9C
            jmp L0C72
L2127:      lda #&D6
            sta L750E
            ldx #&9E
            jmp L0C72
L2131:      jsr L09CF
            jmp OSNEWL
L2137:      lda L0088
            cmp #&36
            beq L214A
            cmp #&3D
            beq L217E
            cmp #&6C
            beq L2162
            cmp #&9A
            beq L2170
            rts
L214A:      lda L7432
            bne L2157
            jsr L2158
            lda #&01
            sta L7432
L2157:      rts
L2158:      lda L7431
            clc
            adc #&0A
            sta L7431
            rts
L2162:      lda L7434
            bne L2157
            jsr L2158
            lda #&01
            sta L7434
            rts
L2170:      lda L7435
            bne L2157
            jsr L2158
            lda #&01
            sta L7435
            rts
L217E:      lda L7433
            bne L2157
            jsr L2158
            lda #&01
            sta L7433
            rts
L218C:      ldy #&00
            lda #&DA
            cmp L74FB
            bne L2196
            iny
L2196:      cmp L74FC
            bne L219C
            iny
L219C:      cmp L74FF
            bne L21A2
            iny
L21A2:      cmp L7501
            bne L21A8
            iny
L21A8:      cmp L7507
            bne L21AE
            iny
L21AE:      cmp L750A
            bne L21B4
            iny
L21B4:      cmp L750D
            bne L21BA
            iny
L21BA:      cmp L750F
            bne L21C0
            iny
L21C0:      cmp L7511
            bne L21C6
            iny
L21C6:      cmp L7512
            bne L21CC
            iny
L21CC:      lda #&01
            cmp L74FE
            bne L21D4
            iny
L21D4:      cmp L7505
            bne L21DA
            iny
L21DA:      cmp L7509
            bne L21E0
            iny
L21E0:      cmp L750C
            bne L21E6
            iny
L21E6:      cmp L750E
            bne L21EC
            iny
L21EC:      cmp L7514
            bne L21F2
            iny
L21F2:      cmp L7517
            bne L21F8
            iny
L21F8:      lda L74FA
            cmp #&03
            beq L2203
            cmp #&D6
            bne L2204
L2203:      iny
L2204:      lda L7504
            cmp #&03
            beq L220F
            cmp #&D6
            bne L2210
L220F:      iny
L2210:      lda L7516
            cmp #&03
            beq L221B
            cmp #&D6
            bne L221C
L221B:      iny
L221C:      lda L751C
            cmp #&27
            bne L2224
            iny
L2224:      lda #&00
            sta L008D
L2228:      lda L008D
            clc
            adc #&0A
            sta L008D
            dey
            bne L2228
            lda L7431
            clc
            adc L008D
            sta L008D
            jmp L141C
L223D:      lda #&45
            sta L0085
            lda #&00
            sta L0084
            lda #&83
            sta L0922
            ldx #&06
            jsr L0C72
            lda #&0F
            jsr OSWRCH
            jmp L20CA
            ldx #&40
            jmp L0C72
            rts
EXECADDR:   lda #&16
            jsr OSWRCH
            lda #&07
            jsr OSWRCH
            lda #&0F
            jsr OSWRCH
            lda #&8B
            ldx #&01
            ldy #&00
            sty L0068
            jsr OSBYTE
            lda #&43
            sta L0085
            lda #&00
            sta L0084
            tax
            lda #&0C
            jsr OSWRCH
L2285:      txa
            pha
            jsr L2131
            pla
            tax
            inx
            cpx #&06
            bne L2285
            stx L20AC
            jsr OSNEWL
            lda #&89
            sta L006B
            jsr L20A6
            ldx #&96
            stx L20AC
            lda #&45
            sta L0085
            jmp L2075
            ldx #&00
L22AC:      lda #&10
            sta L0B00,X
            lda #&00
            sta L0900,X
            sta L0A00,X
            sta L0C00,X
            dex
            bne L22AC
            rts
            .byte &53
            rol L4120
            .byte &44
            lsr L0020,X
            .byte &37,&34
            bmi L22FB
            jsr L3637
            bmi L2300
            ora L2E4C
            jsr L4441
            lsr L000D,X
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00
L22FB:      .byte &00,&00,&00,&00,&00
L2300:      .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
L2E4C:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
L2E5A:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&FF,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
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
L3000:      .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
L3100:      .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &FF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00
L3637:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&FF,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&FF,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&FF,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&FF,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
L3A43:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00
L3A59:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&0F,&76,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00
L4120:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00
L4144:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&FF,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&22,&23,&8A,&4A
            .byte &12,&9F,&10,&8F,&C1,&20,&5C,&20
            .byte &A8,&A9,&4B,&20,&5C,&27,&52,&9D
            .byte &C1,&99,&3F,&45,&48,&3F,&BE,&4D
            .byte &9D,&B3,&21,&AC,&FC,&45,&A3,&F2
            .byte &22,&2C,&0F,&B5,&54,&A4,&89,&23
            .byte &4B,&99,&20,&7B,&23,&58,&41,&AC
            .byte &2C,&AC,&E1,&E7,&59,&2E,&0D,&22
            .byte &23,&93,&2E,&2E,&2E,&93,&22,&2C
            .byte &5C,&20,&43,&52,&59,&2C,&46,&0B
            .byte &DA,&59,&2C,&8A,&47,&41,&5A,&9D
            .byte &19,&20,&8F,&89,&23,&4B,&99,&2E
            .byte &0D,&22,&23,&53,&B1,&C7,&99,&20
            .byte &4D,&A2,&93,&2C,&57,&AA,&9D,&5C
            .byte &2C,&C1,&47,&21,&5C,&20,&4B,&EE
            .byte &A6,&10,&8F,&23,&A5,&C1,&20,&76
            .byte &A8,&49,&0C,&B7,&2C,&C1,&98,&5C
            .byte &3F,&A5,&DD,&F1,&20,&8B,&A7,&7A
            .byte &4D,&A2,&4B,&45,&04,&20,&C8,&A3
            .byte &A1,&57,&BB,&C3,&22,&2C,&CB,&55
            .byte &DE,&A4,&89,&23,&4B,&99,&2C,&0C
            .byte &49,&D7,&59,&2E,&0D,&22,&23,&ED
            .byte &A6,&4C,&B3,&47,&20,&A1,&57,&BB
            .byte &C3,&3F,&49,&27,&A7,&56,&AA,&A2
            .byte &A8,&02,&B8,&59,&22,&2C,&5C,&20
            .byte &43,&DF,&FF,&2C,&54,&B5,&D3,&99
            .byte &20,&5C,&A3,&43,&C0,&F1,&45,&A0
            .byte &D4,&50,&53,&2E,&0D,&22,&23,&49
            .byte &27,&A7,&EE,&9F,&53,&55,&AB,&22
            .byte &2C,&AB,&50,&D4,&45,&A4,&89,&23
            .byte &4B,&99,&2C,&22,&23,&D2,&B0,&4C
            .byte &20,&5C,&20,&DF,&54,&2C,&D8,&4F
            .byte &42,&41,&DA,&59,&22,&2C,&8A,&48
            .byte &9D,&B9,&44,&AA,&A4,&C8,&A3,&5C
            .byte &20,&76,&42,&9D,&D1,&53,&9F,&A9
            .byte &76,&D8,&C9,&B3,&21,&0D,&23,&03
            .byte &20,&08,&47,&7A,&5C,&A3,&7F,&A4
            .byte &7E,&89,&23,&C9,&4C,&8A,&7B,&23
            .byte &58,&41,&AC,&2E,&2E,&2E,&0D,&2B
            .byte &23,&50,&AB,&53,&53,&3C,&26,&AB
            .byte &54,&55,&52,&4E,&26
L4441:      .byte &3C,&76,&B8,&AE,&54,&2E,&2B,&0D
            .byte &9E,&A9,&76,&D8,&C9,&B3,&21,&0D
            .byte &23,&03,&20,&08,&47,&7A,&5C,&A3
            .byte &7F,&A4,&7E,&89,&23,&C9,&4C,&8A
            .byte &7B,&23,&58,&41,&AC,&2E,&2E,&2E
            .byte &0D,&2B,&23,&50,&AB,&53,&53,&3C
            .byte &26,&AB,&54,&55,&52,&4E,&26,&3C
            .byte &76,&B8,&AE,&54,&2E,&2B,&0D,&02
            .byte &D1,&83,&CF,&02,&D2,&83,&D0,&00
            .byte &D3,&83,&D1,&01,&D2,&84,&D4,&01
            .byte &D3,&82,&86,&08,&92,&89,&83,&E2
            .byte &C1,&02,&88,&85,&D8,&02,&D7,&85
            .byte &D9,&02,&D8,&83,&DA,&02,&D9,&83
            .byte &DB,&82,&DA,&10,&98,&01,&66,&02
            .byte &59,&03,&58,&06,&67,&87,&65,&02
            .byte &DE,&88,&82,&00,&8A,&02,&4F,&03
            .byte &DD,&04,&8B,&85,&53,&08,&94,&89
            .byte &CF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&23
            .byte &A5,&C1,&98,&55,&C4,&AA,&B8,&8A
            .byte &0D,&4F,&A3,&0D,&ED,&A6,&76,&22
            .byte &24,&22,&20,&0D,&10,&8F,&22,&25
            .byte &22,&20,&F2,&AC,&53,&2E,&0D,&3D
            .byte &23,&5C,&20,&1E,&12,&9D,&C8,&A3
            .byte &A1,&57,&BB,&C3,&2E,&2E,&2E,&2E
            .byte &3D,&0D,&23,&4F,&4B,&1F,&0D,&2B
            .byte &23,&57,&CD,&BE,&4D,&9D,&C2,&2B
            .byte &2B,&22,&23,&C9,&4C,&8A,&7B,&23
            .byte &58,&41,&AC,&22,&2B,&2B,&23,&42
            .byte &59,&3A,&23,&DF,&42,&AA,&9F,&23
            .byte &4F,&27,&23,&C3,&AE,&59,&2B,&2B
            .byte &23,&80,&2B,&0D,&23,&AE,&9D,&5C
            .byte &20,&53,&55,&52,&9D,&5C,&20,&57
            .byte &AC,&9F,&76,&24,&3F,&0D,&23,&A5
            .byte &A8,&B5,&9A,&20,&5C,&20,&57,&AA
            .byte &9D,&8E,&4B,&49,&44,&44,&99,&21
            .byte &0D,&23,&42,&59,&45,&21,&0D,&23
            .byte &A5,&D1,&98,&47,&55,&B7,&A4,&10
            .byte &8F,&5C,&20,&57,&AC,&9F,&76,&24
            .byte &21,&0D,&23,&A9,&56,&AF,&54,&B9
            .byte &59,&3A,&2B,&20,&2B,&23,&5B,&43
            .byte &AE,&52,&59,&99,&20,&0D,&8A,&05
            .byte &AE,&99,&20,&0D,&EE,&A8,&99,&20
            .byte &0D,&23,&5C,&20,&D1,&98,&71,&20
            .byte &0D,&23,&5B,&C7,&AB,&FD,&A2,&0D
            .byte &23,&5B,&EE,&9F,&0D,&23,&5C,&20
            .byte &D1,&98,&C1,&20,&A8,&B2,&21,&0D
            .byte &89,&25,&21,&0D,&23,&6D,&A1,&46
            .byte &A9,&C7,&2C,&C7,&01,&9A,&A2,&54
            .byte &55,&47,&2C,&89,&25,&20,&49,&A4
            .byte &46,&AB,&E0,&21,&0D,&23,&49,&9F
            .byte &B8,&AE,&54,&A4,&76,&DD,&4F,&53
            .byte &AF,&2E,&0D,&23,&89,&25,&20,&71
            .byte &4D,&A4,&49,&4D,&00,&56,&41,&42
            .byte &C3,&21,&0D,&23,&5C,&A3,&48,&8C
            .byte &A4,&AE,&9D,&46,&55,&D7,&21,&0D
            .byte &23,&A1,&D5,&44,&A2,&D1,&9E,&8E
            .byte &CC,&4B,&9D,&03,&20,&4D,&55,&D3
            .byte &2C,&5C,&20,&4B,&EE,&57,&21,&0D
            .byte &AC,&59,&A8,&99,&21,&0D,&23,&4A
            .byte &12,&9F,&91,&20,&A1,&CF,&AB,&43
            .byte &54,&9C,&2E,&0D,&ED,&4C,&44,&99
            .byte &20,&0D,&05,&AE,&99,&20,&0D,&23
            .byte &89,&25,&20,&49,&A4,&49,&4D,&00
            .byte &56,&41,&42,&C3,&21,&0D,&23,&EE
            .byte &A8,&99,&20,&B4,&EB,&AF,&53,&2E
            .byte &0D,&23,&5C,&20,&D1,&9E,&71,&20
            .byte &0D,&23,&89,&25,&20,&49,&A4,&EE
            .byte &A8,&99,&20,&53,&EA,&43,&49,&C7
            .byte &2E,&0D,&23,&5C,&20,&C1,&98,&DB
            .byte &53,&53,&B7,&A4,&B6,&21,&0D,&23
            .byte &5C,&20,&CA,&45,&A0,&A1,&53,&ED
            .byte &BD,&4C,&20,&76,&24,&21,&0D,&23
            .byte &89,&94,&49,&A4,&C2,&4F,&20,&48
            .byte &AE,&A0,&76,&24,&2E,&0D,&23,&5C
            .byte &20,&D1,&98,&24,&20,&48,&AA,&45
            .byte &2E,&0D,&23,&89,&46,&AB,&45,&5A
            .byte &99,&20,&BE,&4C,&A0,&43,&88,&A4
            .byte &5C,&20,&76,&89,&42,&B3,&45,&21
            .byte &0D,&22,&23,&49,&27,&A7,&D0,&F1
            .byte &20,&7B,&A8,&49,&A4,&7F,&22,&2C
            .byte &5C,&20,&53,&43,&AB,&D6,&2C,&8A
            .byte &7A,&A1,&53,&55,&49,&43,&49,&44
            .byte &C7,&20,&46,&AB,&4E,&5A,&59,&2C
            .byte &24,&20,&6E,&89,&50,&A9,&E3,&43
            .byte &C3,&2C,&76,&42,&9D,&50,&55,&4C
            .byte &EA,&A0,&42,&A2,&89,&C0,&EC,&44
            .byte &4C,&A2,&41,&50,&D8,&4F,&41,&D3
            .byte &99,&20,&94,&A1,&46,&45,&A6,&4D
            .byte &E5,&AF,&54,&A4,&4C,&B2,&AA,&21
            .byte &0D,&23,&89,&A9,&B1,&E8,&AA,&B2
            .byte &9D,&43,&D4,&4D,&B2,&9D,&B4,&A4
            .byte &08,&BE,&4D,&9D,&C2,&4F,&20,&4D
            .byte &55,&D3,&20,&C8,&A3,&5C,&A3,&05
            .byte &AE,&A2,&D5,&44,&59,&2E,&0D,&23
            .byte &5C,&20,&71,&A7,&76,&B4,&56,&9D
            .byte &22,&BF,&50,&AE,&B1,&44,&22,&20
            .byte &8A,&47,&B3,&9D,&76,&89,&47,&AB
            .byte &B2,&2C,&42,&18,&20,&7F,&20,&7A
            .byte &89,&53,&4B,&59,&21,&0D,&23,&5C
            .byte &20,&57,&AA,&9D,&BF,&56,&B5,&AB
            .byte &A0,&42,&A2,&A1,&C0,&8B,&A3,&56
            .byte &49,&43,&49,&9B,&20,&ED,&47,&20
            .byte &7A,&89,&74,&21,&0D,&23,&5C,&20
            .byte &08,&47,&7A,&76,&24,&20,&89,&53
            .byte &AD,&45,&A3,&46,&F6,&45,&2C,&53
            .byte &D4,&50,&20,&8A,&46,&C7,&4C,&2E
            .byte &41,&A4,&5C,&20,&14,&D9,&F2,&54
            .byte &2C,&5C,&20,&53,&43,&AB,&D6,&21
            .byte &8B,&9E,&8B,&52,&9D,&49,&A4,&D0
            .byte &4C,&AF,&43,&45,&21,&0D,&23,&89
            .byte &8E,&56,&C9,&49,&DA,&9D,&65,&20
            .byte &49,&A4,&0D,&23,&8B,&52,&9D,&AE
            .byte &9D,&56,&C9,&49,&DA,&9D,&65,&A4
            .byte &0D,&5D,&2C,&0D,&5E,&2C,&0D,&5F
            .byte &2C,&0D,&60,&2C,&0D,&5D,&5F,&2C
            .byte &0D,&5D,&60,&2C,&0D,&5E,&5F,&2C
            .byte &0D,&5E,&60,&2C,&0D,&19,&2C,&0D
            .byte &67,&2C,&0D,&8A,&0D,&23,&5C,&20
            .byte &24,&20,&8A,&14,&D2,&47,&9D,&4F
            .byte &46,&46,&20,&89,&7C,&2E,&89,&C6
            .byte &A1,&57,&0A,&AD,&A4,&4F,&BD,&A3
            .byte &5C,&A3,&0F,&B2,&54,&AA,&45,&A0
            .byte &E9,&4C,&4B,&2E,&0D,&23,&5C,&20
            .byte &24,&20,&89,&54,&AB,&45,&2C,&C1
            .byte &20,&5C,&A3,&46,&D6,&9B,&20,&41
            .byte &EA,&C5,&9E,&49,&E8,&AA,&53,&B3
            .byte &B2,&9C,&2C,&8A,&24,&20,&67,&20
            .byte &41,&47,&41,&A9,&2E,&57,&13,&21
            .byte &5C,&27,&52,&9D,&03,&20,&C5,&44
            .byte &D1,&50,&21,&0D,&2B,&23,&4D,&B7
            .byte &EF,&DC,&3A,&2B,&3D,&23,&B8,&4F
            .byte &50,&20,&B6,&21,&4C,&BC,&56,&9D
            .byte &4D,&9D,&C7,&B3,&45,&21,&49,&27
            .byte &A7,&7E,&A8,&49,&A4,&50,&CB,&7A
            .byte &08,&99,&20,&53,&55,&52,&AB,&C7
            .byte &C9,&9F,&8F,&89,&4D,&E5,&AF,&54
            .byte &2C,&49,&46,&20,&5C,&20,&C1,&98
            .byte &4D,&A9,&44,&21,&3D,&0D,&23,&89
            .byte &B8,&55,&52,&44,&A2,&25,&20,&49
            .byte &A4,&68,&2E,&0D,&23,&89,&B8,&55
            .byte &52,&44,&A2,&25,&20,&49,&A4,&69
            .byte &44,&2E,&0D,&23,&89,&CB,&E8,&20
            .byte &49,&A4,&4F,&46,&46,&2E,&0D,&23
            .byte &89,&CB,&E8,&20,&1B,&52,&4E,&A4
            .byte &6D,&A1,&16,&5A,&5A,&4C,&99,&20
            .byte &A9,&54,&AF,&53,&B6,&59,&2E,&0D
            .byte &23,&89,&CB,&E8,&20,&49,&A4,&46
            .byte &FD,&99,&2E,&0D,&23,&89,&CB,&E8
            .byte &20,&CA,&E0,&A4,&4F,&E7,&2E,&0D
            .byte &23,&57,&52,&B6,&9D,&76,&23,&C7
            .byte &49,&43,&45,&21,&0D,&23,&89,&25
            .byte &20,&49,&A4,&C5,&44,&9D,&6E,&A1
            .byte &D4,&9A,&2C,&50,&AB,&43,&49,&9B
            .byte &20,&C7,&DD,&A2,&8A,&08,&AE,&A4
            .byte &89,&E6,&42,&C3,&A7,&7B,&89,&23
            .byte &4B,&B2,&DF,&A4,&44,&59,&E3,&B8
            .byte &59,&2E,&0D,&23,&89,&43,&DD,&FF
            .byte &20,&49,&A4,&57,&AE,&4D,&2C,&6D
            .byte &4D,&AC,&A2,&DB,&F1,&45,&54,&53
            .byte &2E,&0D,&23,&B8,&4F,&50,&20,&50
            .byte &CB,&59,&99,&20,&6D,&5C,&A3,&25
            .byte &21,&B6,&27,&A4,&42,&41,&A0,&4D
            .byte &AC,&4E,&AA,&53,&21,&0D,&23,&89
            .byte &25,&20,&49,&A4,&46,&0A,&48,&9C
            .byte &45,&A0,&6E,&02,&B3,&2C,&B6,&A4
            .byte &AD,&41,&56,&A2,&4C,&A9,&4B,&A4
            .byte &AF,&43,&52,&12,&B1,&A0,&6D,&52
            .byte &12,&9F,&6E,&41,&DC,&A4,&1E,&B8
            .byte &2E,&0D,&23,&A8,&49,&A4,&49,&A4
            .byte &CB,&E8,&20,&25,&2E,&0D,&23,&89
            .byte &25,&20,&AE,&9D,&A1,&4C,&D9,&A9
            .byte &9B,&20,&50,&A9,&4B,&20,&BE,&4C
            .byte &B5,&52,&2C,&8A,&4B,&4E,&B6,&B1
            .byte &A0,&B5,&9F,&7B,&A1,&48,&B9,&52
            .byte &49,&42,&C3,&2C,&C5,&9E,&C5,&44
            .byte &9D,&46,&49,&1C,&9D,&28,&41,&A4
            .byte &4F,&50,&DB,&C6,&A0,&76,&50,&A9
            .byte &45,&2C,&4F,&A3,&53,&E5,&45,&A8
            .byte &99,&29,&2E,&0D,&23,&8B,&53,&9D
            .byte &AE,&9D,&74,&20,&25,&2E,&0D,&23
            .byte &89,&25,&20,&49,&A4,&A1,&47,&C0
            .byte &56,&9D,&CF,&47,&47,&AA,&27,&53
            .byte &2E,&0D,&23,&4D,&4D,&4D,&21,&8B
            .byte &53,&9D,&57,&AA,&9D,&54,&AB,&C4
            .byte &A2,&7A,&31,&39,&37,&31,&2C,&57
            .byte &AA,&45,&98,&8B,&59,&3F,&14,&B2
            .byte &46,&B9,&4D,&53,&2C,&8A,&C7,&4C
            .byte &20,&A8,&B2,&3F,&0D,&23,&89,&68
            .byte &20,&D9,&42,&AB,&D7,&A1,&43,&B2
            .byte &43,&AD,&A4,&7A,&89,&90,&20,&8A
            .byte &DA,&13,&A4,&87,&2E,&0D,&A1,&0D
            .byte &41,&9E,&0D,&53,&E5,&9D,&0D,&A1
            .byte &50,&F4,&A3,&7B,&0D,&2C,&0D,&23
            .byte &89,&25,&20,&CA,&E0,&4C,&9D,&71
            .byte &4D,&A4,&76,&42,&9D,&B8,&55,&F1
            .byte &2E,&0D,&23,&89,&25,&20,&47,&DD
            .byte &57,&A4,&6D,&A1,&62,&9D,&41,&55
            .byte &C0,&21,&89,&CA,&E0,&4C,&9D,&DB
            .byte &A9,&54,&A4,&0D,&23,&5C,&20,&46
            .byte &A9,&A0,&0D,&23,&10,&AA,&45,&3F
            .byte &0D,&23,&A5,&D1,&98,&47,&55,&B7
            .byte &53,&21,&0D,&23,&89,&61,&49,&A4
            .byte &AC,&E1,&A2,&8F,&08,&99,&20,&CF
            .byte &B8,&55,&52,&42,&E0,&2E,&0D,&23
            .byte &89,&61,&49,&A4,&44,&BC,&44,&2E
            .byte &0D,&23,&89,&61,&49,&A4,&0A,&C3
            .byte &04,&2E,&0D,&23,&89,&61,&AD,&AE
            .byte &A4,&89,&25,&20,&8A,&46,&C7,&4C
            .byte &A4,&BF,&45,&EA,&A3,&A9,&76,&BB
            .byte &A4,&44,&AB,&D6,&53,&2E,&0D,&23
            .byte &89,&61,&57,&FF,&B7,&2C,&71,&A4
            .byte &5C,&20,&8A,&7A,&41,&9E,&A9,&B8
            .byte &AC,&54,&2C,&B4,&A4,&44,&C0,&57
            .byte &9E,&BB,&A4,&01,&9A,&A2,&FC,&B9
            .byte &44,&2E,&6D,&A1,&53,&99,&C3,&2C
            .byte &46,&CB,&0F,&99,&20,&DA,&13,&2C
            .byte &89,&C0,&5A,&B9,&2D,&E0,&47,&9D
            .byte &7B,&89,&57,&BC,&50,&7E,&53,&D4
            .byte &43,&45,&A4,&A8,&52,&B5,&DE,&20
            .byte &5C,&A3,&CA,&F1,&2C,&8A,&5C,&A3
            .byte &AD,&41,&A0,&DF,&D7,&53,&2C,&D4
            .byte &46,&45,&82,&4C,&59,&2C,&C7,&B3
            .byte &47,&20,&89,&46,&DD,&B9,&2E,&0D
            .byte &23,&89,&61,&0F,&B5,&54,&A4,&8F
            .byte &5C,&20,&C8,&A3,&CF,&B8,&55,&52
            .byte &42,&99,&20,&BB,&A7,&8A,&4C,&BC
            .byte &56,&B7,&2C,&43,&DD,&53,&99,&20
            .byte &89,&C1,&4F,&A3,&08,&48,&A9,&A0
            .byte &BB,&4D,&2E,&0D,&23,&A5,&C1,&98
            .byte &4B,&EE,&A6,&B6,&2E,&43,&B5,&4C
            .byte &A0,&5C,&20,&E9,&A7,&49,&9F,&C8
            .byte &A3,&F2,&3F,&0D,&23,&5C,&20,&53
            .byte &99,&20,&89,&CB,&B1,&53,&9F,&4E
            .byte &D9,&08,&A3,&42,&A2,&89,&46,&D6
            .byte &9B,&20,&AD,&41,&56,&A2,&F2,&54
            .byte &C7,&20,&E1,&B5,&50,&2C,&23,&55
            .byte &52,&AC,&49,&55,&A7,&23,&A8,&55
            .byte &C4,&AA,&D5,&4C,&54,&2C,&56,&AA
            .byte &A2,&4C,&B5,&44,&4C,&59,&2E,&0D
            .byte &23,&5C,&20,&53,&99,&20,&A1,&42
            .byte &BC,&55,&B0,&46,&55,&4C,&20,&4C
            .byte &55,&4C,&CB,&42,&A2,&41,&42,&B5
            .byte &9F,&53,&4B,&49,&EB,&99,&20,&A8
            .byte &52,&B5,&DE,&20,&A1,&4D,&BC,&C1
            .byte &57,&2C,&47,&41,&8B,&52,&99,&20
            .byte &46,&DD,&57,&AA,&53,&2E,&89,&57
            .byte &B9,&4C,&A0,&71,&4D,&A4,&A1,&08
            .byte &54,&B1,&A3,&50,&CB,&43,&45,&2E
            .byte &0D,&23,&5C,&20,&E1,&49,&50,&20
            .byte &89,&43,&B4,&7A,&B0,&9A,&4C,&A2
            .byte &8A,&B8,&AE,&9F,&76,&54,&57,&C9
            .byte &9F,&49,&9F,&AE,&B5,&4E,&A0
L4C50:      .byte &89,&47,&55,&AE,&44,&27,&A4,&CA
            .byte &F1,&2E,&41,&A4,&89,&CB,&53,&9F
            .byte &42,&AB,&41,&A8,&20,&7B,&D4,&46
            .byte &9D,&49,&A4,&53,&F0,&0B,&5A,&45
            .byte &A0,&6E,&BB,&A4,&D5,&44,&59,&2C
            .byte &48,&9D,&FE,&D9,&50,&A4,&76,&89
            .byte &46,&DD,&B9,&2E,&0D,&23,&5C,&20
            .byte &CA,&45,&A0,&A1,&57,&BC,&50,&B3
            .byte &2E,&0D,&23,&89,&61,&DA,&4F,&F1
            .byte &A4,&5C,&A3,&57,&1F,&2E,&0D,&23
            .byte &89,&AC,&43,&49,&AF,&9F,&43,&B4
            .byte &7A,&44,&C9,&03,&4C,&BD,&A4,&A9
            .byte &76,&A1,&50,&E7,&9D,&7B,&17,&B8
            .byte &2C,&57,&BB,&D3,&20,&4D,&99,&C3
            .byte &A4,&6D,&89,&53,&55,&52,&52,&B5
            .byte &C4,&99,&20,&CF,&52,&9F,&8A,&49
            .byte &A4,&DD,&53,&9F,&C8,&AB,&56,&AA
            .byte &21,&0D,&23,&A1,&61,&68,&A4,&89
            .byte &C1,&4F,&A3,&8A,&AF,&54,&AA,&A4
            .byte &89,&6A,&2E,&0D,&23,&89,&C1,&4F
            .byte &A3,&49,&A4,&68,&2E,&0D,&23,&89
            .byte &C1,&4F,&A3,&49,&A4,&69,&44,&2E
            .byte &0D,&23,&89,&C1,&4F,&A3,&49,&A4
            .byte &6B,&2E,&0D,&23,&89,&C1,&4F,&A3
            .byte &53,&CB,&4D,&A4,&53,&E9,&9F,&08
            .byte &48,&A9,&A0,&5C,&21,&0D,&23,&5C
            .byte &20,&24,&20,&89,&25,&2E,&0D,&23
            .byte &89,&25,&20,&49,&A4,&B5,&9F,&7B
            .byte &AB,&41,&D3,&21,&0D,&23,&49,&9F
            .byte &49,&A4,&50,&B6,&D3,&20,&74,&2E
            .byte &0D,&23,&89,&25,&20,&AE,&9D,&E6
            .byte &42,&DF,&49,&44,&AA,&45,&A0,&6D
            .byte &89,&AE,&4D,&A4,&7B,&23,&4B,&B2
            .byte &DF,&53,&2E,&0D,&23,&89,&25,&20
            .byte &57,&41,&A4,&C5,&44,&9D,&7A,&23
            .byte &B1,&58,&0A,&21,&0D,&23,&4A,&12
            .byte &9F,&5C,&A3,&D0,&5A,&45,&21,&0D
            .byte &23,&89,&25,&20,&49,&A4,&52,&B5
            .byte &DE,&2C,&C0,&47,&DC,&A0,&8A,&46
            .byte &E7,&A8,&A2,&6D,&D8,&C9,&7E,&CF
            .byte &52,&54,&2E,&0D,&23,&8B,&9E,&5C
            .byte &20,&B8,&D6,&50,&20,&89,&BF,&1C
            .byte &49,&A4,&B5,&9F,&7B,&F9,&49,&B8
            .byte &AF,&43,&45,&21,&0D,&23,&89,&25
            .byte &20,&49,&A4,&53,&C5,&D7,&2E,&41
            .byte &9E,&A9,&53,&43,&52,&49,&50,&B0
            .byte &7E,&AB,&FD,&53,&3A,&22,&23,&A8
            .byte &49,&A4,&25,&20,&B4,&A4,&A1,&C5
            .byte &58,&49,&4D,&55,&A7,&93,&20,&D1
            .byte &50,&F6,&B6,&A2,&7B,&34,&35,&2E
            .byte &34,&36,&20,&4C,&B6,&AB,&53,&22
            .byte &2E,&0D,&23,&5C,&20,&CA,&45,&A0
            .byte &93,&2E,&0D,&23,&46,&49,&D7,&20
            .byte &A1,&43,&B3,&CC,&A9,&AA,&2E,&0D
            .byte &23,&89,&48,&8F,&49,&A4,&46,&55
            .byte &D7,&21,&0D,&23,&5C,&20,&D1,&98
            .byte &F5,&20,&24,&2E,&0D,&23,&B5,&D3
            .byte &21,&5C,&20,&57,&C7,&4B,&45,&A0
            .byte &A9,&76,&A1,&DB,&A9,&B1,&A0,&B8
            .byte &C7,&F6,&B0,&54,&9D,&7A,&89,&74
            .byte &21,&0D,&27,&23,&AA,&45,&2C,&B8
            .byte &4F,&50,&20,&DB,&4B,&99,&20,&F2
            .byte &2C,&5C,&20,&43,&AD,&45,&4B,&A2
            .byte &25,&21,&0D,&23,&B6,&27,&A4,&A1
            .byte &1A,&9F,&00,&A8,&2D,&45,&B2,&AF
            .byte &21,&0D,&23,&89,&25,&20,&49,&A4
            .byte &AF,&43,&52,&12,&B1,&A0,&6D,&17
            .byte &1A,&B7,&21,&0D,&23,&89,&25,&20
            .byte &49,&A4,&43,&C0,&46,&B1,&A0,&6E
            .byte &DB,&4C,&C9,&AD,&A0,&D0,&4C,&56
            .byte &AA,&21,&0D,&23,&A8,&49,&A4,&25
            .byte &20,&DD,&4F,&4B,&A4,&D4,&4B,&9D
            .byte &54,&AB,&0A,&55,&AB,&21,&0D,&23
            .byte &89,&25,&20,&52,&B2,&54,&C3,&A4
            .byte &57,&AD,&9E,&5C,&20,&53,&B4,&4B
            .byte &9D,&B6,&2E,&0D,&23,&89,&25,&20
            .byte &49,&A4,&46,&0A,&48,&9C,&45,&A0
            .byte &6E,&43,&4C,&BC,&A3,&43,&52,&59
            .byte &B8,&C7,&21,&0D,&23,&89,&25,&20
            .byte &49,&A4,&C5,&44,&9D,&7B,&32,&32
            .byte &20,&43,&AE,&8F,&F5,&4C,&44,&21
            .byte &0D,&23,&8B,&A2,&AE,&9D,&C0,&47
            .byte &DC,&44,&2C,&1B,&9F,&43,&C3,&AC
            .byte &2E,&0D,&23,&89,&25,&20,&49,&A4
            .byte &B8,&52,&D2,&47,&20,&6D,&0F,&A9
            .byte &99,&20,&EA,&AE,&4C,&53,&21,&0D
            .byte &23,&89,&25,&20,&B4,&A4,&A1,&4C
            .byte &AE,&47,&9D,&EF,&EB,&BB,&AB,&21
            .byte &0D,&23,&B6,&27,&A4,&A1,&23,&50
            .byte &AA,&D0,&41,&9E,&25,&21,&0D,&23
            .byte &4D,&4D,&4D,&21,&C1,&98,&5C,&20
            .byte &4A,&12,&9F,&DD,&56,&9D,&81,&46
            .byte &AB,&0F,&2C,&43,&AE,&D5,&D4,&43
            .byte &20,&AE,&4F,&C5,&3F,&0D,&23,&5C
            .byte &20,&24,&20,&4C,&B3,&47,&20,&8A
            .byte &BF,&04,&2C,&8A,&55,&CA,&AE
L4F4F:      .byte &A8,&20,&A1,&57,&49,&8B,&AB,&A0
            .byte &43,&B9,&50,&C6,&2C,&57,&BB,&D3
            .byte &20,&44,&C9,&03,&4C,&BD,&A4,&A9
            .byte &76,&A1,&50,&E7,&9D,&7B,&44,&12
            .byte &9F,&8A,&49,&A4,&53,&43,&B2,&54
            .byte &AA,&45,&A0,&42,&A2,&89,&46,&B5
            .byte &A3,&90,&53,&21,&0D,&23,&89,&53
            .byte &8A,&49,&A4,&0E,&A2,&8A,&89,&ED
            .byte &4C,&9D,&F0,&49,&F1,&4C,&A2,&46
            .byte &49,&D7,&A4,&A9,&2E,&0D,&23,&89
            .byte &44,&D6,&50,&20,&53,&8A,&49,&A4
            .byte &46,&02,&A7,&8A,&5C,&20,&24,&20
            .byte &A1,&4C,&AE,&47,&9D,&50,&B6,&2E
            .byte &0D,&23,&6D,&89,&74,&20,&47,&CB
            .byte &53,&C6,&A4,&B3,&2C,&89,&4D,&C9
            .byte &9F,&C2,&54,&C7,&4C,&A2,&4F,&42
            .byte &53,&43,&55,&AB,&A4,&5C,&A3,&56
            .byte &C9,&9C,&2E,&5C,&20,&07,&49,&50
            .byte &20,&8A,&AE,&9D,&43,&B3,&43,&12
            .byte &C6,&A0,&41,&A4,&5C,&20,&BB,&9F
            .byte &89,&46,&DD,&B9,&2E,&57,&AD,&9E
            .byte &5C,&20,&57,&FF,&45,&2C,&5C,&20
            .byte &46,&A9,&A0,&5C,&52,&C6,&4C,&46
            .byte &20,&8F,&89,&C8,&4F,&9F,&7B,&89
            .byte &88,&2C,&5C,&A3,&DB,&53,&53,&B7
            .byte &53,&9C,&A4,&47,&B3,&45,&21,&0D
            .byte &23,&F5,&A0,&AD,&4C,&50,&A4,&A8
            .byte &4F,&53,&9D,&57,&ED,&20,&AD,&4C
            .byte &50,&20,&8B,&4D,&C6,&4C,&56,&B7
            .byte &21,&0D,&22,&23,&A5,&AB,&BE,&47
            .byte &4E,&C9,&9D,&0D,&81,&EF,&F1,&99
            .byte &21,&0D,&A8,&4F,&53,&9D,&47,&DD
            .byte &56,&B7,&2E,&8B,&59,&27,&52,&9D
            .byte &89,&23,&4B,&99,&27,&53,&21,&0D
            .byte &81,&B4,&02,&21,&0D,&A8,&4F,&53
            .byte &9D,&46,&55,&52,&B0,&56,&9D,&45
            .byte &59,&B7,&21,&0D,&81,&54,&B9,&03
            .byte &21,&0D,&A8,&4F,&53,&9D,&42,&8C
            .byte &A2,&C3,&47,&53,&21,&0D,&A8,&4F
            .byte &53,&9D,&AC,&4B,&4C,&B7,&21,&0D
            .byte &A8,&4F,&53,&9D,&46,&0B,&54,&21
            .byte &0D,&A8,&4F,&53,&9D,&48,&8C,&53
            .byte &21,&0D,&23,&5C,&20,&42,&9D,&89
            .byte &44,&B7,&50,&AA,&B2,&9D,&43,&52
            .byte &49,&4D,&A9,&C7,&20,&6E,&89,&6C
            .byte &53,&2C,&59,&B3,&44,&AA,&21,&5C
            .byte &27,&D7,&20,&EE,&9F,&BE,&4D,&9D
            .byte &41,&D5,&AE,&A0,&4D,&A2,&95,&22
            .byte &2C,&0F,&B5,&54,&A4,&89,&23,&D1
            .byte &50,&CC,&A9,&2C,&8A,&B0,&45,&A4
            .byte &5C,&A3,&CA,&F1,&20,&A9,&76,&56
            .byte &AE,&49,&9B,&20,&EF,&E7,&B9,&27
            .byte &A4,&4B,&EE,&54,&53,&21,&0D,&22
            .byte &23,&AD,&D7,&4F,&20,&8B,&AB,&2C
            .byte &62,&AA,&21,&5C,&27,&D7,&20,&42
            .byte &9D,&57,&AC,&54,&A9,&27,&20,&50
            .byte &0A,&EF,&47,&9D,&7E,&4D,&A2,&56
            .byte &B7,&C6,&4C,&2C,&57,&49,&D7,&20
            .byte &27,&45,&3F,&44,&DF,&50,&20,&5C
            .byte &A3,&79,&67,&20,&8B,&AB,&2C,&C8
            .byte &A3,&1E,&59,&4D,&AF,&54,&2C,&D4
            .byte &4B,&45,&22,&2C,&0D,&EF,&59,&A4
            .byte &89,&23,&D1,&50,&CC,&A9,&2E,&0D
            .byte &22,&23,&19,&20,&5C,&A3,&DB,&4F
            .byte &50,&20,&BF,&F1,&2C,&C5,&B1,&59
            .byte &21,&A5,&57,&AC,&9F,&4D,&B9,&9D
            .byte &54,&AB,&0A,&55,&AB,&22,&2C,&0D
            .byte &22,&23,&53,&BB,&BD,&A3,&4D,&9D
            .byte &B0,&4D,&42,&AA,&53,&21,&A8,&B2
            .byte &27,&D7,&20,&C1,&20,&4E,&49,&43
            .byte &CD,&59,&2C,&D0,&52,&22,&2C,&0D
            .byte &23,&50,&AB,&53,&53,&3C,&26,&AB
            .byte &54,&55,&52,&4E,&26,&3C,&C8,&A3
            .byte &AC,&4F,&8B,&A3,&47,&D6,&45,&2E
            .byte &0D,&22,&23,&AD,&D7,&4F,&21,&C7
            .byte &A8,&B5,&DE,&20,&23,&49,&27,&A7
            .byte &A1,&08,&47,&47,&AE,&2C,&23,&49
            .byte &27,&A7,&41,&A4,&D3,&E2,&53,&A2
            .byte &41,&A4,&0C,&AA,&59,&B3,&9D,&CD
            .byte &C6,&2C,&4F,&4B,&1F,&3F,&03,&20
            .byte &4A,&12,&9F,&44,&DF,&50,&20,&0D
            .byte &53,&E5,&9D,&C8,&4F,&A0,&0D,&A1
            .byte &42,&41,&A3,&7B,&03,&41,&50,&20
            .byte &0D,&A1,&DA,&AC,&4B,&45,&9F,&0D
            .byte &67,&20,&8B,&52,&9D,&C8,&A3,&F2
            .byte &22,&2C,&EF,&59,&A4,&89,&08,&47
            .byte &47,&AE,&2E,&0D,&22,&23,&BB,&21
            .byte &49,&27,&56,&9D,&B4,&A0,&A1,&57
            .byte &0A,&48,&22,&2C,&EF,&59,&A4,&89
            .byte &08,&47,&47,&AE,&2C,&57,&41,&56
            .byte &99,&20,&89,&03,&41,&50,&2E,&0D
            .byte &23,&41,&9E,&4F,&42,&4A,&45,&43
            .byte &9F,&46,&C7,&4C,&A4,&76,&89,&46
            .byte &DD,&B9,&21,&0D,&22,&23,&08,&D1
            .byte &12,&9D,&5C,&27,&56,&9D,&08,&45
            .byte &9E,&03,&20,&4E,&49,&43,&9D,&76
            .byte &F2,&2C,&B4,&56,&9D,&8B,&53,&9D
            .byte &4D,&B6,&54,&AF,&53,&22,&2C,&EF
            .byte &59,&A4,&89,&08,&47,&47,&AE,&2C
            .byte &47,&AF,&AA,&9B,&4C,&59,&2E,&0D
            .byte &23,&89,&1B,&E7,&44,&99,&20,&AB
            .byte &53,&B5,&C4,&A4,&6D,&A1,&DD,&A6
            .byte &50,&B6,&43,&AD,&A0,&E9,&A7,&41
            .byte &A4,&89,&C5,&53,&D0,&56,&9D,&C1
            .byte &4F,&A3,&53,&DD,&57,&4C,&A2,&68
            .byte &53,&2C,&AB,&56,&BC,&4C,&99,&2C
            .byte &41,&A4,&49,&9F,&C1,&45,&A4,&03
            .byte &2C,&89,&CF,&4D,&4C,&A2,&D4,&9F
            .byte &A9,&54,&AA,&49,&4F,&A3,&7B,&89
            .byte &97,&21,&0D,&23,&57,&CD,&4C,&20
            .byte &44,&B3,&45,&21,&5C,&20,&B4,&56
            .byte &9D,&BE,&E8,&C3,&B1,&A0,&22,&23
            .byte &C9,&4C,&8A,&7B,&23,&58,&41,&AC
            .byte &22,&20,&8A,&B4,&56,&9D,&A1,&C5
            .byte &58,&49,&4D,&55,&A7,&53,&43,&B9
            .byte &9D,&7B,&32,&35,&30,&20,&DB,&A9
            .byte &54,&53,&21,&0D,&53,&21,&0D,&22
            .byte &23,&AD,&D7,&4F,&20,&8B,&AB,&2C
            .byte &62,&23,&89,&54,&AB,&4D,&AF,&44
            .byte &9B,&20,&DB,&05,&A3,&7B,&89,&93
            .byte &46,&C7,&4C,&20,&46,&B9,&43,&45
            .byte &A4,&5C,&20,&76,&5C,&A3,&4B,&CA
            .byte &45,&A4,&8A,&5C,&20,&BE,&4C,&CB
            .byte &50,&C6,&2C,&42,&AB,&41,&A8,&82
            .byte &4C,&59,&2C,&76,&89,&46,&DD,&B9
            .byte &21,&5C,&20,&47,&4C,&AC,&43,&9D
            .byte &5D,&57,&AE,&44,&A4,&8A,&C5,&4B
            .byte &9D,&B5,&9F,&89,&B4,&5A,&A2,&53
            .byte &B4,&50,&9D,&7B,&A1,&77,&20,&AF
            .byte &07,&AC,&43,&9D,&08,&59,&B3,&44
            .byte &2E,&8B,&9E,&0C,&AA,&59,&A8,&99
            .byte &20,&F5,&45,&A4,&42,&CB,&F1,&2E
            .byte &0D,&23,&5B,&D2,&BF,&A3,&89,&43
            .byte &C0,&0F,&99,&20,&93,&46,&C7,&4C
            .byte &2C,&89,&68,&20,&D9,&42,&AB,&D7
            .byte &A1,&AD,&4C,&A0,&EF,&46,&CD,&A2
            .byte &6F,&5C,&2E,&89,&10,&B6,&9D,&93
            .byte &20,&52,&12,&AD,&A4,&1E,&B8,&2C
            .byte &B6,&A4,&53,&50,&C0,&A2,&03,&FF
            .byte &99,&20,&5C,&20,&76,&89,&53,&4B
            .byte &A9,&2E,&A8,&52,&B5,&DE,&20,&89
            .byte &05,&9F,&B4,&5A,&45,&2C,&76,&89
            .byte &5D,&2C,&5C,&20,&71,&20,&89,&AF
            .byte &07,&AC,&43,&9D,&76,&A1,&74,&20
            .byte &77,&2E,&0D,&23,&5B,&7A,&A1,&53
            .byte &C5,&D7,&2C,&CF,&4D,&4C,&A2,&D4
            .byte &9F,&6C,&2C,&46,&E7,&C3,&A0,&6D
            .byte &89,&B8,&AF,&D3,&20,&7B,&44,&BC
            .byte &A8,&20,&8A,&BF,&D1,&59,&2E,&89
            .byte &E4,&E2,&A8,&2C,&E1,&AC,&B6,&9D
            .byte &64,&A4,&71,&A7,&76,&69,&20,&7A
            .byte &7E,&5C,&2C,&66,&82,&20,&8A,&4D
            .byte &AF,&F6,&99,&21,&76,&89,&5D,&20
            .byte &DD,&E5,&A4,&A1,&E9,&DC,&2C,&02
            .byte &7E,&C1,&B9,&2E,&0D,&23,&5B,&8F
            .byte &A1,&44,&BC,&A0,&AF,&A0,&7A,&89
            .byte &43,&B9,&8D,&B9,&2E,&89,&6C,&A4
            .byte &5E,&20,&7B,&5C,&20,&06,&56,&9D
            .byte &57,&41,&A2,&76,&52,&B5,&DE,&2C
            .byte &1C,&49,&F1,&20,&64,&53,&2C,&8A
            .byte &89,&43,&45,&E7,&99,&20,&49,&A4
            .byte &03,&20,&DD,&57,&2C,&81,&5B,&46
            .byte &B9,&43,&45,&A0,&76,&B8,&E2,&50
            .byte &2E,&0D,&23,&5B,&7A,&A1,&4C,&B3
            .byte &47,&2C,&5F,&2D,&60,&20,&43,&B9
            .byte &8D,&B9,&2E,&F8,&8B,&A3,&78,&20
            .byte &7B,&5C,&2C,&6B,&20,&6C,&A4,&B8
            .byte &AB,&54,&D3,&20,&A9,&76,&89,&47
            .byte &DD,&E5,&2E,&0D,&23,&5B,&8F,&89
            .byte &60,&AA,&9E,&AF,&A0,&7B,&89,&4C
            .byte &B3,&47,&20,&43,&B9,&8D,&B9,&2E
            .byte &5E,&20,&7B,&5B,&89,&CB,&53,&9F
            .byte &7B,&89,&6B,&20,&6C,&53,&2E,&A1
            .byte &4E,&AE,&DF,&A6,&AE,&D3,&57,&41
            .byte &A2,&49,&A4,&4A,&12,&9F,&56,&C9
            .byte &49,&DA,&9D,&D6,&B3,&47,&53,&9F
            .byte &89,&53,&B4,&C1,&57,&A4,&7B,&89
            .byte &5D,&20,&64,&2E,&0D,&23,&5B,&7A
            .byte &A1,&54,&57,&49,&B8,&99,&20,&7D
            .byte &20,&7B,&45,&D3,&4F,&99,&20,&43
            .byte &B9,&8D,&B9,&53,&2E,&BC,&D3,&20
            .byte &53,&B5,&4E,&A0,&5C,&20,&C5,&4B
            .byte &9D,&71,&4D,&A4,&D6,&50,&D4,&46
            .byte &49,&45,&A0,&41,&A4,&49,&9F,&42
            .byte &B5,&4E,&43,&45,&A4,&08,&54,&05
            .byte &45,&9E,&89,&BE,&4C,&44,&2C,&DF
            .byte &F1,&20,&64,&53,&21,&0D,&23,&5B
            .byte &7A,&89,&61,&6A,&20,&7B,&89,&4B
            .byte &45,&04,&2E,&D4,&9A,&20,&B8,&AB
            .byte &D6,&A4,&7A,&6E,&41,&9E,&68,&20
            .byte &C1,&B9,&57,&41,&A2,&76,&89,&5D
            .byte &2C,&AB,&41,&D3,&99,&20,&0C,&AA
            .byte &A2,&43,&B9,&4E,&AA,&2C,&53,&ED
            .byte &57,&99,&20,&89,&46,&E7,&A8,&20
            .byte &8A,&53,&F0,&C7,&4F,&A3,&81,&41
            .byte &42,&B5,&C4,&53,&21,&A1,&53,&43
            .byte &17,&46,&46,&A2,&61,&49,&A4,&53
            .byte &C3,&04,&99,&20,&7E,&A1,&48,&AE
            .byte &44,&2C,&57,&E2,&BF,&9E,&42,&AF
            .byte &D3,&20,&C6,&9F,&A9,&76,&89,&5D
            .byte &20,&64,&2E,&0D,&23,&5B,&7E,&A1
            .byte &88,&C2,&50,&20,&5D,&20,&7B,&89
            .byte &4B,&45,&04,&2C,&DD,&4F,&4B,&99
            .byte &20,&67,&20,&A1,&44,&AC,&47,&AA
            .byte &9B,&20,&53,&43,&AB,&9D,&53,&DD
            .byte &50,&9D,&76,&A1,&74,&20,&73,&08
            .byte &59,&B3,&44,&2E,&0D,&23,&5B,&7E
            .byte &89,&88,&C2,&50,&20,&5D,&60,&20
            .byte &7B,&89,&4B,&45,&04,&2E,&76,&89
            .byte &5D,&2C,&67,&20,&89,&88,&2C,&89
            .byte &74,&20,&73,&53,&50,&AB,&FD,&A4
            .byte &F6,&DF,&53,&A4,&A1,&56,&C7,&C3
            .byte &59,&2E,&0D,&23,&5B,&7E,&89,&88
            .byte &C2,&50,&20,&5D,&5F,&20,&7B,&89
            .byte &4B,&45,&04,&2E,&5D,&2C,&67,&20
            .byte &89,&88,&2C,&49,&A4,&89,&C8,&AB
            .byte &B8,&2E,&0D,&23,&5B,&7E,&A1,&BE
            .byte &42,&42,&C3,&A0,&75,&57,&41,&A2
            .byte &4C,&BC,&44,&99,&20,&5E,&60,&20
            .byte &76,&5D,&5F,&20,&67,&20,&89,&88
            .byte &2E,&0D,&23,&5B,&7E,&A1,&BE,&42
            .byte &42,&C3,&A0,&75,&57,&41,&A2,&57
            .byte &BB,&D3,&20,&4C,&BC,&44,&A4,&5E
            .byte &5F,&20,&76,&5D,&60,&20,&67,&20
            .byte &89,&88,&2E,&0D,&23,&5B,&7A,&A1
            .byte &84,&20,&60,&20,&7B,&89,&4B,&45
            .byte &04,&2E,&BB,&DE,&20,&64,&A4,&97
            .byte &20,&F8,&8B,&A3,&78,&20,&7B,&5C
            .byte &2C,&0F,&52,&B5,&44,&99,&20,&5C
            .byte &20,&7A,&A1,&BF,&04,&2C,&BE,&4C
            .byte &A0,&53,&B4,&C1,&57,&2E,&0D,&23
            .byte &5B,&7A,&A1,&BB,&DE,&20,&64,&45
            .byte &A0,&83,&5F,&20,&7B,&89,&4B,&45
            .byte &04,&2E,&89,&64,&A4,&B4,&56,&9D
            .byte &08,&45,&9E,&57,&B9,&9E,&E4,&E2
            .byte &A8,&20,&4F,&BD,&A3,&89,&47,&AF
            .byte &AA,&B2,&9C,&A4,&8A,&AE,&9D,&D2
            .byte &53,&55,&52,&4D,&B5,&BA,&41,&42
            .byte &C3,&2E,&0D,&23,&5B,&7A,&A1,&64
            .byte &45,&A0,&84,&20,&60,&20,&7B,&89
            .byte &4B,&45,&04,&2E,&A1,&43,&88,&20
            .byte &42,&AB,&45,&5A,&9D,&AB,&44,&44
            .byte &AF,&A4,&5C,&A3,&46,&F6,&45,&2E
            .byte &0D,&23,&5B,&7A,&A1,&64,&45,&A0
            .byte &83,&5F,&20,&7B,&89,&4B,&45,&04
            .byte &2E,&A1,&0F,&AE,&50,&20,&42,&AB
            .byte &45,&5A,&9D,&57,&BB,&B8,&C3,&A4
            .byte &19,&20,&89,&83,&6E,&89,&5E,&2E
            .byte &0D,&23,&5B,&7E,&A1,&7C,&C2,&50
            .byte &20,&5E,&60,&20,&7B,&89,&4B,&45
            .byte &04,&2E,&89,&B8,&52,&B3,&47,&20
            .byte &90,&20,&CB,&53,&AD,&A4,&89,&C6
            .byte &A1,&A9,&76,&A1,&54,&55,&52,&00
            .byte &E7,&2C,&53,&AF,&44,&99,&20,&53
            .byte &55,&52,&46,&20,&19,&20,&89,&4A
            .byte &41,&47,&DC,&A0,&7C,&2D,&46,&F6
            .byte &45,&2E,&0D,&23,&5B,&7E,&A1,&4E
            .byte &AE,&DF,&A6,&C3,&44,&47,&9D,&5E
            .byte &20,&7B,&89,&4B,&45,&04,&2C,&BB
            .byte &DE,&20,&6F,&89,&C0,&47,&99,&20
            .byte &53,&BC,&2E,&89,&90,&20,&DA,&13
            .byte &A4,&48,&AE,&A0,&8A,&46,&B9,&43
            .byte &45,&A4,&5C,&20,&92,&41,&47,&41
            .byte &A9,&53,&9F,&89,&4B,&45,&04,&20
            .byte &64,&2C,&87,&20,&6E,&89,&BF,&1C
            .byte &49,&A4,&A8,&DF,&57,&9E,&19,&20
            .byte &42,&A2,&89,&57,&0A,&48,&20,&41
            .byte &A4,&49,&9F,&43,&C0,&53,&AD,&A4
            .byte &A9,&76,&89,&53,&AD,&45,&A3,&7C
            .byte &2E,&0D,&23,&5B,&5E,&5F,&20,&7B
            .byte &89,&4B,&45,&04,&2C,&7E,&A1,&50
            .byte &A9,&E3,&43,&4C,&9D,&4F,&56,&AA
            .byte &DD,&4F,&4B,&99,&20,&89,&53,&BC
            .byte &2E,&89,&FC,&02,&4C,&99,&20,&90
            .byte &20,&ED,&57,&4C,&A4,&AE,&B5,&4E
            .byte &A0,&5C,&2C,&42,&B6,&99,&20,&5C
            .byte &A3,&11,&B7,&48,&20,&8A,&46,&AB
            .byte &45,&5A,&99,&20,&5C,&A3,&42,&AB
            .byte &41,&A8,&21,&0D,&23,&5B,&7E,&A1
            .byte &50,&CB,&7A,&4F,&56,&AA,&DD,&4F
            .byte &4B,&99,&20,&A1,&C0,&4D,&53,&B4
            .byte &F1,&4C,&9D,&47,&C0,&BD,&59,&AE
            .byte &44,&2E,&89,&90,&20,&EC,&F1,&A4
            .byte &19,&20,&46,&A9,&9D,&44,&12,&9F
            .byte &57,&BB,&D3,&20,&BE,&56,&AA,&A4
            .byte &5C,&20,&6E,&AD,&41,&A0,&76,&C2
            .byte &45,&2C,&8A,&C5,&4B
L5844:      .byte &45,&A4,&5C,&20,&71,&A7,&DE,&4F
            .byte &B8,&4C,&A2,&57,&BB,&B1,&2E,&0D
            .byte &23,&5B,&BB,&DE,&20,&6F,&A1,&90
            .byte &FC,&04,&9F,&50,&CB,&A9,&2C,&DD
            .byte &4F,&4B,&99,&20,&67,&20,&6E,&A1
            .byte &DF,&F1,&A2,&50,&AB,&43,&49,&EC
            .byte &43,&45,&2E,&89,&B8,&52,&B3,&47
            .byte &20,&90,&20,&52,&12,&AD,&A4,&50
            .byte &0A,&9F,&5C,&2C,&A8,&52,&B5,&DE
            .byte &20,&A1,&DD,&A6,&AE,&D3,&57,&41
            .byte &A2,&76,&89,&5D,&2C,&8A,&A9,&76
            .byte &89,&4D,&55,&B8,&A2,&77,&53,&2E
            .byte &0D,&23,&5B,&7E,&A1,&50,&AB,&43
            .byte &49,&EC,&43,&9D,&46,&41,&A3,&6F
            .byte &A1,&EA,&42,&DA,&9D,&42,&BC,&D3
            .byte &2E,&89,&DA,&55,&B8,&AA,&A2,&90
            .byte &20,&FC,&02,&4C,&A4,&AE,&B5,&4E
            .byte &A0,&5C,&2C,&D1,&12,&99,&20,&5C
            .byte &20,&76,&B1,&45,&B1,&A3,&50,&AB
            .byte &43,&AE,&49,&9B,&4C,&A2,&7E,&89
            .byte &E0,&DC,&21,&0D,&23,&5B,&7E,&A1
            .byte &47,&55,&B8,&A2,&7C,&C2,&50,&20
            .byte &DD,&4F,&4B,&99,&20,&B5,&9F,&F6
            .byte &DF,&53,&A4,&89,&53,&BC,&2E,&46
            .byte &41,&A3,&70,&5C,&20,&49,&A4,&A1
            .byte &57,&E2,&BF,&9E,&4A,&45,&54,&F3
            .byte &2C,&60,&20,&7B,&57,&BB,&D3,&20
            .byte &49,&A4,&4D,&E2,&AB,&A0,&A1,&EF
            .byte &E7,&99,&20,&95,&2E,&0D,&23,&5B
            .byte &7E,&A1,&EA,&42,&DA,&9D,&85,&8F
            .byte &89,&C8,&4F,&9F,&7B,&A1,&53,&B1
            .byte &04,&20,&7C,&2E,&A1,&53,&C7,&54
            .byte &A2,&42,&AB,&45,&5A,&9D,&DA,&13
            .byte &A4,&7A,&6E,&89,&53,&BC,&2E,&0D
            .byte &23,&5B,&7E,&A1,&EA,&42,&DA,&9D
            .byte &42,&BC,&D3,&2C,&D2,&BF,&A3,&A1
            .byte &BB,&DE,&20,&7C,&2C,&CA,&58,&9F
            .byte &76,&89,&52,&B5,&DE,&20,&53,&BC
            .byte &2E,&89,&90,&20,&49,&A4,&B8,&52
            .byte &B3,&47,&2E,&0D,&23,&5B,&7E,&A1
            .byte &54,&AB,&45,&82,&20,&75,&20,&8F
            .byte &89,&C8,&4F,&9F,&7B,&A1,&BB,&DE
            .byte &20,&4D,&B5,&BA,&41,&A9,&2E,&B8
            .byte &AE,&99,&20,&19,&2C,&B6,&A4,&53
            .byte &B1,&04,&20,&64,&A4,&71,&A7,&76
            .byte &44,&C9,&41,&EB,&BC,&A3,&A9,&76
            .byte &89,&43,&4C,&B5,&44,&A2,&53,&4B
            .byte &59,&2E,&0D,&23,&5C,&20,&8F,&89
            .byte &D5,&54,&C2,&A7,&7B,&A1,&54,&C7
            .byte &4C,&2C,&B8,&AE,&4B,&20,&4D,&B5
            .byte &BA,&41,&A9,&2E,&76,&89,&5D,&2C
            .byte &8B,&52,&9D,&49,&A4,&A1,&43,&AB
            .byte &56,&49,&43,&9D,&7A,&89,&78,&20
            .byte &7B,&89,&4D,&B5,&BA,&41,&A9,&2C
            .byte &4C,&AE,&47,&9D,&AF,&B5,&DE,&20
            .byte &76,&AF,&54,&AA,&2E,&0D,&23,&5B
            .byte &8F,&89,&AF,&07,&AC,&43,&9D,&76
            .byte &A1,&C5,&53,&D0,&56,&9D,&C8,&AB
            .byte &B8,&2E,&5F,&20,&8A,&60,&20,&7B
            .byte &5C,&20,&47,&DF,&57,&A4,&A1,&A8
            .byte &B9,&4E,&A2,&AD,&44,&47,&AA,&13
            .byte &2C,&57,&BB,&D3,&20,&46,&B9,&4D
            .byte &A4,&A1,&75,&20,&A9,&76,&89,&73
            .byte &8A,&8B,&9E,&BD,&AA,&A4,&52,&49
            .byte &9A,&20,&8A,&C3,&46,&54,&2C,&43
            .byte &DD,&53,&99,&20,&7A,&89,&54,&AB
            .byte &B7,&2E,&49,&9F,&49,&A4,&D4,&9A
            .byte &20,&48,&AA,&45,&2C,&1B,&9F,&EA
            .byte &AA,&99,&20,&A9,&2C,&C7,&4C,&20
            .byte &49,&A4,&41,&9E,&45,&AA,&49,&9D
            .byte &42,&CB,&F1,&4E,&B7,&53,&21,&0D
            .byte &23,&5B,&8F,&89,&E0,&47,&9D,&7B
            .byte &89,&C8,&AB,&B8,&2C,&5C,&A3,&57
            .byte &41,&A2,&B5,&9F,&42,&6B,&20,&42
            .byte &A2,&A1,&A8,&49,&F1,&20,&AD,&44
            .byte &DC,&2E,&0D,&23,&5B,&8F,&89,&C8
            .byte &AB,&B8,&27,&A4,&E0,&DC,&2E,&7A
            .byte &89,&AD,&44,&47,&AA,&4F,&A6,&46
            .byte &B9,&4D,&99,&20,&89,&5F,&AA,&9E
            .byte &42,&B5,&C4,&AE,&A2,&49,&A4,&A1
            .byte &ED,&C3,&2C,&4A,&12,&9F,&57,&49
            .byte &44,&9D,&AF,&B5,&DE,&20,&C8,&A3
            .byte &5C,&20,&76,&53,&F0,&0B,&5A,&9D
            .byte &A8,&52,&B5,&DE,&2E,&0D,&23,&5B
            .byte &BF,&04,&20,&7A,&89,&C8,&AB,&B8
            .byte &2E,&54,&C7,&4C,&20,&54,&AB,&45
            .byte &A4,&AB,&41,&A3,&19,&20,&C7,&4C
            .byte &20,&AE,&B5,&C4,&2C,&8B,&49,&A3
            .byte &1C,&AC,&43,&AD,&A4,&A9,&54,&AA
            .byte &54,&57,&A9,&99,&20,&76,&43,&55
            .byte &9F,&B5,&9F,&C7,&4C,&20,&16,&59
            .byte &D4,&9A,&2E,&5C,&A3,&CB,&E8,&20
            .byte &D1,&B8,&A4,&A1,&59,&CD,&DD,&A6
            .byte &B4,&DD,&20,&4F,&BD,&A3,&5C,&2C
            .byte &57,&BB,&D3,&20,&53,&D1,&AB,&A4
            .byte &89,&73,&43,&AB,&B2,&55,&AB,&A4
            .byte &8A,&ED,&4C,&44,&A4,&8B,&A7,&8F
            .byte &42,&1F,&2E,&0D,&23,&5B,&7A,&89
            .byte &AF,&07,&AC,&43,&9D,&43,&B4,&4D
            .byte &08,&A3,&7B,&A1,&4C,&AE,&47,&9D
            .byte &D1,&56,&9D,&53,&59,&53,&B1,&4D
            .byte &2E,&5E,&20,&7B,&5C,&2C,&89,&D1
            .byte &53,&D1,&44,&99,&20,&93,&46,&C7
            .byte &4C,&20,&4F,&42,&53,&43,&55,&AB
            .byte &A4,&5C,&A3,&56,&49,&45,&A6,&7B
            .byte &89,&C8,&AB,&B8,&2E,&0D,&23,&5B
            .byte &8F,&A1,&44,&BC,&A0,&AF,&A0,&7A
            .byte &89,&77,&20,&50,&0A,&EF,&47,&B7
            .byte &2E,&5C,&20,&CB,&E8,&20,&D1,&B8
            .byte &A4,&62,&45,&2C,&AC,&49,&C5,&B1
            .byte &A0,&53,&B4,&C1,&57,&A4,&7E,&89
            .byte &55,&CA,&BD,&9E,&64,&53,&2E,&0D
            .byte &23,&5B,&7A,&A1,&7D,&20,&7B,&4E
            .byte &AE,&DF,&A6,&77,&20,&50,&0A,&EF
            .byte &47,&B7,&2C,&4D,&A9,&44,&46,&55
            .byte &4C,&20,&7B,&89,&DF,&F1,&A2,&B5
            .byte &54,&43,&DF,&50,&A4,&8A,&DB,&A9
            .byte &B1,&A0,&B8,&C7,&F6,&B0,&B1,&A4
            .byte &57,&BB,&D3,&20,&48,&AC,&47,&20
            .byte &44,&AC,&47,&AA,&9B,&4C,&A2,&6E
            .byte &89,&43,&45,&E7,&99,&2E,&0D,&23
            .byte &5B,&7A,&A1,&4C,&AE,&47,&9D,&43
            .byte &B4,&4D,&42,&AA,&2C,&41,&57,&AE
            .byte &9D,&7B,&89,&BE,&4C,&A0,&44,&C0
            .byte &55,&9A,&20,&57,&BB,&D3,&20,&54
            .byte &B5,&43,&AD,&A4,&5C,&A3,&46,&F6
            .byte &9D,&6E,&89,&5D,&2E,&0D,&23,&5B
            .byte &7A,&A1,&DA,&55,&B8,&AA,&A2,&77
            .byte &20,&50,&0A,&EF,&DC,&2E,&A1,&42
            .byte &AB,&45,&5A,&9D,&DA,&13,&A4,&7A
            .byte &6E,&89,&5E,&2E,&0D,&23,&5B,&7A
            .byte &A1,&C5,&53,&D0,&56,&9D,&B4,&D7
            .byte &20,&7A,&89,&77,&53,&2E,&89,&53
            .byte &B5,&4E,&A0,&7B,&0E,&49,&EB,&99
            .byte &20,&93,&20,&45,&D3,&4F,&45,&A4
            .byte &6E,&53,&E5,&45,&10,&AA,&9D,&CF
            .byte &B8,&AC,&9F,&8A,&E6,&AA,&47,&99
            .byte &20,&6E,&89,&53,&B4,&C1,&57,&A4
            .byte &7B,&89,&43,&45,&E7,&99,&20,&5C
            .byte &20,&71,&20,&E9,&DC,&2C,&43,&B3
            .byte &49,&43,&C7,&20,&B8,&C7,&F6,&B0
            .byte &B1,&53,&2C,&D4,&4D,&9D,&10,&B6
            .byte &9D,&7A,&89,&47,&4C,&AE,&9D,&7B
            .byte &5C,&A3,&CB,&E8,&2E,&0D,&23,&5B
            .byte &8F,&89,&C2,&50,&20,&7B,&A1,&90
            .byte &99,&20,&B8,&F4,&52,&D1,&C6,&2C
            .byte &AD,&57,&9E,&6E,&89,&77,&20,&DF
            .byte &F1,&2E,&0D,&23,&5B,&7E,&A1,&90
            .byte &99,&20,&B8,&F4,&52,&D1,&C6,&2C
            .byte &43,&AE,&BD,&A0,&6E,&89,&77,&20
            .byte &DF,&F1,&2E,&0D,&23,&5B,&7A,&A1
            .byte &CF,&4D,&4C,&A2,&D4,&9F,&47,&C0
            .byte &BD,&59,&AE,&44,&2E,&FC,&02,&4C
            .byte &99,&20,&01,&B8,&A4,&43,&DD,&FF
            .byte &20,&89,&AD,&FD,&B8,&B3,&B7,&2C
            .byte &C5,&4B,&99,&20,&8B,&A7,&53,&BB
            .byte &4D,&F2,&A3,&6D,&41,&9E,&D2,&4E
            .byte &B2,&55,&C0,&4C,&20,&D4,&9A,&2E
            .byte &0D,&23,&5B,&7E,&A1,&01,&B8,&A2
            .byte &46,&D4,&9A,&20,&7B,&53,&B1,&50
            .byte &A4,&57,&BB,&D3,&20,&43,&B3,&CA
            .byte &43,&54,&A4,&19,&EA,&A3,&8A,&DD
            .byte &05,&A3,&C3,&BD,&4C,&A4,&7B,&89
            .byte &47,&C0,&BD,&59,&AE,&44,&2E,&0D
            .byte &23,&5B,&7E,&0E,&59,&2C,&53,&8C
            .byte &A2,&42,&BC,&D3,&2E,&7A,&89,&CF
            .byte &B8,&AC,&43,&9D,&76,&89,&5D,&2C
            .byte &89,&52,&B5,&DE,&20,&C6,&A1,&43
            .byte &C0,&53,&AD,&A4,&76,&89,&53,&ED
            .byte &AB,&2E,&A1,&4C,&B6,&54,&4C,&9D
            .byte &57,&41,&A2,&5E,&2C,&89,&47,&AB
            .byte &A2,&7C,&A4,&64,&20,&7A,&89,&42
            .byte &BC,&D3,&2E,&0D,&23,&5B,&7E,&A1
            .byte &53,&8C,&A2,&85,&42,&A2,&89,&52
            .byte &B5,&DE,&20,&53,&BC,&2E,&89,&53
            .byte &8A,&49,&A4,&44,&D6,&50,&20,&8A
            .byte &5C,&20,&4C,&BC,&56,&9D,&BF,&04
            .byte &20,&C8,&4F,&54,&D8,&A9,&54,&53
            .byte &2E,&0D,&23,&5B,&7E,&A1,&57,&49
            .byte &BF,&2C,&11,&8F,&50,&CB,&A9,&2E
            .byte &89,&90,&20,&DA,&13,&A4,&B8,&52
            .byte &B3,&47,&4C,&59,&2C,&4B,&49,&F1
            .byte &99,&20,&19,&20,&89,&44,&12,&9F
            .byte &A9,&76,&D3,&4F,&4B,&99,&20,&43
            .byte &4C,&B5,&44,&53,&2E,&0D,&23,&5B
            .byte &7E,&89,&C2,&50,&20,&7B,&A1,&44
            .byte &AC,&47,&AA,&9B,&20,&53,&43,&AB
            .byte &9D,&53,&DD,&50,&9D,&4F,&56,&AA
            .byte &DD,&4F,&4B,&99,&20,&89,&C8,&AB
            .byte &B8,&2E,&5C,&20,&47,&41,&5A,&9D
            .byte &67,&20,&89,&88,&2C,&76,&89,&D5
            .byte &54,&C2,&A7,&7B,&89,&53,&DD,&50
            .byte &9D,&10,&AA,&9D,&89,&E1,&B5,&4E
            .byte &A0,&71,&4D,&A4,&46,&02,&4D,&AA
            .byte &2E,&8F,&81,&4D,&E5,&AF,&54,&2C
            .byte &A1,&B8,&B3,&9D,&00,&BD,&A4,&6E
            .byte &D2,&BF,&A3,&5C,&2C,&8A,&5C,&20
            .byte &53,&50,&C0,&57,&4C,&20,&F6,&DF
            .byte &53,&A4,&89,&4A,&41,&47,&DC,&A0
            .byte &B8,&B3,&B7,&2E,&0D,&23,&5C,&20
            .byte &AF,&B1,&A3,&89,&CF,&CB,&EC,&16
            .byte &B1,&A0,&48,&9B,&9D,&8A,&EA,&45
            .byte &A3,&52,&B5,&C4,&2C,&D1,&55,&B0
            .byte &9B,&4C,&59,&2E,&5C,&20,&AD,&41
            .byte &A3,&A1,&4C,&B5,&A0,&53,&43,&C0
            .byte &50,&99,&20,&8A,&8B,&9E,&BE,&4C
            .byte &CB,&50,&53,&9D,&76,&89,&46,&DD
            .byte &B9,&2C,&41,&A4,&89,&DF,&7B,&D1
            .byte &BD,&A4,&7A,&8A,&43,&52,&12,&AD
            .byte &A4,&5C,&2E,&0D,&23,&5C,&20,&AF
            .byte &B1,&A3,&89,&6A,&20,&8A,&46,&A9
            .byte &A0,&5C,&52,&C6,&4C,&46,&20,&7A
            .byte &A1,&B8,&55,&44,&59,&2E,&A1,&4C
            .byte &BC,&8B,&A3,&FC,&49,&BD,&4C,&20
            .byte &43,&B4,&49,&A3,&46,&F6,&45,&A4
            .byte &87,&20,&6E,&5C,&2E,&53,&55,&44
            .byte &44,&AF,&4C,&59,&2C,&89,&43,&B4
            .byte &49,&A3,&AB,&56,&4F,&4C,&BD,&A4
            .byte &8A,&5C,&20,&46,&F6,&9D,&89,&23
            .byte &4B,&99,&2E,&22,&23,&A5,&C1,&98
            .byte &57,&AC,&9F,&76,&42,&9D,&CF,&B8
            .byte &55,&52,&42,&E0,&22,&2C,&48,&9D
            .byte &0F,&B5,&54,&53,&2C,&8A,&47,&C0
            .byte &42,&42,&99,&20,&A1,&D0,&4C,&BD
            .byte &A3,&C3,&54,&B1,&A3,&68,&AA,&2C
            .byte &B8,&41,&42,&A4,&5C,&21,&0D,&23
            .byte &5C,&20,&14,&D2,&47,&9D,&A9,&76
            .byte &89,&46,&AB,&45,&5A,&99,&20,&53
            .byte &BC,&2E,&A1,&06,&47,&AC,&B0,&43
            .byte &20,&57,&41,&56,&9D,&46,&DD,&4F
            .byte &44,&A4,&4F,&BD,&A3,&5C,&2C,&50
            .byte &55,&D7,&99,&20,&5C,&20,&55,&C4
            .byte &AA,&2E,&89,&CB,&53,&9F,&A8,&99
            .byte &20,&5C,&20,&46,&45,&CD,&20,&49
            .byte &A4,&89,&B8,&99,&20,&7B,&53,&C7
            .byte &9F,&93,&20,&7A,&5C,&A3,&45,&59
            .byte &B7,&2E,&0D,&23,&5B,&B5,&54,&78
            .byte &20,&89,&23,&97,&20,&7B,&23,&58
            .byte &41,&AC,&2E,&B6,&A4,&43,&55,&52
            .byte &BD,&A0,&64,&A4,&AE,&9D,&E4,&E2
            .byte &A8,&20,&8A,&BB,&DE,&2C,&8A,&DD
            .byte &E5,&2C,&49,&4D,&DB,&53,&99,&4C
            .byte &59,&2C,&4F,&BD,&A3,&89,&C9,&4C
            .byte &8C,&2E,&89,&60,&20,&64,&20,&49
            .byte &A4,&CC,&4B,&45,&9E,&19,&20,&42
            .byte &A2,&41,&9E,&AE,&43,&AD,&44,&2C
            .byte &57,&E2,&BF,&9E,&C1,&B9,&2C,&57
            .byte &BB,&D3,&20,&49,&A4,&B8,&55,&44
            .byte &BF,&A0,&6D,&42,&CB,&F1,&20,&02
            .byte &7E,&8A,&1E,&A9,&B1,&A0,&6D,&89
            .byte &23,&4B,&99,&27,&A4,&BE,&8F,&7B
            .byte &AE,&4D,&53,&2E,&0D,&23,&5B,&7A
            .byte &89,&C5,&7A,&B4,&D7,&20,&7B,&89
            .byte &97,&2E,&CC,&50,&B7,&07,&49,&45
            .byte &A4,&BF,&EC,&43,&54,&99,&20,&89
            .byte &23,&4B,&99,&20,&7B,&23,&58,&41
            .byte &AC,&27,&A4,&0C,&E7,&20,&AB,&18
            .byte &4E,&2C,&48,&AC,&47,&20,&6E,&89
            .byte &47,&AB,&59,&2C,&B8,&B3,&9D,&64
            .byte &53,&2E,&76,&89,&5F,&20,&49,&A4
            .byte &89,&AE,&43,&AD,&A0,&C1,&4F,&A3
            .byte &4C,&BC,&44,&99,&20,&B5,&54,&2E
            .byte &0D,&23,&5B,&7A,&A1,&57,&49,&44
            .byte &9D,&63,&7A,&89,&97,&2E,&A1,&53
            .byte &C5,&D7,&20,&C1,&4F,&A3,&D4,&45
            .byte &A4,&50,&AE,&B0,&C7,&4C,&A2,&BB
            .byte &44,&BF,&9E,&8F,&89,&D5,&54,&C2
            .byte &A7,&7B,&53,&E5,&9D,&53,&B1,&50
            .byte &53,&2E,&0D,&23,&5B,&7A,&89,&57
            .byte &49,&44,&9D,&43,&B9,&8D,&B9,&2C
            .byte &1C,&49,&9A,&4C,&A2,&D4,&9F,&6E
            .byte &6F,&42,&A2,&A1,&62,&9D,&D4,&9A
            .byte &2D,&53,&B5,&52,&43,&9D,&5C,&20
            .byte &43,&AC,&EE,&9F,&55,&C4,&AA,&B8
            .byte &8C,&2E,&0D,&23,&5B,&8F,&89,&AF
            .byte &A0,&7B,&89,&57,&49,&44,&9D,&43
            .byte &B9,&8D,&B9,&2E,&A1,&46,&D4,&9A
            .byte &20,&7B,&B8,&F4,&52,&A4,&4C,&BC
            .byte &44,&A4,&76,&89,&94,&41,&D5,&BD
            .byte &2C,&8A,&A1,&53,&C5,&D7,&20,&C1
            .byte &4F,&A3,&49,&A4,&C6,&9F,&7A,&89
            .byte &5D,&20,&64,&2E,&0D,&23,&5B,&7A
            .byte &A1,&57,&CD,&4C,&20,&46,&55,&52
            .byte &4E,&C9,&AD,&A0,&53,&B6,&54,&99
            .byte &20,&6A,&2C,&44,&B5,&DA,&9D,&47
            .byte &CB,&5A,&E0,&2C,&6D,&46,&0A,&48
            .byte &9C,&41,&DA,&9D,&42,&D6,&D5,&4F
            .byte &20,&43,&B4,&02,&A4,&8A,&41,&9E
            .byte &45,&C3,&43,&07,&49,&43,&20,&46
            .byte &02,&9D,&6D,&50,&CB,&53,&B0,&43
            .byte &20,&BE,&C7,&2E,&0D,&23,&5B,&7A
            .byte &A1,&4C,&AE,&DC,&2C,&1C,&49,&9A
            .byte &20,&4B,&B6,&43,&AD,&4E,&2E,&57
            .byte &BB,&B1,&2C,&AF,&D6,&CD,&20,&B0
            .byte &C3,&A4,&BE,&BD,&A3,&89,&64,&A4
            .byte &8A,&43,&B3,&43,&AB,&54,&9D,&53
            .byte &B1,&50,&A4,&4C,&BC,&A0,&19,&20
            .byte &76,&A1,&53,&C5,&D7,&2C,&1E,&A9
            .byte &B1,&A0,&C1,&B9,&2E,&0D,&23,&5B
            .byte &7A,&A1,&55,&B0,&4C,&B6,&A2,&6A
            .byte &2E,&56,&AE,&49,&9B,&20,&BE,&E8
            .byte &C3,&58,&20,&C5,&D3,&A9,&B7,&2C
            .byte &6D,&4E,&D6,&45,&A4,&81,&C7,&4C
            .byte &20,&AF,&A0,&7A,&22,&4F,&C5,&B0
            .byte &43,&22,&2C,&1B,&5A,&5A,&2C,&43
            .byte &4C,&AC,&4B,&20,&8A,&E9,&A7,&49
            .byte &E8,&AB,&53,&D0,&BD,&4C,&59,&2E
            .byte &F7,&B1,&A3,&47,&41,&5A,&99,&20
            .byte &8F,&89,&22,&23,&CF,&47,&B6,&C7
            .byte &20,&57,&0A,&ED,&C5,&B0,&43,&20
            .byte &B8,&AA,&45,&4F,&20,&C0,&CF,&4F
            .byte &20,&0E,&A9,&4B,&A4,&C5,&D3,&A9
            .byte &45,&22,&2C,&5C,&20,&BF,&43,&49
            .byte &44,&9D,&49,&9F,&B4,&A4,&EE,&20
            .byte &7F,&20,&D0,&47,&4E,&49,&46,&49
            .byte &43,&AC,&43,&45,&2E,&0D,&23,&5B
            .byte &7A,&A1,&53,&50,&F6,&49,&9B,&20
            .byte &50,&AC,&07,&A2,&6D,&57,&E2,&44
            .byte &2D,&50,&AC,&CD,&C3,&A0,&64,&53
            .byte &2E,&A1,&56,&AE,&4E,&C9,&AD,&44
            .byte &2C,&50,&A9,&9D,&CC,&DA,&9D,&49
            .byte &A4,&DD,&D1,&B1,&A0,&7A,&89,&43
            .byte &AF,&07,&9D,&7B,&89,&6A,&20,&8A
            .byte &4F,&43,&43,&55,&EC,&45,&A4,&4D
            .byte &55,&D3,&20,&7B,&89,&94,&41,&AB
            .byte &41,&2E,&0D,&23,&5B,&7E,&89,&DD
            .byte &05,&A3,&4C,&8C,&99,&2E,&B8,&F4
            .byte &52,&A4,&4C,&BC,&A0,&76,&89,&46
            .byte &DD,&B9,&A4,&6F,&8A,&42,&CD,&13
            .byte &2E,&0D,&23,&5B,&7A,&A1,&50,&0A
            .byte &EF,&DC,&57,&41,&A2,&7E,&89,&46
            .byte &02,&53,&9F,&46,&DD,&B9,&2E,&89
            .byte &5E,&20,&64,&20,&B4,&A4,&65,&A4
            .byte &76,&56,&AE,&49,&9B,&20,&6A,&53
            .byte &2E,&0D,&23,&5B,&8F,&89,&AF,&A0
            .byte &7B,&89,&50,&0A,&EF,&DC,&57,&41
            .byte &A2,&7E,&89,&46,&02,&53,&9F,&46
            .byte &DD,&B9,&2E,&0D,&23,&5B,&7E,&89
            .byte &19,&EA,&A3,&4C,&8C,&99,&2E,&53
            .byte &B1,&50,&A4,&4C,&BC,&A0,&67,&20
            .byte &76,&89,&94,&42,&CD,&13,&2E,&46
            .byte &55,&52,&8B,&A3,&C7,&B3,&47,&20
            .byte &89,&4C,&8C,&99,&20,&76,&89,&5F
            .byte &2C,&5C,&20,&C5,&4B,&9D,&B5,&9F
            .byte &89,&53,&B4,&50,&9D,&7B,&A1,&53
            .byte &C5,&D7,&20,&C1,&B9,&2E,&0D,&23
            .byte &5B,&8F,&89,&46,&41,&A3,&AF,&A0
            .byte &7B,&89,&19,&EA,&A3,&4C,&8C,&99
            .byte &20,&B5,&54,&78,&20,&A1,&53,&C5
            .byte &D7,&2C,&57,&E2,&BF,&9E,&C1,&B9
            .byte &2E,&A1,&4D,&B7,&EF,&47,&9D,&7E
            .byte &89,&C1,&4F,&A3,&AB,&FD,&A4,&22
            .byte &26,&D8,&49,&56,&B2
L6349:      .byte &9D,&4B,&45,&04,&20,&B5,&54,&26
            .byte &22,&2E,&0D,&23,&5B,&7A,&A1,&44
            .byte &C9,&55,&C6,&A0,&42,&E0,&6A,&2C
            .byte &15,&B8,&A2,&8A,&42,&41,&AB,&2E
            .byte &5C,&A3,&C8,&4F,&54,&53,&B1,&50
            .byte &A4,&AB,&53,&B3,&B2,&9D,&7E,&89
            .byte &46,&DD,&B9,&D5,&AE,&44,&53,&2E
            .byte &76,&89,&5E,&20,&8B,&52,&9D,&49
            .byte &A4,&A1,&43,&19,&D5,&AE,&A0,&C1
            .byte &B9,&2E,&0D,&23,&5B,&7A,&A1,&43
            .byte &BB,&4C,&44,&27,&A4,&42,&E0,&6A
            .byte &2E,&89,&64,&A4,&AE,&9D,&1C,&49
            .byte &9A,&4C,&A2,&BF,&43,&B9,&41,&B1
            .byte &A0,&6D,&EC,&43,&54,&55,&AB,&A4
            .byte &7B,&B1,&44,&44,&A2,&08,&AE,&A4
            .byte &8A,&A1,&53,&C5,&D7,&20,&08,&A0
            .byte &49,&A4,&50,&12,&AD,&A0,&41,&47
            .byte &41,&A9,&53,&9F,&89,&5F,&20,&64
            .byte &2E,&A1,&AB,&A0,&47,&DD,&53,&53
            .byte &A2,&C1,&4F,&A3,&4D,&AE,&4B,&45
            .byte &A0,&22,&23,&C2,&A2,&23,&43,&19
            .byte &D5,&AE,&44,&22,&20,&CC,&4B,&45
            .byte &A4,&19,&20,&89,&5E,&20,&64,&2E
            .byte &0D,&23,&5B,&7A,&89,&C5,&53,&B1
            .byte &A3,&42,&E0,&6A,&2E,&49,&9F,&49
            .byte &A4,&53,&50,&F6,&49,&9B,&20,&8A
            .byte &57,&CD,&4C,&20,&4C,&B6,&2E,&41
            .byte &9E,&45,&C3,&47,&AC,&9F,&46,&B5
            .byte &A3,&DB,&53,&B1,&A3,&08,&A0,&49
            .byte &A4,&DB,&53,&B6,&9C,&45,&A0,&CA
            .byte &58,&9F,&76,&A1,&C1,&4F,&A3,&7A
            .byte &89,&5E,&20,&64,&2E,&0D,&23,&5B
            .byte &7A,&A1,&4C,&AE,&DC,&2C,&CF,&4D
            .byte &4C,&A2,&4C,&B6,&2C,&57,&C7,&4B
            .byte &2D,&7A,&4C,&A9,&45,&9E,&43,&19
            .byte &D5,&AE,&44,&2E,&A1,&E1,&49,&4D
            .byte &A2,&C1,&4F,&A3,&4F,&43,&43,&55
            .byte &EC,&45,&A4,&89,&5D,&20,&64,&2E
            .byte &0D,&23,&5B,&7A,&A1,&53,&C5,&D7
            .byte &20,&C2,&A2,&43,&19,&D5,&AE,&44
            .byte &2C,&CF,&4D,&4C,&A2,&49,&D7,&D9
            .byte &A9,&41,&B1,&A0,&42,&A2,&89,&D4
            .byte &9A,&20,&57,&BB,&D3,&20,&43,&AB
            .byte &04,&A4,&7A,&A8,&52,&B5,&DE,&20
            .byte &47,&41,&50,&A4,&D2,&BF,&A3,&89
            .byte &C1,&4F,&A3,&76,&89,&5D,&2E,&0D
            .byte &23,&5B,&7A,&A1,&00,&44,&AA,&9E
            .byte &42,&41,&A8,&6A,&2E,&89,&53,&55
            .byte &B6,&9D,&49,&A4,&41,&9E,&F9,&43
            .byte &4C,&55,&D0,&56,&9D,&D3,&4F,&BE
            .byte &4C,&B2,&9D,&BE,&4C,&B5,&52,&2C
            .byte &53,&D2,&4B,&20,&A9,&76,&89,&46
            .byte &DD,&B9,&2C,&6D,&AF,&47,&C0,&BD
            .byte &A0,&CC,&50,&53,&2C,&A1,&8B,&52
            .byte &C5,&4C,&20,&C2,&57,&CD,&20,&C0
            .byte &E7,&20,&8A,&53,&E5,&9D,&C0,&8B
            .byte &A3,&F9,&50,&AF,&D0,&56,&9D,&23
            .byte &50,&C6,&55,&C1,&2D,&23,&56,&49
            .byte &43,&54,&B9,&49,&41,&9E,&03,&41
            .byte &50,&20,&44,&C9,&AD,&53,&21,&0D
            .byte &23,&5B,&8F,&89,&C2,&50,&20,&7B
            .byte &A1,&46,&D4,&9A,&20,&7B,&53,&B1
            .byte &50,&53,&2C,&43,&AE,&BD,&A0,&B5
            .byte &9F,&7B,&89,&4D,&B5,&BA,&41,&A9
            .byte &2E,&8B,&52,&9D,&49,&A4,&A1,&46
            .byte &AB,&0F,&20,&42,&AB,&45,&5A,&9D
            .byte &57,&BB,&D3,&20,&71,&4D,&A4,&76
            .byte &AF,&D4,&BD,&9E,&5C,&21,&0D,&23
            .byte &5B,&7E,&A1,&46,&D4,&9A,&20,&7B
            .byte &45,&AE,&A8,&A2,&53,&B1,&50,&53
            .byte &2C,&43,&AE,&BD,&A0,&B5,&9F,&7B
            .byte &89,&4D,&B5,&BA,&41,&A9,&2E,&0D
            .byte &23,&5B,&8F,&89,&D5,&54,&C2,&A7
            .byte &7B,&A1,&46,&D4,&9A,&20,&7B,&53
            .byte &B1,&50,&53,&2C,&F9,&D1,&56,&41
            .byte &B1,&A0,&6E,&89,&4D,&B5,&BA,&41
            .byte &A9,&78,&2E,&0D,&23,&5B,&7E,&A1
            .byte &53,&EC,&C0,&4C,&20,&75,&57,&41
            .byte &A2,&7E,&89,&78,&20,&7B,&89,&4D
            .byte &B5,&BA,&41,&A9,&2E,&0D,&23,&5B
            .byte &8F,&A1,&50,&CB,&B1,&41,&55,&20
            .byte &B4,&4C,&46,&20,&57,&41,&A2,&19
            .byte &20,&89,&4D,&B5,&BA,&41,&A9,&2E
            .byte &A1,&EA,&43,&55,&D4,&AE,&2C,&DA
            .byte &55,&9D,&D4,&9A,&20,&50,&55,&4C
            .byte &C6,&A4,&76,&89,&60,&2E,&0D,&23
            .byte &5B,&8F,&89,&5F,&AA,&9E,&E0,&47
            .byte &9D,&7B,&89,&50,&CB,&B1,&41,&55
            .byte &2E,&BB,&DE,&20,&42,&AC,&4B,&A4
            .byte &7B,&45,&AE,&A8,&20,&B8,&4F,&50
            .byte &20,&AC,&A2,&46,&55,&52,&8B,&A3
            .byte &D8,&FB,&AB,&53,&53,&2E,&46,&41
            .byte &A3,&76,&89,&60,&20,&5C,&20,&71
            .byte &20,&A1,&50,&55,&4C,&53,&99,&2C
            .byte &DA,&55,&9D,&D4,&9A,&2E,&0D,&23
            .byte &5B,&8F,&A1,&53,&C5,&D7,&20,&47
            .byte &DF,&54,&C2,&2C,&43,&55,&9F,&A9
            .byte &76,&89,&4D,&B5,&BA,&41,&A9,&2E
            .byte &A1,&DA,&55,&45,&2C,&CA,&7E,&D0
            .byte &47,&9E,&AB,&FD,&99,&3A,&22,&3C
            .byte &23,&C5,&4B,&9D,&23,&5C,&A3,&23
            .byte &57,&C9,&48,&20,&23,&48,&AA,&45
            .byte &3C,&22,&2C,&DB,&A9,&54,&A4,&76
            .byte &A1,&53,&C5,&D7,&20,&57,&CD,&4C
            .byte &2C,&43,&B3,&B8,&17,&43,&B1,&A0
            .byte &7B,&1C,&49,&F1,&2C,&6D,&A1,&42
            .byte &C0,&53,&A4,&14,&B2,&9D,&C6,&9F
            .byte &A9,&76,&89,&64,&2E,&0D,&23,&5B
            .byte &7A,&A1,&42,&AE,&AB,&9E,&72,&50
            .byte &0A,&53,&2C,&53,&F0,&0B,&5A,&45
            .byte &A0,&08,&54,&05,&45,&9E,&54,&57
            .byte &4F,&20,&42,&AC,&4B,&A4,&7B,&45
            .byte &AE,&A8,&20,&8A,&DF,&F1,&2E,&89
            .byte &E1,&B5,&4E,&A0,&49,&A4,&48,&AE
            .byte &A0,&8A,&55,&CA,&56,&AF,&2E,&0D
            .byte &23,&5B,&7E,&A1,&47,&C0,&53,&53
            .byte &A2,&53,&DD,&50,&9D,&4C,&BC,&44
            .byte &99,&20,&67,&20,&89,&4D,&B5,&BA
            .byte &41,&A9,&2E,&89,&BD,&DC,&CC,&B0
            .byte &7E,&49,&A4,&52,&49,&D3,&20,&8A
            .byte &47,&AB,&AF,&2E,&0D,&23,&5B,&7E
            .byte &A1,&47,&C0,&53,&53,&A2,&50,&CB
            .byte &B1,&41,&55,&20,&4F,&56,&AA,&53
            .byte &B4,&C1,&05,&A0,&42,&A2,&89,&01
            .byte &9A,&A2,&23,&97,&20,&7B,&23,&58
            .byte &41,&AC,&2E,&8B,&52,&9D,&AE,&9D
            .byte &D0,&47,&4E,&A4,&81,&4F,&8B,&52
            .byte &A4,&B4,&56,&9D,&08,&45,&9E,&48
            .byte &AA,&9D,&08,&46,&B9,&9D,&5C,&21
            .byte &0D,&23,&5B,&8F,&89,&D5,&54,&C2
            .byte &A7,&7B,&A1,&47,&C0,&53,&53,&A2
            .byte &53,&DD,&EA,&2E,&89,&47,&C0,&53
            .byte &A4,&48,&AA,&9D,&49,&A4,&57,&BC
            .byte &4B,&2C,&59,&CD,&DD,&A6,&8A,&A9
            .byte &54,&AA,&4D,&99,&C3,&A0,&6D,&42
            .byte &AE,&9D,&50,&B2,&43,&AD,&53,&2E
            .byte &0D,&23,&5B,&7E,&89,&11,&8F,&4C
            .byte &8C,&A4,&42,&AF,&BC,&A8,&20,&89
            .byte &23,&97,&20,&7B,&23,&58,&41,&AC
            .byte &2E,&89,&4C,&8C,&A4,&AE,&9D,&53
            .byte &50,&AE,&C6,&4C,&A2,&BD,&DC,&CC
            .byte &B1,&A0,&8A,&B8,&B3,&59,&2E,&0D
            .byte &23,&5B,&7A,&89,&01,&44,&53,&9F
            .byte &7B,&89,&11,&8F,&4C,&8C,&A4,&42
            .byte &AF,&BC,&A8,&20,&89,&23,&97,&20
            .byte &7B,&23,&58,&41,&AC,&2E,&89,&E1
            .byte &B5,&4E,&A0,&49,&A4,&48,&AE,&A0
            .byte &8A,&DF,&F1,&59,&2C,&8A,&EE,&20
            .byte &BD,&DC,&CC,&B0,&7E,&47,&DF,&57
            .byte &53,&2E,&0D,&23,&5B,&7A,&A1,&B8
            .byte &A9,&4B,&99,&20,&44,&B6,&D3,&2E
            .byte &89,&48,&AE,&A0,&94,&49,&A4,&BE
            .byte &56,&AA,&45,&A0,&6D,&DB,&4F,&4C
            .byte &A4,&7B,&B8,&41,&47,&4E,&AC,&9F
            .byte &D4,&F0,&49,&A0,&8A,&B8,&AF,&D3
            .byte &99,&20,&53,&D4,&F2,&2E,&89,&D0
            .byte &F1,&AF,&99,&20,&E4,&CD,&4C,&20
            .byte &4C,&99,&AA,&53,&2C,&44,&C9,&47
            .byte &55,&B8,&99,&4C,&59,&2C,&7A,&5C
            .byte &A3,&EE,&B8,&52,&E7,&53,&2E,&A8
            .byte &49,&A4,&C9,&98,&A1,&47,&E2,&A0
            .byte &50,&CB,&43,&9D,&76,&EC,&43,&4E
            .byte &49,&43,&21,&0D,&23,&5B,&8F,&89
            .byte &AF,&A0,&7B,&A1,&15,&B8,&A2,&DF
            .byte &FD,&2C,&42,&B5,&4E,&BF,&A0,&42
            .byte &A2,&44,&C0,&A9,&41,&47,&9D,&44
            .byte &B6,&43,&AD,&53,&2E,&76,&89,&5D
            .byte &20,&D4,&9D,&89,&11,&8F,&4C,&8C
            .byte &A4,&42,&AF,&BC,&A8,&20,&89,&23
            .byte &97,&20,&7B,&23,&58,&41,&AC,&2E
            .byte &0D,&23,&5B,&7E,&A1,&4C,&B3,&47
            .byte &2C,&15,&B8,&A2,&DF,&FD,&2E,&4F
            .byte &56,&AA,&47,&DF,&57,&9E,&75,&A4
            .byte &4C,&BC,&A0,&5D,&2C,&76,&A1,&DF
            .byte &A6,&7B,&43,&B3,&BF,&4D,&CA,&A0
            .byte &48,&9B,&B7,&2E,&8B,&49,&A3,&57
            .byte &E2,&44,&57,&B9,&4B,&20,&49,&A4
            .byte &DF,&54,&54,&99,&2C,&8B,&49,&A3
            .byte &1E,&A9,&54,&57,&B9,&4B,&20,&43
            .byte &BB,&50,&EA,&A0,&8A,&46,&CB,&4B
            .byte &99,&2C,&8A,&8B,&49,&A3,&66,&A4
            .byte &53,&C5,&53,&AD,&A0,&4F,&A3,&D5
            .byte &AE,&BF,&44,&2E,&0D,&23,&5B,&8F
            .byte &89,&B8,&AE,&9F,&7B,&A1,&4C,&B3
            .byte &47,&2C,&B8,&C0,&49,&9A,&20,&DF
            .byte &FD,&2C,&53,&55,&52,&46,&F6,&45
            .byte &A0,&6D,&AB,&A0,&15,&B8,&2E,&89
            .byte &DF,&41,&A0,&49,&A4,&42,&B5,&4E
            .byte &BF,&A0,&42,&A2,&0F,&B5,&4C,&44
            .byte &AA,&2D,&BB,&DE,&20,&44,&B6,&43
            .byte &AD,&53,&2C,&43,&55,&9F,&C8,&A3
            .byte &44,&C0,&A9,&41,&47,&9D,&50,&55
            .byte &52,&DB,&53,&B7,&2E,&0D,&23,&5B
            .byte &8F,&89,&D5,&54,&C2,&A7,&7B,&89
            .byte &88,&2E,&BB,&DE,&20,&6F,&8A,&5E
            .byte &2C,&89,&4B,&45,&04,&20,&97,&A4
            .byte &4F,&BD,&A3,&5C,&2C,&71,&4D,&99
            .byte &20,&76,&57,&B2,&D3,&20,&5C,&A3
            .byte &0C,&AA,&A2,&00,&BD,&21,&89,&74
            .byte &20,&73,&49,&A4,&76,&89,&5D,&2C
            .byte &57,&BB,&4C,&9D,&DF,&FD,&A4,&B8
            .byte &AB,&54,&D3,&20,&5F,&20,&8A,&60
            .byte &2E,&0D,&23,&5B,&7A,&A1,&4E,&AE
            .byte &DF,&57,&2C,&53,&B4,&44,&A2,&4C
            .byte &AC,&45,&2E,&57,&E7,&A0,&46,&DD
            .byte &57,&AA,&A4,&8A,&47,&C0,&53,&C6
            .byte &A4,&11,&B5,&52,&C9,&48,&20,&08
            .byte &54,&05,&45,&9E,&42,&AE,&9D,&43
            .byte &AE,&54,&2D,&54,&C0,&F1,&53,&2E
            .byte &0D,&23,&5B,&8F,&89,&AF,&A0,&7B
            .byte &89,&53,&B4,&44,&A2,&4C,&AC,&45
            .byte &2E,&89,&46,&DD,&57,&AA,&A4,&8A
            .byte &47,&C0,&53,&C6,&A4,&47,&DF,&A6
            .byte &54,&C7,&4C,&2C,&48,&AA,&45,&2E
            .byte &A1,&44,&C9,&55,&C6,&A0,&54,&C0
            .byte &F1,&20,&49,&A4,&56,&C9,&49,&DA
            .byte &9D,&76,&89,&5D,&2E,&0D,&23,&5B
            .byte &7E,&A1,&44,&C9,&55,&C6,&A0,&54
            .byte &C0,&F1,&2E,&89,&55,&C4,&AA,&47
            .byte &DF,&57,&A8,&20,&49,&A4,&A8,&49
            .byte &F1,&20,&8A,&46,&55,&D7,&20,&7B
            .byte &A8,&B9,&4E,&A2,&14,&AC,&54,&A4
            .byte &8A,&CA,&54,&54,&4C,&B7,&2C,&47
            .byte &55,&AE,&AC,&B1,&45,&A0,&76,&52
            .byte &49,&50,&20,&8A,&B8,&99,&2E,&0D
            .byte &23,&5B,&7E,&A1,&4E,&AE,&DF,&A6
            .byte &B8,&F4,&52,&57,&41,&A2,&57,&BB
            .byte &D3,&20,&4C,&BC,&44,&A4,&19,&20
            .byte &76,&89,&90,&A2,&50,&CB,&A9,&2C
            .byte &8A,&67,&20,&76,&89,&01,&B8,&A2
            .byte &47,&C0,&BD,&59,&AE,&44,&2E,&0D
            .byte &23,&5B,&7A,&A1,&08,&47,&47,&AE
            .byte &27,&A4,&ED,&BD,&4C,&3A,&A1,&54
            .byte &A9,&A2,&57,&E2,&BF,&9E,&53,&B4
            .byte &F1,&2C,&6D,&DF,&54,&54,&99,&20
            .byte &46,&DD,&B9,&D5,&AE,&44,&A4,&8A
            .byte &44,&D6,&50,&20,&64,&53,&2E,&A1
            .byte &08,&47,&47,&41,&A3,&53,&B6,&A4
            .byte &7A,&89,&43,&B9,&4E,&AA,&2C,&43
            .byte &DF,&53,&53,&C3,&47,&DC,&44,&2C
            .byte &8A,&48,&D9,&4D,&99,&20,&54,&55
            .byte &CA,&82,&4C,&59,&2E,&0D,&23,&5B
            .byte &7E,&A1,&57,&E2,&BF,&9E,&47,&AC
            .byte &47,&14,&AC,&4B,&20,&76,&89,&95
            .byte &2E,&A1,&AB,&44,&2D,&EE,&C6,&A0
            .byte &23,&D1,&50,&CC,&A9,&2C,&6D,&A1
            .byte &46,&C7,&53,&9D,&C3,&47,&20,&8A
            .byte &A1,&B8,&55,&46,&46,&45,&A0,&50
            .byte &AE,&DF,&9F,&E3,&49,&C3,&A0,&76
            .byte &BB,&A4,&14,&59,&57,&E2,&A0,&0F
            .byte &B5,&4C,&44,&AA,&2C,&FC,&18,&A4
            .byte &A1,&D5,&54,&54,&4C,&9D,&7B,&52
            .byte &D9,&2C,&8A,&EA,&AA,&A4,&8F,&5C
            .byte &2E,&0D,&23,&5C,&20,&D5,&AE,&A0
            .byte &89,&56,&0A,&9F,&EF,&E7,&99,&20
            .byte &95,&2C,&C8,&D7,&4F,&05,&A0,&42
            .byte &A2,&89,&23,&D1,&50,&CC,&A9,&2E
            .byte &89,&AC,&D3,&4F,&A3,&49,&A4,&D4
            .byte &46,&B1,&44,&2C,&89,&90,&20,&43
            .byte &B2,&43
L6B63:      .byte &AD,&A4,&7A,&89,&EF,&E7,&A4,&8A
            .byte &8B,&A2,&1A,&D7,&4F,&A6,&B5,&54
            .byte &2E,&53,&DD,&57,&4C,&59,&2C,&89
            .byte &95,&20,&4C,&BC,&BD,&A4,&89,&23
            .byte &C9,&4C,&8A,&7B,&23,&58,&41,&AC
            .byte &21,&5C,&20,&B4,&56,&9D,&B7,&D1
            .byte &50,&E0,&21,&5B,&46,&AB,&9D,&8F
            .byte &CB,&B8,&21,&0D,&23,&5B,&8F,&A1
            .byte &43,&C3,&AE,&99,&20,&7A,&89,&C8
            .byte &AB,&B8,&2E,&A1,&93,&46,&C7,&4C
            .byte &20,&D1,&53,&D1,&BF,&A4,&67,&20
            .byte &89,&53,&B1,&04,&20,&72,&64,&2C
            .byte &DF,&AE,&99,&20,&6D,&DB,&57,&AA
            .byte &21,&A1,&C0,&A9,&D5,&A6,&AE,&43
            .byte &A4,&A8,&52,&B5,&DE,&20,&89,&53
            .byte &50,&C0,&A2,&41,&D5,&BD,&2E,&89
            .byte &93,&A4,&44,&C9,&41,&EB,&BC,&A3
            .byte &A9,&76,&A1,&43,&AB,&56,&49,&43
            .byte &45,&2C,&46,&B9,&4D,&99,&20,&55
            .byte &C4,&AA,&E1,&B5,&4E,&A0,&52,&49
            .byte &56,&AA,&A4,&8A,&B8,&AB,&D6,&53
            .byte &2E,&0D,&23,&5B,&8F,&89,&D5,&54
            .byte &C2,&A7,&7B,&A1,&90,&99,&20,&B8
            .byte &F4,&52,&D1,&53,&9D,&DD,&4F,&4B
            .byte &99,&20,&B5,&9F,&B3,&76,&A1,&EA
            .byte &42,&DA,&9D,&42,&BC,&D3,&2E,&0D
            .byte &23,&5B,&7E,&A1,&EA,&42,&DA,&9D
            .byte &85,&8F,&89,&AF,&07,&AC,&43,&9D
            .byte &76,&A1,&53,&59,&53,&B1,&A7,&7B
            .byte &D1,&56,&B7,&2E,&7A,&89,&CF,&A7
            .byte &D4,&9A,&20,&7B,&89,&A9,&54,&AA
            .byte &49,&B9,&2C,&53,&B1,&50,&A4,&AE
            .byte &9D,&56,&C9,&49,&42,&C3,&2C,&43
            .byte &D4,&4D,&42,&99,&20,&19,&20,&89
            .byte &A9,&CA,&A3,&DF,&F1,&20,&64,&53
            .byte &2E,&0D,&23,&5B,&7E,&A1,&B8,&B3
            .byte &A2,&53,&43,&AB,&9D,&53,&DD,&EA
            .byte &2E,&89,&E1,&B5,&4E,&A0,&49,&A4
            .byte &46,&02,&A7,&8A,&EF,&46,&9D,&48
            .byte &AA,&45,&2C,&1B,&9F,&46,&55,&52
            .byte &8B,&A3,&19,&20,&89,&88,&20,&8B
            .byte &52,&9D,&AE,&9D,&DD,&4F,&53,&9D
            .byte &DF,&F1,&A4,&8A,&BB,&44,&BF,&9E
            .byte &50,&B6,&46,&C7,&4C,&53,&2E,&70
            .byte &5C,&2C,&89,&74,&20,&73,&BE,&56
            .byte &AA,&A4,&89,&56,&C7,&C3,&59,&2E
            .byte &0D,&23,&5B,&7E,&A1,&4C,&B3,&47
            .byte &20,&57,&E2,&BF,&9E,&4A,&45,&54
            .byte &F3,&2C,&F8,&8B,&A3,&78,&20,&7B
            .byte &57,&BB,&D3,&2C,&AE,&9D,&57,&BB
            .byte &B1,&2C,&53,&B1,&CD,&20,&C0,&E7
            .byte &99,&53,&2E,&89,&4A,&45,&54,&54
            .byte &A2,&B8,&AB,&54,&43,&AD,&A4,&B5
            .byte &9F,&4F,&BD,&A3,&89,&53,&BC,&2E
            .byte &0D,&23,&5B,&7A,&89,&53,&50,&AE
            .byte &C6,&4C,&A2,&BD,&DC,&CC,&B1,&A0
            .byte &11,&8F,&4C,&8C,&53,&2E,&76,&89
            .byte &5D,&2C,&89,&23,&97,&20,&7B,&23
            .byte &58,&41,&41,&9E,&AB,&F6,&AD,&A4
            .byte &A9,&76,&89,&53,&4B,&59,&2E,&60
            .byte &20,&7B,&5C,&20,&49,&A4,&A1,&53
            .byte &C5,&D7,&2C,&57,&E2,&BF,&9E,&53
            .byte &B4,&F1,&2C,&B6,&A4,&DF,&7B,&42
            .byte &DF,&4B,&45,&9E,&8A,&B6,&A4,&C1
            .byte &4F,&A3,&48,&AC,&47,&99,&20,&DD
            .byte &4F,&C6,&4C,&A2,&6E,&17,&B8,&A2
            .byte &48,&99
L6D75:      .byte &B7,&2E,&A1,&62,&9D,&48,&D9,&4D
            .byte &99,&20,&E6,&AC,&41,&B1,&A4,&6E
            .byte &57,&49,&A8,&A9,&2E,&0D,&23,&5B
            .byte &7E,&A1,&56,&41,&B8,&2C,&90,&FC
            .byte &04,&9F,&50,&CB,&A9,&2C,&5F,&20
            .byte &7B,&89,&73,&42,&B5,&C4,&AE,&59
            .byte &2E,&44,&12,&9F,&BF,&56,&E7,&A4
            .byte &FC,&02,&4C,&20,&8A,&44,&AE,&9F
            .byte &41,&42,&B5,&9F,&89,&4C,&8C,&53
            .byte &D1,&EA,&2C,&53,&ED,&57,&AA,&99
            .byte &20,&5C,&20,&6D,&A1,&46,&A9,&45
            .byte &2C,&10,&B6,&9D,&DB,&57,&44,&AA
            .byte &2E,&46,&C0,&E7,&20,&54,&AB,&B7
            .byte &2C,&C2,&4F,&20,&53,&C5,&D7,&20
            .byte &76,&43,&D4,&4D,&42,&2C,&AE,&43
            .byte &20,&8B,&49,&A3,&42,&AE,&9D,&D4
            .byte &4D,&42,&A4,&76,&89,&E1,&B5,&C4
            .byte &2E,&0D,&23,&5B,&7E,&A1,&50,&CB
            .byte &A9,&3A,&57,&49,&BF,&2C,&11,&8F
            .byte &8A,&90,&FC,&04,&54,&2E,&76,&89
            .byte &60,&20,&49,&A4,&A1,&4E,&AE,&DF
            .byte &A6,&43,&C0,&57,&4C,&57,&41,&A2
            .byte &4C,&BC,&44,&99,&20,&A9,&76,&89
            .byte &74,&20,&C8,&AB,&B8,&2E,&89,&47
            .byte &41,&C3,&A4,&55,&D8,&E2,&9F,&0E
            .byte &59,&2C,&1C,&B6,&54,&4C,&9D,&14
            .byte &AC,&54,&A4,&8A,&DA,&4F,&A6,&8B
            .byte &A7,&F6,&DF,&53,&A4,&89,&4C,&8C
            .byte &2E,&0D,&2E,&0D,&2E,&0D,&00,&E0
            .byte &36,&83,&36,&02,&35,&83,&37,&00
            .byte &38,&82,&36,&00
L6E69:      .byte &3B,&01,&37,&02,&3B,&03,&38,&04
            .byte &3B,&05,&3B,&06,&37,&87,&37,&00
            .byte &3B,&01,&38,&02,&38,&03,&3A,&04
            .byte &3B,&05,&3B,&06,&38,&87,&38,&00
            .byte &3B,&01,&39,&02,&3B,&03,&39,&04
            .byte &3C,&05,&3B,&06,&38,&87,&39,&00
            .byte &38,&01,&38,&02,&39,&03,&3B,&04
            .byte &39,&05,&38,&06,&38,&87,&38,&00
            .byte &3D,&86,&3A,&01,&3C,&02,&3F,&03
            .byte &3E,&89,&94,&00,&40,&01,&42,&82
            .byte &3D,&00,&41,&01,&43,&83,&3D,&04
            .byte &CF,&87,&3E,&05,&CF,&86,&3F,&00
            .byte &3E,&81,&44,&00,&3F,&81,&45,&00
            .byte &42,&81,&46,&00,&43,&81,&48,&00
            .byte &44,&82,&47,&02,&48,&83,&46,&00
            .byte &45,&83,&47,&00,&92,&03,&93,&04
            .byte &D5,&85,&91,&80,&7F,&81,&7E,&81
            .byte &AF,&00,&88,&02,&4E,&84,&89,&00
            .byte &89,&03,&4D,&04,&52,&85,&88,&00
            .byte &8B,&02,&50,&03,&DE,&04,&51,&85
            .byte &8A,&00,&51,&03,&4F,&85,&8B,&00
            .byte &54,&01,&50,&05,&90,&07,&4F,&83
            .byte &8B,&00,&8D,&02,&53,&03,&89,&04
            .byte &8E,&05,&8C,&87,&4E,&00,&8E,&02
            .byte &8A,&03,&52,&04,&8F,&05,&8D,&86
            .byte &DE,&00,&97,&01,&51,&03,&90,&05
            .byte &97,&87,&8B,&00,&97,&01,&88,&02
            .byte &8C,&04,&97,&86,&89,&00,&B8,&01
            .byte &63,&02,&57,&03,&62,&06,&64,&87
            .byte &61,&01,&64,&02,&58,&03,&56,&06
            .byte &65,&87,&63,&01,&65,&02,&DC,&03
            .byte &57,&06,&66,&87,&64,&01,&67,&02
            .byte &5E,&03,&DC,&06,&5B,&87,&66,&00
            .byte &6B,&81,&CF,&00,&5E,&02,&93,&03
            .byte &67,&85,&59,&00,&67,&03,&68,&85
            .byte &66,&00,&68,&03,&6B,&85,&69,&01
            .byte &5B,&03,&59,&87,&67,&00,&6A,&02
            .byte &6B,&84,&69,&00,&63,&02,&6A,&84
            .byte &64,&00,&62,&02,&63,&84,&56,&01
            .byte &61,&02,&56,&86,&63,&00,&56,&01
            .byte &60,&02,&64,&03,&61,&04,&57,&05
            .byte &62,&86,&6A,&00,&57,&01,&6A,&02
            .byte &65,&03,&63,&04,&58,&05,&56,&06
            .byte &69,&87,&60,&00,&58,&01,&69,&02
            .byte &66,&03,&64,&04,&DC,&05,&57,&06
            .byte &68,&87,&6A,&00,&DC,&01,&68,&02
            .byte &67,&03,&65,&04,&59,&05,&58,&06
            .byte &5C,&87,&69,&00,&59,&01,&5C,&02
            .byte &5B,&03,&66,&04,&5E,&05,&DC,&87
            .byte &68,&00,&66,&01,&5D,&02,&5C,&03
            .byte &69,&04,&67,&05,&65,&87,&6B,&00
            .byte &65,&01,&6B,&02,&68,&03,&6A,&04
            .byte &66,&05,&64,&06,&5D,&87,&5F,&00
            .byte &64,&01,&5F,&02,&69,&03,&60,&04
            .byte &65,&05,&63,&86,&6B,&00,&69,&01
            .byte &5A,&02,&5D,&03,&5F,&04,&68,&85
            .byte &6A,&01,&98,&84,&80,&87,&76,&86
            .byte &7E,&84,&70,&01,&6F,&03,&71,&86
            .byte &7A,&00,&72,&82,&70,&01,&71,&82
            .byte &73,&03,&72,&84,&81,&01,&75,&82
            .byte &76,&00,&74,&06,&80,&87,&7A,&00
            .byte &6D,&02,&78,&83,&74,&04,&78,&87
            .byte &80,&01,&7F,&02,&79,&03,&76,&87
            .byte &77,&03,&78,&86,&7B,&00,&75,&85
            .byte &70,&00,&79,&02,&7C,&83,&7F,&03
            .byte &7B,&86,&7D,&00,&7E,&85,&7C,&00
            .byte &4B,&01,&7D,&85,&6E,&01,&4A,&02
            .byte &7B,&85,&78,&01,&6C,&04,&77,&85
            .byte &75,&07,&73,&89,&82,&08,&81,&89
            .byte &DD,&01,&84,&83,&D5,&00,&83,&81
            .byte &85,&00,&84,&83,&87,&04,&87,&87
            .byte &D4,&08,&85,&89,&86,&00,&55,&01
            .byte &4D,&02,&89,&03,&D7,&04,&8C,&86
            .byte &4E,&00,&8C,&01,&4E,&02,&52,&03
            .byte &88,&04,&8D,&05,&55,&87,&4D,&00
            .byte &8F,&01,&DE,&02,&8B,&03,&53,&04
            .byte &90,&05,&8E,&86,&4F,&00,&90,&01
            .byte &4F,&02,&51,&03,&8A,&04,&54,&05
            .byte &8F,&06,&50,&87,&DE,&00,&97,&01
            .byte &89,&02,&8D,&03,&55,&04,&97,&05
            .byte &97,&06,&52,&87,&88,&00,&97,&01
            .byte &52,&02,&8E,&03,&8C,&04,&97,&05
            .byte &97,&06,&53,&87,&89,&00,&97,&01
            .byte &53,&02,&8F,&03,&8D,&04,&97,&05
            .byte &97,&06,&8A,&87,&52,&00,&97,&01
            .byte &8A,&02,&90,&03,&8E,&04,&97,&05
            .byte &97,&06,&8B,&87,&53,&00,&97,&01
            .byte &8B,&02,&54,&03,&8F,&04,&97,&05
            .byte &97,&06,&51,&87,&8A,&01,&93,&02
            .byte &92,&86,&49,&01,&49,&02,&D5,&03
            .byte &91,&87,&93,&00,&91,&02,&49,&03
            .byte &5B,&84,&92,&88,&3D,&81,&CD,&80
            .byte &A8,&81,&55,&00,&6C,&81,&DC,&63
            .byte &9A,&84,&AF,&62,&99,&83,&9B,&02
            .byte &9A,&03,&9C,&E9,&9F,&02,&9B,&83
            .byte &9D,&60,&9E,&02,&9C,&88,&A2,&E1
            .byte &9D,&04,&A1,&05,&A0,&E8,&9B,&86
            .byte &9F,&87,&9F,&02,&A3,&09,&9D,&88
            .byte &A7,&02,&A4,&83,&A2,&01,&A9,&02
            .byte &A5,&83,&A3,&01,&AA,&02,&A6,&83
            .byte &A4,&01,&AB,&83,&A5,&02,&A8,&89
            .byte &A2,&61,&96,&83,&A7,&00,&A4,&E1
            .byte &AC,&00,&A5,&E1,&AD,&00,&A6,&E1
            .byte &AE,&E0,&A9,&E0,&AA,&E0,&AB,&00
            .byte &4C,&07,&99,&89,&B0,&08,&AF,&89
            .byte &B1,&02,&B2,&88,&B0,&03,&B1,&86
            .byte &B3,&01,&B4,&85,&B2,&00,&B3,&01
            .byte &B7,&02,&B6,&83,&B5,&82,&B4,&83
            .byte &B4,&00,&B4,&03,&B9,&86,&B8,&01
            .byte &56,&85,&B7,&04,&B7,&87,&BA,&01
            .byte &BC,&03,&BB,&84,&B9,&82,&BA,&00
            .byte &BA,&81,&BD,&00,&BC,&01,&C5,&03
            .byte &BE,&87,&C4,&01,&C4,&02,&BD,&86
            .byte &C5,&00,&C7,&01,&CB,&03,&C0,&85
            .byte &C6,&00,&C6,&02,&BF,&03,&C1,&04
            .byte &C7,&85,&C2,&00,&C2,&02,&C0,&E3
            .byte &D6,&00,&C3,&01,&C1,&02,&C6,&04
            .byte &C4,&86,&C0,&01,&C2,&02,&C4,&86
            .byte &C6,&00,&BE,&01,&C6,&02,&C5,&03
            .byte &C3,&04,&BD,&06,&C7,&87,&C2,&00
            .byte &BD,&01,&C7,&03,&C4,&05,&BE,&87
            .byte &C6,&00,&C4,&01,&C0,&02,&C7,&03
            .byte &C2,&04,&C5,&05,&C3,&06,&BF,&87
            .byte &C1,&00,&C5,&01,&BF,&03,&C6,&05
            .byte &C4,&87,&C0,&02,&C9,&88,&CB,&02
            .byte &CA,&03,&C8,&88,&CC,&03,&C9,&88
            .byte &CD,&00,&BF,&02,&CC,&89,&C8,&00
            .byte &95,&02,&CD,&03,&CB,&89,&C9,&00
            .byte &95,&02,&CE,&03,&CC,&89,&CA,&02
            .byte &CF,&83,&CD,&00,&5A,&02,&D0,&03
            .byte &CE,&06,&41,&07,&40,&88,&DF,&02
            .byte &D1,&83,&CF,&02,&D2,&83,&D0,&00
            .byte &D3,&83,&D1,&01,&D2,&84,&D4,&01
            .byte &D3,&82,&86,&08,&92,&89,&83,&E2
            .byte &C1,&02,&88,&85,&D8,&02,&D7,&85
            .byte &D9,&02,&D8,&83,&DA,&02,&D9,&83
            .byte &DB,&82,&DA,&10,&98,&01,&66,&02
            .byte &59,&03,&58,&06,&67,&87,&65,&02
            .byte &DE,&88,&82,&00,&8A,&02,&4F,&03
            .byte &DD,&04,&8B,&85,&53,&08,&94,&89
            .byte &CF,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&FF
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
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
L736F:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &08,&07,&06,&44,&04,&7B,&72,&00
            .byte &00
L7400:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
L740A:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
L7414:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00
L741E:      .byte &01
L741F:      .byte &00
L7420:      .byte &00
L7421:      .byte &00
L7422:      .byte &00
L7423:      .byte &00
L7424:      .byte &00
L7425:      .byte &00
L7426:      .byte &00
L7427:      .byte &00
L7428:      .byte &00
L7429:      .byte &00,&00,&00,&00,&00,&00,&00,&00
L7431:      .byte &00
L7432:      .byte &00
L7433:      .byte &00
L7434:      .byte &00
L7435:      .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&00
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
L74CC:      .byte &00,&00,&55,&45,&00,&04,&04,&03
            .byte &44,&07,&00,&00,&00,&45,&20,&34
            .byte &34,&00,&45,&04,&10,&00,&34,&04
            .byte &34,&04,&20,&04,&00,&24,&34,&06
            .byte &20,&B4,&05,&05,&05,&10,&20,&05
            .byte &00,&00
L74F6:      .byte &00,&00,&34,&D6
L74FA:      .byte &AC
L74FB:      .byte &EA
L74FC:      .byte &FF
L74FD:      .byte &02
L74FE:      .byte &35
L74FF:      .byte &27
L7500:      .byte &12
L7501:      .byte &6A,&AD,&AB
L7504:      .byte &22
L7505:      .byte &E1
L7506:      .byte &0D
L7507:      .byte &EC
L7508:      .byte &35
L7509:      .byte &76
L750A:      .byte &E2
L750B:      .byte &47
L750C:      .byte &E3
L750D:      .byte &C9
L750E:      .byte &FF
L750F:      .byte &B6
L7510:      .byte &DF
L7511:      .byte &70
L7512:      .byte &9E
L7513:      .byte &01
L7514:      .byte &6E
L7515:      .byte &24
L7516:      .byte &AE
L7517:      .byte &69,&A1,&91,&83
L751B:      .byte &3D
L751C:      .byte &98
L751D:      .byte &B5,&00,&00
L7520:      .byte &00,&00,&1F,&75,&76,&77,&78,&44
            .byte &42,&41,&50,&79,&7A,&1F,&43,&47
            .byte &6A,&7B
L7532:      .byte &55,&6B,&79
L7535:      .byte &3F,&6C,&7C,&7D,&7E,&45,&7F,&80
            .byte &6D,&49,&48,&81,&46,&1F,&39,&1F
L7545:      .byte &3A,&1F,&6F,&00,&00,&00,&00,&00
            .byte &00,&00,&00,&00,&00,&00,&00,&02
            .byte &03,&04,&05,&06,&06,&06,&06,&07
            .byte &08,&09,&0A,&0B,&0C,&0D,&0E,&0F
            .byte &10,&11,&12,&13,&14,&15,&16,&17
            .byte &18,&18,&18,&18,&18,&18,&18,&19
            .byte &19,&1B,&1A,&1A,&1A,&1C,&1E,&1D
            .byte &1D,&1D,&1D,&1D,&1D,&1D,&1F,&1F
            .byte &1F,&1F,&1F,&1F,&1F,&1F,&1F,&20
            .byte &21,&21,&21,&22,&22,&22,&22,&22
            .byte &22,&22,&22,&22,&22,&22,&22,&22
            .byte &22,&23,&24,&25,&26,&27,&28,&28
            .byte &28,&28,&29,&2A,&2A,&2A,&2A,&2B
            .byte &2B,&2B,&2B,&2B,&64,&2C,&65,&2D
            .byte &2E,&2F,&30
L75B8:      .byte &00,&31,&32,&33,&34,&35,&36,&37
            .byte &38,&39,&3A,&3B,&3B,&3B,&3C,&3D
            .byte &3E,&3F,&40,&41,&42,&43,&44,&45
            .byte &46,&47,&48,&48,&49,&4B,&4A,&4C
            .byte &4C,&4D,&4D,&4E,&4F,&50,&50,&50
            .byte &50,&63,&51,&51,&51,&51,&51,&51
            .byte &52,&52,&52,&53,&54,&54,&55,&56
            .byte &57,&57,&58,&59,&59,&5A,&5B,&62
            .byte &62,&62,&5C,&5D,&5E,&5F,&60,&61
            .byte &C4,&F9,&37,&B9,&CE,&74,&06,&2C
            .byte &81,&2B,&AA,&2E,&CA,&2F,&41,&57
            .byte &00,&09,&06,&C4,&AE,&78,&7C,&19
            .byte &42,&42,&4C,&4C,&59,&44,&44,&9B
            .byte &E9,&3C,&22,&56,&56,&60,&60,&A6
            .byte &A5,&8C,&C4,&C4,&2F,&06,&6A,&35
            .byte &3C,&8A,&3C,&4C,&96,&96,&C9,&96
            .byte &17,&18,&1F,&18,&19,&1E,&13,&1A
            .byte &1A,&1E,&1A,&14,&14,&12,&13,&22
            .byte &12,&1A,&18,&17,&19,&1F,&14,&1E
            .byte &1E,&1E,&1E,&1E,&18,&16,&16,&0C
            .byte &1F,&18,&1E,&1E,&1E,&1E,&1E,&17
            .byte &13,&21,&17,&1F,&12,&13,&1E,&1E
            .byte &18,&0C,&18,&13,&0C,&0C,&19,&0C
            .byte &00,&00,&00,&40,&61,&74,&74,&61
            .byte &63,&6B,&40,&62,&72,&65,&61,&6B
            .byte &40,&62,&6F,&61,&72,&64,&40,&63
            .byte &6C,&6F,&73,&65,&40,&63,&6C,&69
            .byte &6D,&62,&40,&64,&6F,&77,&6E,&40
            .byte &64,&72,&6F,&70,&40,&64,&69,&67
            .byte &40,&64,&72,&69,&6E,&6B,&40,&65
            .byte &61,&73,&74,&40,&65,&61,&74,&40
            .byte &65,&78,&61,&6D,&69,&6E,&65,&40
            .byte &66,&69,&6C,&6C,&40,&67,&65,&74
            .byte &40,&67,&6F,&40,&68,&65,&6C,&70
            .byte &40,&69,&6E,&76,&65,&6E,&74,&6F
            .byte &72,&79,&40,&6A,&75,&6D,&70,&40
            .byte &6B,&6E,&6F,&63,&6B,&40,&6B,&69
            .byte &6C,&6C,&40,&6B,&61,&74,&72,&6F
            .byte &73,&40,&6C,&6F,&6F,&6B,&40,&6C
            .byte &61,&6D,&70,&40,&6E,&6F,&72,&74
            .byte &68,&40,&6E,&65,&40,&6E,&6F,&72
            .byte &74,&68,&65,&61,&73,&74,&40,&6E
            .byte &77,&40,&6E,&6F,&72,&74,&68,&77
            .byte &65,&73,&74,&40,&6F,&70,&65,&6E
            .byte &40,&70,&75,&74,&40,&70,&6C,&61
            .byte &63,&65,&40,&71,&75,&69,&74,&40
            .byte &72,&65,&73,&74,&6F,&72,&65,&40
            .byte &72,&75,&62,&40,&73,&6F,&75,&74
            .byte &68,&40,&73,&65,&40,&73,&6F,&75
            .byte &74,&68,&65,&61,&73,&74,&40,&73
            .byte &77,&40,&73,&6F,&75,&74,&68,&77
            .byte &65,&73,&74,&40,&73,&69,&6E,&67
            .byte &40,&73,&65,&61,&72,&63,&68,&40
            .byte &73,&63,&6F,&72,&65,&40,&73,&74
            .byte &72,&61,&6E,&67,&6C,&65,&40,&73
            .byte &61,&76,&65,&40,&74,&61,&6B,&65
            .byte &40,&74,&68,&72,&6F,&77,&40,&75
            .byte &70,&40,&77,&65,&73,&74,&40,&77
            .byte &69,&73,&68,&40,&77,&61,&69,&74
            .byte &40,&77,&61,&76,&65,&40,&77,&65
            .byte &61,&72,&40,&73,&69,&74,&40,&6C
            .byte &69,&65,&40,&70,&72,&61,&79,&40
            .byte &0D,&40,&58,&40,&58,&40,&61,&6C
            .byte &63,&6F,&76,&65,&40,&62,&65,&67
            .byte &67,&61,&72,&40,&62,&6C,&61,&6E
            .byte &6B,&65,&74,&40,&62,&72,&61,&63
            .byte &65,&6C,&65,&74,&40,&62,&72,&6F
            .byte &6F,&63,&68,&40,&63,&68,&61,&69
            .byte &6E,&40,&63,&6C,&6F,&61,&6B,&40
            .byte &63,&6F,&69,&6E,&40,&63,&6F,&6D
            .byte &70,&61,&73,&73,&40,&64,&69,&61
            .byte &6D,&6F,&6E,&64,&40,&64,&6F,&6C
            .byte &6C,&40,&64,&72,&65,&73,&73,&65
            .byte &72,&40,&66,&6F,&6F,&64,&40,&67
            .byte &6C,&61,&73,&73,&65,&73,&40,&67
            .byte &6C,&6F,&76,&65,&73,&40,&67,&6F
            .byte &62,&6C,&65,&74,&40,&67,&75,&61
            .byte &72,&64,&40,&68,&61,&74,&40,&69
            .byte &6E,&67,&6F,&74,&40,&6C,&61,&6D
            .byte &70,&40,&6C,&65,&67,&67,&69,&6E
            .byte &67,&73,&40,&6C,&6F,&63,&6B,&65
            .byte &74,&40,&6D,&69,&74,&74,&65,&6E
            .byte &73,&40,&6E,&65,&63,&6B,&6C,&61
            .byte &63,&65,&40,&6F,&69,&6C,&40,&72
            .byte &69,&6E,&67,&40,&72,&75,&67,&40
            .byte &73,&61,&63,&6B,&69,&6E,&67,&40
            .byte &73,&68,&6F,&65,&73,&40,&73,&68
            .byte &6F,&76,&65,&6C,&40,&73,&6F,&61
            .byte &70,&40,&73,&6F,&63,&6B,&73,&40
            .byte &74,&61,&62,&6C,&65,&40,&74,&65
            .byte &6C,&65,&70,&72,&69,&6E,&74,&65
            .byte &72,&40,&74,&6F,&6F,&6C,&73,&68
            .byte &65,&64,&40,&75,&6D,&62,&72,&65
            .byte &6C,&6C,&61,&40,&77,&61,&74,&65
            .byte &72,&40,&77,&65,&6C,&6C,&40,&64
            .byte &6F,&6F,&72,&40,&6C,&75,&6C,&6C
            .byte &61,&62,&79,&40,&73,&6F,&6E,&67
            .byte &40,&73,&68,&69,&70,&40,&74,&6F
            .byte &77,&65,&72,&40,&74,&72,&65,&65
            .byte &40,&63,&6C,&69,&66,&66,&40,&6D
            .byte &6F,&75,&6E,&74,&61,&69,&6E,&40
            .byte &0D,&00,&00,&00,&40,&59,&4F,&55
            .byte &20,&41,&52,&45,&20,&40,&59,&4F
            .byte &55,&40,&4E,&4F,&52,&54,&48,&40
            .byte &53,&4F,&55,&54,&48,&40,&45,&41
            .byte &53,&54,&40,&57,&45,&53,&54,&40
            .byte &47,&55,&41,&52,&44,&20,&40,&53
            .byte &54,&52,&41,&4E,&47,&40,&43,&4F
            .byte &52,&52,&49,&44,&4F,&52,&20,&40
            .byte &57,&41,&4C,&4C,&40,&45,&58,&49
            .byte &54,&40,&57,&49,&4E,&44,&4F,&57
            .byte &40,&44,&4F,&57,&4E,&40,&4F,&50
            .byte &45,&4E,&40,&43,&4C,&4F,&53,&45
            .byte &40,&52,&4F,&4F,&4D,&40,&4C,&4F
            .byte &43,&4B,&45,&44,&40,&50,&52,&49
            .byte &53,&4F,&4E,&20,&43,&45,&4C,&4C
            .byte &40,&57,&49,&54,&48,&20,&40,&46
            .byte &52,&4F,&4D,&20,&40,&41,&42,&4F
            .byte &56,&45,&20,&40,&42,&45,&4C,&4F
            .byte &57,&20,&40,&53,&45,&45,&40,&4D
            .byte &4F,&55,&4E,&54,&41,&49,&4E,&20
            .byte &40,&46,&4F,&52,&45,&53,&54,&20
            .byte &40,&44,&41,&52,&4B,&40,&50,&41
            .byte &54,&48,&40,&54,&4F,&20,&40,&43
            .byte &41,&56,&45,&52,&4E,&40,&53,&49
            .byte &44,&45,&40,&54,&52,&45,&41,&53
            .byte &55,&52,&45,&20,&40,&49,&4E,&20
            .byte &40,&4F,&46,&20,&40,&43,&4C,&49
            .byte &46,&46,&40,&4D,&41,&5A,&45,&40
            .byte &4F,&4E,&20,&40,&41,&44,&56,&45
            .byte &4E,&54,&55,&52,&45,&40,&43,&4F
            .byte &50,&59,&52,&49,&47,&48,&54,&20
            .byte &28,&43,&29,&20,&31,&39,&38,&34
            .byte &40,&54,&48,&41,&54,&20,&40,&4C
            .byte &45,&53,&53,&40,&47,&55,&4C,&4C
            .byte &59,&20,&40,&54,&52,&45,&4E,&43
            .byte &48,&40,&42,&45,&41,&43,&48,&20
            .byte &40,&54,&55,&4E,&4E,&45,&4C,&20
            .byte &40,&41,&57,&41,&59,&40,&48,&49
            .byte &4C,&4C,&40,&54,&48,&45,&20,&40
            .byte &41,&4E,&44,&20,&40,&54,&48,&45
            .byte &40,&41,&4E,&44,&40,&52,&49,&44
            .byte &40,&4F,&4E,&4C,&59,&20,&40,&41
            .byte &54,&20,&40,&57,&49,&4E,&44,&40
            .byte &54,&59,&50,&45,&40,&42,&41,&43
            .byte &4B,&20,&40,&57,&41,&54,&45,&52
            .byte &40,&46,&4C,&4F,&4F,&52,&20,&40
            .byte &53,&48,&49,&50,&40,&53,&41,&4E
            .byte &44,&40,&54,&4F,&57,&45,&52,&40
            .byte &4E,&27,&54,&20,&40,&49,&4E,&47
            .byte &40,&47,&48,&54,&40,&4F,&55,&53
            .byte &40,&49,&4F,&4E,&40,&45,&20,&40
            .byte &4E,&20,&40,&54,&20,&40,&44,&20
            .byte &40,&41,&20,&40,&59,&20,&40,&52
            .byte &20,&40,&53,&20,&40,&49,&20,&40
            .byte &57,&20,&40,&4D,&20,&40,&54,&48
            .byte &40,&49,&4E,&40,&45,&52,&40,&52
            .byte &45,&40,&41,&4E,&40,&48,&45,&40
            .byte &41,&52,&40,&45,&4E,&40,&54,&49
            .byte &40,&54,&45,&40,&41,&54,&40,&4F
            .byte &4E,&40,&48,&41,&40,&4F,&55,&40
            .byte &49,&54,&40,&45,&53,&40,&53,&54
            .byte &40,&4F,&52,&40,&4E,&54,&40,&48
            .byte &49,&40,&45,&41,&40,&56,&45,&40
            .byte &43,&4F,&40,&44,&45,&40,&52,&41
            .byte &40,&44,&4F,&40,&54,&4F,&40,&4C
            .byte &45,&40,&4E,&44,&40,&4D,&41,&40
            .byte &53,&45,&40,&41,&4C,&40,&46,&4F
            .byte &40,&49,&53,&40,&4E,&45,&40,&4C
            .byte &41,&40,&54,&41,&40,&45,&4C,&40
            .byte &49,&53,&40,&44,&49,&40,&53,&49
            .byte &40,&43,&41,&40,&55,&4E,&40,&43
            .byte &48,&40,&4C,&49,&40,&42,&4F,&40
            .byte &41,&4D,&40,&4C,&4C,&40,&50,&52
            .byte &40,&55,&4D,&40,&42,&4C,&40,&50
            .byte &4F,&40,&47,&45,&40,&4C,&4F,&40
            .byte &47,&48,&40,&52,&4F,&40,&45,&44
            .byte &40,&47,&52,&40,&4F,&4F,&40,&4E
            .byte &41,&40,&53,&4D,&40,&4F,&4D,&40
            .byte &45,&4D,&40,&49,&4C,&40,&4D,&50
            .byte &40,&48,&55,&40,&50,&45,&40,&50
            .byte &50,&40,&50,&49,&40,&48,&4F,&40
            .byte &4E,&4F,&40,&53,&41,&40,&51,&55
            .byte &40,&43,&4B,&40,&4D,&45,&40,&54
            .byte &59,&40,&41,&49,&40,&47,&4F,&40
            .byte &41,&43,&40,&41,&46,&40,&45,&49
            .byte &40,&45,&58,&40,&55,&54,&40,&4F
            .byte &47,&40,&53,&57,&40,&41,&44,&40
            .byte &53,&4C,&40,&41,&4B,&40,&4D,&4F
            .byte &40,&4D,&49,&40,&49,&52,&40,&53
            .byte &4F,&40,&45,&50,&40,&57,&45,&40
            .byte &47,&49,&40,&54,&52,&40,&42,&45
            .byte &40,&50,&48,&40,&41,&53,&40,&45
            .byte &45,&40,&45,&56,&40,&44,&52,&40
            .byte &53,&48,&40,&57,&48,&40,&46,&4C
            .byte &40,&55,&53,&40,&4F,&57,&40,&50
            .byte &4C,&40,&44,&55,&40,&44,&41,&40
            .byte &52,&55,&40,&49,&47,&40,&55,&50
            .byte &40,&42,&49,&40,&42,&55,&40,&42
            .byte &52,&40,&46,&52,&40,&50,&41,&40
            .byte &41,&59,&40,&0D
