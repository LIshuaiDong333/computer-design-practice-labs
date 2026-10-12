MAIN:
    lui  sp,0x10        # sp = 0x10 000 << 12 = 0x10000
    lui  s1,0xFFFFF     # s1 = 0xFFFFF000
    ori  t0,zero,5
    sw   t0,0x24(s1)
    jal  STAGE0

STAGE0:
    lw   t0,0x20(s1)
    sw   t0,0x00(s1)

STAGE0_LOOP:
    lw   t1,0x70(s1)
    andi t1,t1,3
    addi t2,zero,1
    bne  t1,t2,STAGE0
    jal  STAGE1

STAGE1:
    lw   s3,0x20(s1)
    sw   s3,0x00(s1)

STAGE1_LOOP:
    lw   t1,0x70(s1)
    andi t1,t1,3
    addi t2,zero,2
    bne  t1,t2,STAGE1_LOOP
    jal  STAGE2

STAGE2:
    lw   s3,0x20(s1)
    addi sp,sp,-32

STAGE2_GENERATE:
    addi t0,zero,8
    addi t1,zero,0
    addi s4,zero,0

GEN_RANDOM_NUM:
    srli t2,s3,31
    srli t3,s3,21
    srli t4,s3,1
    andi t5,s3,1

    xor  t2,t2,t3
    xor  t2,t2,t4
    xor  t2,t2,t5
    andi t2,t2,1

    slli s3,s3,1
    or   s3,s3,t2
    andi t6,s3,0xF
    add  t3,sp,t1
    sw   t6,0(t3)

    slli s4,s4,4
    or   s4,s4,t6

    addi t1,t1,4
    addi t0,t0,-1
    bne  t0,zero,GEN_RANDOM_NUM
    li   t6, 10000000        # 调整这个数值改变延时长短

DELAY_LOOP:
    addi t6, t6, -1
    bne  t6, zero, DELAY_LOOP

    sw   s4, 0(s1)

STAGE2_LOOP:
    lw   t1,0x70(s1)
    andi t1,t1,3
    addi t2,zero,3
    bne  t1,t2,STAGE2_GENERATE
    jal  STAGE3

STAGE3:
    addi t0,zero,0

OUT_LOOP:
    addi t1,zero,0

INNER_LOOP:
    add  t3,sp,t1
    addi t4,t3,4

    lw   t5,0(t3)
    lw   t6,0(t4)

    blt  t5,t6,BUBBLE_CONTINUE
    beq  t5,t6,BUBBLE_CONTINUE

    sw   t6,0(t3)
    sw   t5,0(t4)

BUBBLE_CONTINUE:
    addi t1,t1,4

    slli s7,t0,2
    add  s5,t1,s7
    addi s6,zero,28
    blt  s5,s6,INNER_LOOP

    addi t0,t0,1

    addi t2,zero,7
    blt  t0,t2,OUT_LOOP

SORT_DONE:
    addi t0,zero,1
    sw   t0,0x60(s1)

STAGE3_LOOP:
    lw   t1,0x70(s1)
    andi t1,t1,3
    bne  t1,zero,STAGE3_LOOP

    jal  STAGE4

STAGE4:
    addi s4,zero,0       # 清空显示寄存器
    addi t0,zero,8       # 循环8次
    addi t1,zero,0       # 地址偏移

PACK_SORTED_LOOP:
    add  t3,sp,t1
    lw   t6,0(t3)
    slli s4,s4,4
    or   s4,s4,t6
    addi t1,t1,4
    addi t0,t0,-1
    bne  t0,zero,PACK_SORTED_LOOP
    sw   s4,0(s1)
    addi sp,sp,32
END:
    jal  END
