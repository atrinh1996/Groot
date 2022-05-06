; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon2_struct = type { i32 (i32, i32)*, i32 }
%_anon5_struct = type { i32 (i32, i32)*, i32 }
%_anon8_struct = type { i32 (i32, i32)*, i32 }
%_anon9_struct = type { i32 (i32)*, i32 }
%_anon7_struct = type { %_anon8_struct* (i32, i32)*, i32 }
%_anon6_struct = type { i32 (i32, i32)*, i32 }
%_anon4_struct = type { %_anon5_struct* (i32, i32)*, i32 }
%_anon3_struct = type { i32 (i32, i32)*, i32 }
%_anon1_struct = type { %_anon2_struct* (i32, i32)*, i32 }
%_anon0_struct = type { i32 (i32, i32)*, i32 }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32, i32)* null
@__anon1_1 = global %_anon2_struct* (i32, i32)* null
@__anon2_1 = global i32 (i32, i32)* null
@__anon3_1 = global i32 (i32, i32)* null
@__anon4_1 = global %_anon5_struct* (i32, i32)* null
@__anon5_1 = global i32 (i32, i32)* null
@__anon6_1 = global i32 (i32, i32)* null
@__anon7_1 = global %_anon8_struct* (i32, i32)* null
@__anon8_1 = global i32 (i32, i32)* null
@__anon9_1 = global i32 (i32)* null
@_retx_1 = global %_anon9_struct* null
@_testAB_6 = global %_anon7_struct* null
@_testAB_5 = global %_anon6_struct* null
@_testAB_4 = global %_anon4_struct* null
@_testAB_3 = global %_anon3_struct* null
@_testAB_2 = global %_anon1_struct* null
@_testAB_1 = global %_anon0_struct* null
@_x_2 = global i32 0
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 17, i32* @_x_1, align 4
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon0, i32 (i32, i32)** %funcField, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %freeField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 1
  store i32 %_x_1, i32* %freeField, align 4
  store %_anon0_struct* %gstruct, %_anon0_struct** @_testAB_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store %_anon2_struct* (i32, i32)* @_anon1, %_anon2_struct* (i32, i32)** %funcField2, align 8
  %_x_13 = load i32, i32* @_x_1, align 4
  %freeField4 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 1
  store i32 %_x_13, i32* %freeField4, align 4
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_testAB_2, align 8
  %_testAB_2 = load %_anon1_struct*, %_anon1_struct** @_testAB_2, align 8
  %freePtr = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_testAB_2, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_testAB_2, i32 0, i32 0
  %function_call = load %_anon2_struct* (i32, i32)*, %_anon2_struct* (i32, i32)** %function_access, align 8
  %function_result = call %_anon2_struct* %function_call(i32 5, i32 %freeVal)
  %gstruct5 = alloca %_anon3_struct, align 8
  %funcField6 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 0
  store i32 (i32, i32)* @_anon3, i32 (i32, i32)** %funcField6, align 8
  %_x_17 = load i32, i32* @_x_1, align 4
  %freeField8 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 1
  store i32 %_x_17, i32* %freeField8, align 4
  store %_anon3_struct* %gstruct5, %_anon3_struct** @_testAB_3, align 8
  %gstruct9 = alloca %_anon4_struct, align 8
  %funcField10 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct9, i32 0, i32 0
  store %_anon5_struct* (i32, i32)* @_anon4, %_anon5_struct* (i32, i32)** %funcField10, align 8
  %_x_111 = load i32, i32* @_x_1, align 4
  %freeField12 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct9, i32 0, i32 1
  store i32 %_x_111, i32* %freeField12, align 4
  store %_anon4_struct* %gstruct9, %_anon4_struct** @_testAB_4, align 8
  %_testAB_4 = load %_anon4_struct*, %_anon4_struct** @_testAB_4, align 8
  %freePtr13 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %_testAB_4, i32 0, i32 1
  %freeVal14 = load i32, i32* %freePtr13, align 4
  %function_access15 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %_testAB_4, i32 0, i32 0
  %function_call16 = load %_anon5_struct* (i32, i32)*, %_anon5_struct* (i32, i32)** %function_access15, align 8
  %function_result17 = call %_anon5_struct* %function_call16(i32 20, i32 %freeVal14)
  %freePtr18 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %function_result17, i32 0, i32 1
  %freeVal19 = load i32, i32* %freePtr18, align 4
  %function_access20 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %function_result17, i32 0, i32 0
  %function_call21 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access20, align 8
  %function_result22 = call i32 %function_call21(i32 12, i32 %freeVal19)
  %gstruct23 = alloca %_anon6_struct, align 8
  %funcField24 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct23, i32 0, i32 0
  store i32 (i32, i32)* @_anon6, i32 (i32, i32)** %funcField24, align 8
  %_x_125 = load i32, i32* @_x_1, align 4
  %freeField26 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct23, i32 0, i32 1
  store i32 %_x_125, i32* %freeField26, align 4
  store %_anon6_struct* %gstruct23, %_anon6_struct** @_testAB_5, align 8
  %gstruct27 = alloca %_anon7_struct, align 8
  %funcField28 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct27, i32 0, i32 0
  store %_anon8_struct* (i32, i32)* @_anon7, %_anon8_struct* (i32, i32)** %funcField28, align 8
  %_x_129 = load i32, i32* @_x_1, align 4
  %freeField30 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct27, i32 0, i32 1
  store i32 %_x_129, i32* %freeField30, align 4
  store %_anon7_struct* %gstruct27, %_anon7_struct** @_testAB_6, align 8
  %_testAB_6 = load %_anon7_struct*, %_anon7_struct** @_testAB_6, align 8
  %freePtr31 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %_testAB_6, i32 0, i32 1
  %freeVal32 = load i32, i32* %freePtr31, align 4
  %function_access33 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %_testAB_6, i32 0, i32 0
  %function_call34 = load %_anon8_struct* (i32, i32)*, %_anon8_struct* (i32, i32)** %function_access33, align 8
  %function_result35 = call %_anon8_struct* %function_call34(i32 20, i32 %freeVal32)
  %freePtr36 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %function_result35, i32 0, i32 1
  %freeVal37 = load i32, i32* %freePtr36, align 4
  %function_access38 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %function_result35, i32 0, i32 0
  %function_call39 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access38, align 8
  %function_result40 = call i32 %function_call39(i32 12, i32 %freeVal37)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result40)
  store i32 42, i32* @_x_2, align 4
  %gstruct41 = alloca %_anon9_struct, align 8
  %funcField42 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %gstruct41, i32 0, i32 0
  store i32 (i32)* @_anon9, i32 (i32)** %funcField42, align 8
  %_x_2 = load i32, i32* @_x_2, align 4
  %freeField43 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %gstruct41, i32 0, i32 1
  store i32 %_x_2, i32* %freeField43, align 4
  store %_anon9_struct* %gstruct41, %_anon9_struct** @_retx_1, align 8
  %_retx_1 = load %_anon9_struct*, %_anon9_struct** @_retx_1, align 8
  %freePtr44 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %_retx_1, i32 0, i32 1
  %freeVal45 = load i32, i32* %freePtr44, align 4
  %function_access46 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %_retx_1, i32 0, i32 0
  %function_call47 = load i32 (i32)*, i32 (i32)** %function_access46, align 8
  %function_result48 = call i32 %function_call47(i32 %freeVal45)
  %printi49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result48)
  ret i32 0
}

define i32 @_anon9(i32 %_x_2) {
entry:
  %_x_21 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_21, align 4
  %_x_22 = load i32, i32* %_x_21, align 4
  ret i32 %_x_22
}

define %_anon8_struct* @_anon7(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon8_struct, align 8
  %funcField = getelementptr inbounds %_anon8_struct, %_anon8_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon8, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon8_struct, %_anon8_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon8_struct* %gstruct
}

define i32 @_anon8(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}

define i32 @_anon6(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}

define %_anon5_struct* @_anon4(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon5_struct, align 8
  %funcField = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon5, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon5_struct* %gstruct
}

define i32 @_anon5(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}

define i32 @_anon3(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}

define %_anon2_struct* @_anon1(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon2_struct, align 8
  %funcField = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon2, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon2_struct* %gstruct
}

define i32 @_anon2(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}

define i32 @_anon0(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}
