	.text
	.file	"example3.c"
	.globl	test                    # -- Begin function test
	.p2align	4, 0x90
	.type	test,@function
test:                                   # @test
.Lfunc_begin0:
	.file	1 "/home/ubuntu/git/homework3_adrianoh/compilervec" "example3.c"
	.loc	1 9 0                   # example3.c:9:0
	.cfi_startproc
# %bb.0:                                # %entry
	#DEBUG_VALUE: test:a <- $rdi
	#DEBUG_VALUE: test:a <- $rdi
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:b <- $rsi
	xorl	%eax, %eax
.Ltmp0:
	#DEBUG_VALUE: test:i <- 0
	.p2align	4, 0x90
.LBB0_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 13 12 prologue_end    # example3.c:13:12
	movdqu	(%rsi,%rax), %xmm0
	movdqu	16(%rsi,%rax), %xmm1
	.loc	1 13 17 is_stmt 0       # example3.c:13:17
	paddb	%xmm0, %xmm0
	paddb	%xmm1, %xmm1
	.loc	1 13 10                 # example3.c:13:10
	movdqu	%xmm0, (%rdi,%rax)
	movdqu	%xmm1, 16(%rdi,%rax)
	.loc	1 13 12                 # example3.c:13:12
	movdqu	32(%rsi,%rax), %xmm0
	movdqu	48(%rsi,%rax), %xmm1
	.loc	1 13 17                 # example3.c:13:17
	paddb	%xmm0, %xmm0
	paddb	%xmm1, %xmm1
	.loc	1 13 10                 # example3.c:13:10
	movdqu	%xmm0, 32(%rdi,%rax)
	movdqu	%xmm1, 48(%rdi,%rax)
	.loc	1 13 12                 # example3.c:13:12
	movdqu	64(%rsi,%rax), %xmm0
	movdqu	80(%rsi,%rax), %xmm1
	.loc	1 13 17                 # example3.c:13:17
	paddb	%xmm0, %xmm0
	paddb	%xmm1, %xmm1
	.loc	1 13 10                 # example3.c:13:10
	movdqu	%xmm0, 64(%rdi,%rax)
	movdqu	%xmm1, 80(%rdi,%rax)
	.loc	1 13 12                 # example3.c:13:12
	movdqu	96(%rsi,%rax), %xmm0
	movdqu	112(%rsi,%rax), %xmm1
	.loc	1 13 17                 # example3.c:13:17
	paddb	%xmm0, %xmm0
	paddb	%xmm1, %xmm1
	.loc	1 13 10                 # example3.c:13:10
	movdqu	%xmm0, 96(%rdi,%rax)
	movdqu	%xmm1, 112(%rdi,%rax)
.Ltmp1:
	.loc	1 12 26 is_stmt 1       # example3.c:12:26
	subq	$-128, %rax
	cmpq	$65536, %rax            # imm = 0x10000
	jne	.LBB0_1
.Ltmp2:
# %bb.2:                                # %for.end
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 15 1                  # example3.c:15:1
	retq
.Ltmp3:
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 10.0.1 " # string offset=0
.Linfo_string1:
	.asciz	"example3.c"            # string offset=22
.Linfo_string2:
	.asciz	"/home/ubuntu/git/homework3_adrianoh/compilervec" # string offset=33
.Linfo_string3:
	.asciz	"test"                  # string offset=81
.Linfo_string4:
	.asciz	"a"                     # string offset=86
.Linfo_string5:
	.asciz	"unsigned char"         # string offset=88
.Linfo_string6:
	.asciz	"__uint8_t"             # string offset=102
.Linfo_string7:
	.asciz	"uint8_t"               # string offset=112
.Linfo_string8:
	.asciz	"b"                     # string offset=120
.Linfo_string9:
	.asciz	"i"                     # string offset=122
.Linfo_string10:
	.asciz	"long unsigned int"     # string offset=124
.Linfo_string11:
	.asciz	"__uint64_t"            # string offset=142
.Linfo_string12:
	.asciz	"uint64_t"              # string offset=153
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	48                      # DW_OP_lit0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
	.byte	1                       # Abbreviation Code
	.byte	17                      # DW_TAG_compile_unit
	.byte	1                       # DW_CHILDREN_yes
	.byte	37                      # DW_AT_producer
	.byte	14                      # DW_FORM_strp
	.byte	19                      # DW_AT_language
	.byte	5                       # DW_FORM_data2
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	16                      # DW_AT_stmt_list
	.byte	23                      # DW_FORM_sec_offset
	.byte	27                      # DW_AT_comp_dir
	.byte	14                      # DW_FORM_strp
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	2                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.ascii	"\227B"                 # DW_AT_GNU_all_call_sites
	.byte	25                      # DW_FORM_flag_present
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	4                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
	.byte	55                      # DW_TAG_restrict_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	7                       # Abbreviation Code
	.byte	22                      # DW_TAG_typedef
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	8                       # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                       # DWARF version number
	.long	.debug_abbrev           # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0xa7 DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0x43 DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string3          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	3                       # Abbrev [3] 0x3f:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string4          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
	.long	109                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x4e:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string8          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
	.long	109                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x5d:0xf DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string9          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	10                      # DW_AT_decl_line
	.long	148                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x6d:0x5 DW_TAG_restrict_type
	.long	114                     # DW_AT_type
	.byte	6                       # Abbrev [6] 0x72:0x5 DW_TAG_pointer_type
	.long	119                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x77:0xb DW_TAG_typedef
	.long	130                     # DW_AT_type
	.long	.Linfo_string7          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	24                      # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x82:0xb DW_TAG_typedef
	.long	141                     # DW_AT_type
	.long	.Linfo_string6          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0x8d:0x7 DW_TAG_base_type
	.long	.Linfo_string5          # DW_AT_name
	.byte	8                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	7                       # Abbrev [7] 0x94:0xb DW_TAG_typedef
	.long	159                     # DW_AT_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	27                      # DW_AT_decl_line
	.byte	7                       # Abbrev [7] 0x9f:0xb DW_TAG_typedef
	.long	170                     # DW_AT_type
	.long	.Linfo_string11         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0xaa:0x7 DW_TAG_base_type
	.long	.Linfo_string10         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	0                       # End Of Children Mark
.Ldebug_info_end0:
	.ident	"clang version 10.0.1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
