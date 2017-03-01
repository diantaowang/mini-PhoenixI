    .org 0x0
	.set noat
    .set noreorder
    .set nomacro
    .global _start
_start:
    addi $1,$0,0x1100	 # $1 = 0x00001100       
    addi $2,$0,0x0020	 # $2 = 0x00000020     
    addi $3,$0,0xff00    # $3 = 0xffffff00  
    addi $4,$0,0xffff    # $4 = 0xffffffff
    addi $5,$2,0x0000    # $5 = 0x00000020
    addi $6,$4,0x0000    # $6 = 0xffffffff
    addi $7,$6,0x0000 	 # $7 = 0xffffffff

    sub  $3,$1,$2	     # $3 = 0x000010E0
    add  $2,$2,$3        # $2 = 0x00001100
    addu $4,$3,$0        # $4 = 0x000010E0
    subu $5,$3,$6        # $5 = 0x000010E1
    addi $1,$0,0x0f0f 	 # $1 = 0x00000f0f
    addi $2,$0,0x1111  	 # $2 = 0x00001111
    and  $3,$1,$2        # $3 = 0x00000101
    or   $4,$1,$2        # $4 = 0x00001f1f

    addi $1,$0,0x1111    # $1 = 0x00001111
    addi $2,$0,0x0001    # $2 = 0s00000001
    sllv $3,$1,$2        # $3 = 0x00002222
    srlv $3,$3,$2        # $3 = 0x00001111
    
    addi $1,$0,0x1000    # $1 = 0x00001000
    addi $2,$0,0x1111    # $2 = 0x00001111
    addi $3,$0,19        # $3 = 19
    sllv $1,$1,$3        # $1 = 0x80000000
    sllv $2,$2,$3        # $2 = 0x88880000
    add  $3,$1,$1        # ov

    addi $1,$0,0x1111    # $1 = 0x00001111
    addi $2,$0,0x1000	 # $2 = 0x00001000
    slt  $3,$1,$2        # $3 = 0
    
    addi $1,$0,0x8001    # $1 = 0xffff8001
    addi $2,$0,0x8011    # $2 = 0xffff8011
    slt  $3,$1,$2        # $3 = 1

	sw   $3,0x0($0)      # 0x0 -> 0x1    
    sw   $1,0x4($0)      # 0x4 -> 0xffff8001
    addi $4,$0,0x4       # $4 = 0x4
    sw   $2,0x4($4)      # 0x8 -> 0xffff8011
    lw   $1,0x0($0)      # $1 = 0x1
    lw   $2,0x4($0)      # $2 = 0xffff8001
    lw   $3,0x4($4)      # $3 = 0xffff8011
    add  $4,$3,$2        # $4 = 0xffff0012 ;The pipeline is suspended for one clock cycle.
    j    0x120
    nop

    .org 0x120 
    addi $1,$0,0xb       # $1 = 0xb
    addi $2,$0,0x0       # $2 = 0x0

_loop1:
    addi $1,$1,-1
    beq  $1,$0,_end      # Using delay slot technology.
    add  $2,$2,$1
    j    _loop1          # $2 = 0x0037
    nop                  # $1 = 0x0

_end:
    j    _end
    nop
