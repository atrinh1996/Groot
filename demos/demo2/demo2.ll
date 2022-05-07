; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon11_struct = type { i32 (i32)* }
%_anon13_struct = type { i32 (i32)* }
%_anon15_struct = type { i1 (i1)* }
%_anon0_struct = type { i32 (i32)* }
%_anon5_struct = type { i32 (i32)* }
%_anon1_struct = type { i32 (i32)* }
%_anon9_struct = type { i8* (i8*)* }
%_anon14_struct = type { i1 (%_anon15_struct*, i1)* }
%_anon12_struct = type { i32 (%_anon13_struct*, i32)* }
%_anon10_struct = type { i32 (%_anon11_struct*, i32)* }
%_anon8_struct = type { i8* (%_anon9_struct*, i8*)* }
%_anon7_struct = type { i32 (%_anon1_struct*, i32)* }
%_anon6_struct = type { i32 (%_anon0_struct*, i32)* }
%_anon4_struct = type { %_anon5_struct* ()* }
%_anon16_struct = type { %_anon0_struct* (%_anon0_struct*)* }
%_anon2_struct = type { i32 (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null
@__anon1_1 = global i32 (i32)* null
@__anon10_1 = global i32 (%_anon11_struct*, i32)* null
@__anon11_1 = global i32 (i32)* null
@__anon12_1 = global i32 (%_anon13_struct*, i32)* null
@__anon13_1 = global i32 (i32)* null
@__anon14_1 = global i1 (%_anon15_struct*, i1)* null
@__anon15_1 = global i1 (i1)* null
@__anon16_1 = global %_anon0_struct* (%_anon0_struct*)* null
@__anon2_1 = global i32 (i32)* null
@__anon4_1 = global %_anon5_struct* ()* null
@__anon5_1 = global i32 (i32)* null
@__anon6_1 = global i32 (%_anon0_struct*, i32)* null
@__anon7_1 = global i32 (%_anon1_struct*, i32)* null
@__anon8_1 = global i8* (%_anon9_struct*, i8*)* null
@__anon9_1 = global i8* (i8*)* null
@_add1_1 = global %_anon0_struct* null
@_callFunc_6 = global %_anon14_struct* null
@_callFunc_5 = global %_anon12_struct* null
@_callFunc_4 = global %_anon10_struct* null
@_callFunc_3 = global %_anon8_struct* null
@_callFunc_2 = global %_anon7_struct* null
@_callFunc_1 = global %_anon6_struct* null
@_retDoubleLambda_1 = global %_anon4_struct* null
@_retx_5 = global %_anon16_struct* null
@_retx_4 = global %_anon15_struct* null
@_retx_3 = global %_anon13_struct* null
@_retx_2 = global %_anon9_struct* null
@_retx_1 = global %_anon2_struct* null
@_sub1_1 = global %_anon1_struct* null
@globalChar = private unnamed_addr constant [2 x i8] c"c\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon0, i32 (i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_add1_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (i32)* @_anon1, i32 (i32)** %funcField2, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_sub1_1, align 8
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store i32 (i32)* @_anon2, i32 (i32)** %funcField4, align 8
  store %_anon2_struct* %gstruct3, %_anon2_struct** @_retx_1, align 8
  %gstruct5 = alloca %_anon4_struct, align 8
  %funcField6 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct5, i32 0, i32 0
  store %_anon5_struct* ()* @_anon4, %_anon5_struct* ()** %funcField6, align 8
  store %_anon4_struct* %gstruct5, %_anon4_struct** @_retDoubleLambda_1, align 8
  %gstruct7 = alloca %_anon6_struct, align 8
  %funcField8 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct7, i32 0, i32 0
  store i32 (%_anon0_struct*, i32)* @_anon6, i32 (%_anon0_struct*, i32)** %funcField8, align 8
  store %_anon6_struct* %gstruct7, %_anon6_struct** @_callFunc_1, align 8
  %_callFunc_1 = load %_anon6_struct*, %_anon6_struct** @_callFunc_1, align 8
  %_add1_1 = load %_anon0_struct*, %_anon0_struct** @_add1_1, align 8
  %function_access = getelementptr inbounds %_anon6_struct, %_anon6_struct* %_callFunc_1, i32 0, i32 0
  %function_call = load i32 (%_anon0_struct*, i32)*, i32 (%_anon0_struct*, i32)** %function_access, align 8
  %function_result = call i32 %function_call(%_anon0_struct* %_add1_1, i32 41)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  %gstruct9 = alloca %_anon7_struct, align 8
  %funcField10 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct9, i32 0, i32 0
  store i32 (%_anon1_struct*, i32)* @_anon7, i32 (%_anon1_struct*, i32)** %funcField10, align 8
  store %_anon7_struct* %gstruct9, %_anon7_struct** @_callFunc_2, align 8
  %_callFunc_2 = load %_anon7_struct*, %_anon7_struct** @_callFunc_2, align 8
  %_sub1_1 = load %_anon1_struct*, %_anon1_struct** @_sub1_1, align 8
  %function_access11 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %_callFunc_2, i32 0, i32 0
  %function_call12 = load i32 (%_anon1_struct*, i32)*, i32 (%_anon1_struct*, i32)** %function_access11, align 8
  %function_result13 = call i32 %function_call12(%_anon1_struct* %_sub1_1, i32 43)
  %printi14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result13)
  %gstruct15 = alloca %_anon9_struct, align 8
  %funcField16 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %gstruct15, i32 0, i32 0
  store i8* (i8*)* @_anon9, i8* (i8*)** %funcField16, align 8
  store %_anon9_struct* %gstruct15, %_anon9_struct** @_retx_2, align 8
  %gstruct17 = alloca %_anon8_struct, align 8
  %funcField18 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %gstruct17, i32 0, i32 0
  store i8* (%_anon9_struct*, i8*)* @_anon8, i8* (%_anon9_struct*, i8*)** %funcField18, align 8
  store %_anon8_struct* %gstruct17, %_anon8_struct** @_callFunc_3, align 8
  %_callFunc_3 = load %_anon8_struct*, %_anon8_struct** @_callFunc_3, align 8
  %_retx_2 = load %_anon9_struct*, %_anon9_struct** @_retx_2, align 8
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  %function_access19 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %_callFunc_3, i32 0, i32 0
  %function_call20 = load i8* (%_anon9_struct*, i8*)*, i8* (%_anon9_struct*, i8*)** %function_access19, align 8
  %function_result21 = call i8* %function_call20(%_anon9_struct* %_retx_2, i8* %character_ptr)
  %printc = call i32 @puts(i8* %function_result21)
  %gstruct22 = alloca %_anon10_struct, align 8
  %funcField23 = getelementptr inbounds %_anon10_struct, %_anon10_struct* %gstruct22, i32 0, i32 0
  store i32 (%_anon11_struct*, i32)* @_anon10, i32 (%_anon11_struct*, i32)** %funcField23, align 8
  store %_anon10_struct* %gstruct22, %_anon10_struct** @_callFunc_4, align 8
  %_callFunc_4 = load %_anon10_struct*, %_anon10_struct** @_callFunc_4, align 8
  %gstruct24 = alloca %_anon11_struct, align 8
  %funcField25 = getelementptr inbounds %_anon11_struct, %_anon11_struct* %gstruct24, i32 0, i32 0
  store i32 (i32)* @_anon11, i32 (i32)** %funcField25, align 8
  %function_access26 = getelementptr inbounds %_anon10_struct, %_anon10_struct* %_callFunc_4, i32 0, i32 0
  %function_call27 = load i32 (%_anon11_struct*, i32)*, i32 (%_anon11_struct*, i32)** %function_access26, align 8
  %function_result28 = call i32 %function_call27(%_anon11_struct* %gstruct24, i32 2)
  %printi29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result28)
  %gstruct30 = alloca %_anon13_struct, align 8
  %funcField31 = getelementptr inbounds %_anon13_struct, %_anon13_struct* %gstruct30, i32 0, i32 0
  store i32 (i32)* @_anon13, i32 (i32)** %funcField31, align 8
  store %_anon13_struct* %gstruct30, %_anon13_struct** @_retx_3, align 8
  %gstruct32 = alloca %_anon12_struct, align 8
  %funcField33 = getelementptr inbounds %_anon12_struct, %_anon12_struct* %gstruct32, i32 0, i32 0
  store i32 (%_anon13_struct*, i32)* @_anon12, i32 (%_anon13_struct*, i32)** %funcField33, align 8
  store %_anon12_struct* %gstruct32, %_anon12_struct** @_callFunc_5, align 8
  %_callFunc_5 = load %_anon12_struct*, %_anon12_struct** @_callFunc_5, align 8
  %_retx_3 = load %_anon13_struct*, %_anon13_struct** @_retx_3, align 8
  %function_access34 = getelementptr inbounds %_anon12_struct, %_anon12_struct* %_callFunc_5, i32 0, i32 0
  %function_call35 = load i32 (%_anon13_struct*, i32)*, i32 (%_anon13_struct*, i32)** %function_access34, align 8
  %function_result36 = call i32 %function_call35(%_anon13_struct* %_retx_3, i32 42)
  %printi37 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result36)
  %gstruct38 = alloca %_anon15_struct, align 8
  %funcField39 = getelementptr inbounds %_anon15_struct, %_anon15_struct* %gstruct38, i32 0, i32 0
  store i1 (i1)* @_anon15, i1 (i1)** %funcField39, align 8
  store %_anon15_struct* %gstruct38, %_anon15_struct** @_retx_4, align 8
  %gstruct40 = alloca %_anon14_struct, align 8
  %funcField41 = getelementptr inbounds %_anon14_struct, %_anon14_struct* %gstruct40, i32 0, i32 0
  store i1 (%_anon15_struct*, i1)* @_anon14, i1 (%_anon15_struct*, i1)** %funcField41, align 8
  store %_anon14_struct* %gstruct40, %_anon14_struct** @_callFunc_6, align 8
  %_callFunc_6 = load %_anon14_struct*, %_anon14_struct** @_callFunc_6, align 8
  %_retx_4 = load %_anon15_struct*, %_anon15_struct** @_retx_4, align 8
  %function_access42 = getelementptr inbounds %_anon14_struct, %_anon14_struct* %_callFunc_6, i32 0, i32 0
  %function_call43 = load i1 (%_anon15_struct*, i1)*, i1 (%_anon15_struct*, i1)** %function_access42, align 8
  %function_result44 = call i1 %function_call43(%_anon15_struct* %_retx_4, i1 true)
  %printb = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_retDoubleLambda_1 = load %_anon4_struct*, %_anon4_struct** @_retDoubleLambda_1, align 8
  %function_access45 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %_retDoubleLambda_1, i32 0, i32 0
  %function_call46 = load %_anon5_struct* ()*, %_anon5_struct* ()** %function_access45, align 8
  %function_result47 = call %_anon5_struct* %function_call46()
  %function_access48 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %function_result47, i32 0, i32 0
  %function_call49 = load i32 (i32)*, i32 (i32)** %function_access48, align 8
  %function_result50 = call i32 %function_call49(i32 500)
  %printi51 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result50)
  %gstruct52 = alloca %_anon16_struct, align 8
  %funcField53 = getelementptr inbounds %_anon16_struct, %_anon16_struct* %gstruct52, i32 0, i32 0
  store %_anon0_struct* (%_anon0_struct*)* @_anon16, %_anon0_struct* (%_anon0_struct*)** %funcField53, align 8
  store %_anon16_struct* %gstruct52, %_anon16_struct** @_retx_5, align 8
  %_retx_5 = load %_anon16_struct*, %_anon16_struct** @_retx_5, align 8
  %_add1_154 = load %_anon0_struct*, %_anon0_struct** @_add1_1, align 8
  %function_access55 = getelementptr inbounds %_anon16_struct, %_anon16_struct* %_retx_5, i32 0, i32 0
  %function_call56 = load %_anon0_struct* (%_anon0_struct*)*, %_anon0_struct* (%_anon0_struct*)** %function_access55, align 8
  %function_result57 = call %_anon0_struct* %function_call56(%_anon0_struct* %_add1_154)
  %function_access58 = getelementptr inbounds %_anon0_struct, %_anon0_struct* %function_result57, i32 0, i32 0
  %function_call59 = load i32 (i32)*, i32 (i32)** %function_access58, align 8
  %function_result60 = call i32 %function_call59(i32 5)
  %printi61 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result60)
  ret i32 0
}

define %_anon0_struct* @_anon16(%_anon0_struct* %x) {
entry:
  %x1 = alloca %_anon0_struct*, align 8
  store %_anon0_struct* %x, %_anon0_struct** %x1, align 8
  %x2 = load %_anon0_struct*, %_anon0_struct** %x1, align 8
  ret %_anon0_struct* %x2
}

define i1 @_anon14(%_anon15_struct* %func, i1 %arg) {
entry:
  %func1 = alloca %_anon15_struct*, align 8
  store %_anon15_struct* %func, %_anon15_struct** %func1, align 8
  %arg2 = alloca i1, align 1
  store i1 %arg, i1* %arg2, align 1
  %func3 = load %_anon15_struct*, %_anon15_struct** %func1, align 8
  %arg4 = load i1, i1* %arg2, align 1
  %function_access = getelementptr inbounds %_anon15_struct, %_anon15_struct* %func3, i32 0, i32 0
  %function_call = load i1 (i1)*, i1 (i1)** %function_access, align 8
  %function_result = call i1 %function_call(i1 %arg4)
  ret i1 %function_result
}

define i1 @_anon15(i1 %x) {
entry:
  %x1 = alloca i1, align 1
  store i1 %x, i1* %x1, align 1
  %x2 = load i1, i1* %x1, align 1
  ret i1 %x2
}

define i32 @_anon12(%_anon13_struct* %func, i32 %arg) {
entry:
  %func1 = alloca %_anon13_struct*, align 8
  store %_anon13_struct* %func, %_anon13_struct** %func1, align 8
  %arg2 = alloca i32, align 4
  store i32 %arg, i32* %arg2, align 4
  %func3 = load %_anon13_struct*, %_anon13_struct** %func1, align 8
  %arg4 = load i32, i32* %arg2, align 4
  %function_access = getelementptr inbounds %_anon13_struct, %_anon13_struct* %func3, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %arg4)
  ret i32 %function_result
}

define i32 @_anon13(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  ret i32 %x2
}

define i32 @_anon11(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  %x3 = load i32, i32* %x1, align 4
  %multiply = mul i32 %x2, %x3
  ret i32 %multiply
}

define i32 @_anon10(%_anon11_struct* %func, i32 %arg) {
entry:
  %func1 = alloca %_anon11_struct*, align 8
  store %_anon11_struct* %func, %_anon11_struct** %func1, align 8
  %arg2 = alloca i32, align 4
  store i32 %arg, i32* %arg2, align 4
  %func3 = load %_anon11_struct*, %_anon11_struct** %func1, align 8
  %arg4 = load i32, i32* %arg2, align 4
  %function_access = getelementptr inbounds %_anon11_struct, %_anon11_struct* %func3, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %arg4)
  ret i32 %function_result
}

define i8* @_anon8(%_anon9_struct* %func, i8* %arg) {
entry:
  %func1 = alloca %_anon9_struct*, align 8
  store %_anon9_struct* %func, %_anon9_struct** %func1, align 8
  %arg2 = alloca i8*, align 8
  store i8* %arg, i8** %arg2, align 8
  %func3 = load %_anon9_struct*, %_anon9_struct** %func1, align 8
  %arg4 = load i8*, i8** %arg2, align 8
  %function_access = getelementptr inbounds %_anon9_struct, %_anon9_struct* %func3, i32 0, i32 0
  %function_call = load i8* (i8*)*, i8* (i8*)** %function_access, align 8
  %function_result = call i8* %function_call(i8* %arg4)
  ret i8* %function_result
}

define i8* @_anon9(i8* %x) {
entry:
  %x1 = alloca i8*, align 8
  store i8* %x, i8** %x1, align 8
  %x2 = load i8*, i8** %x1, align 8
  ret i8* %x2
}

define i32 @_anon7(%_anon1_struct* %func, i32 %arg) {
entry:
  %func1 = alloca %_anon1_struct*, align 8
  store %_anon1_struct* %func, %_anon1_struct** %func1, align 8
  %arg2 = alloca i32, align 4
  store i32 %arg, i32* %arg2, align 4
  %func3 = load %_anon1_struct*, %_anon1_struct** %func1, align 8
  %arg4 = load i32, i32* %arg2, align 4
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %func3, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %arg4)
  ret i32 %function_result
}

define i32 @_anon6(%_anon0_struct* %func, i32 %arg) {
entry:
  %func1 = alloca %_anon0_struct*, align 8
  store %_anon0_struct* %func, %_anon0_struct** %func1, align 8
  %arg2 = alloca i32, align 4
  store i32 %arg, i32* %arg2, align 4
  %func3 = load %_anon0_struct*, %_anon0_struct** %func1, align 8
  %arg4 = load i32, i32* %arg2, align 4
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %func3, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %arg4)
  ret i32 %function_result
}

define %_anon5_struct* @_anon4() {
entry:
  %gstruct = alloca %_anon5_struct, align 8
  %funcField = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon5, i32 (i32)** %funcField, align 8
  ret %_anon5_struct* %gstruct
}

define i32 @_anon5(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  %multiply = mul i32 %x2, 2
  ret i32 %multiply
}

define i32 @_anon2(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  ret i32 %x2
}

define i32 @_anon1(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  %subtraction = sub i32 %x2, 1
  ret i32 %subtraction
}

define i32 @_anon0(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %x2 = load i32, i32* %x1, align 4
  %addition = add i32 %x2, 1
  ret i32 %addition
}
