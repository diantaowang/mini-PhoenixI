
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	20011100 	addi	at,zero,4352
   4:	20020020 	addi	v0,zero,32
   8:	2003ff00 	addi	v1,zero,-256
   c:	2004ffff 	addi	a0,zero,-1
  10:	20450000 	addi	a1,v0,0
  14:	20860000 	addi	a2,a0,0
  18:	20c70000 	addi	a3,a2,0
  1c:	00221822 	sub	v1,at,v0
  20:	00431020 	add	v0,v0,v1
  24:	00602021 	move	a0,v1
  28:	00662823 	subu	a1,v1,a2
  2c:	20010f0f 	addi	at,zero,3855
  30:	20021111 	addi	v0,zero,4369
  34:	00221824 	and	v1,at,v0
  38:	00222025 	or	a0,at,v0
  3c:	20011111 	addi	at,zero,4369
  40:	20020001 	addi	v0,zero,1
  44:	00411804 	sllv	v1,at,v0
  48:	00431806 	srlv	v1,v1,v0
  4c:	20011000 	addi	at,zero,4096
  50:	20021111 	addi	v0,zero,4369
  54:	20030013 	addi	v1,zero,19
  58:	00610804 	sllv	at,at,v1
  5c:	00621004 	sllv	v0,v0,v1
  60:	00211820 	add	v1,at,at
  64:	20011111 	addi	at,zero,4369
  68:	20021000 	addi	v0,zero,4096
  6c:	0022182a 	slt	v1,at,v0
  70:	20018001 	addi	at,zero,-32767
  74:	20028011 	addi	v0,zero,-32751
  78:	0022182a 	slt	v1,at,v0
  7c:	ac030000 	sw	v1,0(zero)
  80:	ac010004 	sw	at,4(zero)
  84:	20040004 	addi	a0,zero,4
  88:	ac820004 	sw	v0,4(a0)
  8c:	8c010000 	lw	at,0(zero)
  90:	8c020004 	lw	v0,4(zero)
  94:	8c830004 	lw	v1,4(a0)
  98:	00622020 	add	a0,v1,v0
  9c:	08000048 	j	120 <_start+0x120>
  a0:	00000000 	nop
	...
 120:	2001000b 	addi	at,zero,11
 124:	20020000 	addi	v0,zero,0

00000128 <_loop1>:
 128:	2021ffff 	addi	at,at,-1
 12c:	10200003 	beqz	at,13c <_end>
 130:	00411020 	add	v0,v0,at
 134:	0800004a 	j	128 <_loop1>
 138:	00000000 	nop

0000013c <_end>:
 13c:	0800004f 	j	13c <_end>
 140:	00000000 	nop
Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	000000fe 	0xfe
	...
