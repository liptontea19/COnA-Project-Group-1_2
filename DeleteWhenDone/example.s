.data
.text
.global main

main:
    MOV MAX_SIZE,#100 //define max_size to be 100
    MOV num_items,#0 //define num_items to be 0
    MOV i,#0 //define i to be 0
    MOVEQ num_items,MAX_SIZE //set num_items to be equal to max_size value

    //set the respective a variables to their respective numbers
    MOV a1,#123
    MOV a2,#131
    MOV a3,#145
    MOV a4,#156
    MOV a5,#157
    MOV a6,#168
    MOV a7,#169
    MOV a8,#172
    MOV a9,#175
    MOV a10,#179
    MOV a11,#184
    MOV a12,#185
    MOV a13,#189
    MOV a14,#190
    MOV a15,#193
    MOV a16,#195
    MOV a17,#197
    MOV a18,#198
    MOV a19,#201
    MOV a20,#202
    MOV a21,#205
    MOV a22,#207
    MOV a23,#209
    MOV a24,#213
    MOV a25,#217
    MOV a26,#220
    MOV a27,#226
    MOV a28,#229
    MOV a29,#235
    MOV a30,#247
    MOV a31,#252
    MOV a32,#264
    MOV a33,#270
    MOV a34,#280
    MOV a35,#288
    MOV a36,#289
    MOV a37,#292
    MOV a38,#295
    MOV a39,#305
    MOV a40,#307
    MOV a41,#309
    MOV a42,#311
    MOV a43,#312
    MOV a44,#315
    MOV a45,#318
    MOV a46,#320
    MOV a47,#325
    MOV a48,#543
    MOV a49,#620
    MOV a50,#110
    MOV a51,#105
    MOV a52,#104
    MOV a53,#103
    MOV a54,#100
    MOV a55,#92
    MOV a56,#91
    MOV a57,#90
    MOV a58,#85
    MOV a59,#83
    MOV a60,#82
    MOV a61,#81
    MOV a62,#80
    MOV a63,#75
    MOV a64,#73
    MOV a65,#71
    MOV a66,#70
    MOV a67,#64
    MOV a68,#63
    MOV a69,#61
    MOV a70,#58
    MOV a71,#57
    MOV a72,#56
    MOV a73,#52
    MOV a74,#51
    MOV a75,#47
    MOV a76,#43
    MOV a77,#40
    MOV a78,#35
    MOV a79,#32
    MOV a80,#30
    MOV a81,#27
    MOV a82,#25
    MOV a83,#22
    MOV a84,#23
    MOV a85,#21
    MOV a86,#20
    MOV a87,#10
    MOV a88,#5
    MOV a89,#1
    MOV a90,#6
    MOV a91,#9
    MOV a92,#215
    MOV a93,#220
    MOV a94,#250
    MOV a95,#272
    MOV a96,#284
    MOV a97,#290
    MOV a98,#315
    MOV a99,#320
    MOV a100,#350

    BL QUICK_SORTA //Run the QUICK_SORTA Function


QUICK_SORTA:
    MOV pivot,#0 //define pivot as 0
    MOV first, #0 //define first as 0
    MOV last, #0 //define last as 0

    MOVEQ first, #0 //set first to be equal to 0
    SUB last,num_items,#1 //last = num_items-1 

    CMP first,last //compare first and last variable
    MOVLT pivot, //set to partition when first is less than last
    BLT QUICK_SORTB //set to quick sort b if less than
    BLT QUICK_SORTC //set to quick sort c if less than

//please update this
QUICK_SORTB:
    MOV pivot,#0 //define pivot as 0
    MOV first, #0 //define first as 0
    MOV last, #0 //define last as 0

    MOVEQ first, #0 //set first to be equal to 0
    SUB last,num_items,#1 //last = num_items-1 

    CMP first,last //compare first and last variable
    MOVLT pivot, //set to partition when first is less than last
    BLT QUICK_SORTB //set to quick sort b
    BLT QUICK_SORTC //set to quick sort c

//please update this
QUICK_SORTC:
    MOV pivot,#0 //define pivot as 0
    MOV first, #0 //define first as 0
    MOV last, #0 //define last as 0

    MOVEQ first, #0 //set first to be equal to 0
    SUB last,num_items,#1 //last = num_items-1 

    CMP first,last //compare first and last variable
    MOVLT pivot, //set to partition when first is less than last
    BLT QUICK_SORTB //set to quick sort b
    BLT QUICK_SORTC //set to quick sort c


PARTITION:
    MOV firsta,#0
    MOV lasta,#0

    MOV pivotA,#0
    MOV pivot_value,#0
    MOV temp,#0
    MOV a,#0

    MOVEQ pivotA,firsta //set pivotA to be equal to firsta

    //add loop here
    BL LOOP

LOOP:
    CMP a,firsta //if a == firsta
    BGE //if it is greater than last

    ADD a,a,#1 //a = a+1



//Run this at the end of program
END:
    