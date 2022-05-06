; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32, i32)*, i32 }
%_anon4_struct = type { i32 (i32, i32)*, i32 }
%_anon7_struct = type { i32 (i32, i32)*, i32 }
%_anon10_struct = type { i32 (i32, i32)*, i32 }
%_anon11_struct = type { i32 (i32)*, i32 }
%_anon9_struct = type { %_anon10_struct* (i32, i32)*, i32 }
%_anon8_struct = type { i32 (i32, i32)*, i32 }
%_anon6_struct = type { %_anon7_struct* (i32, i32)*, i32 }
%_anon5_struct = type { i32 (i32, i32)*, i32 }
%_anon3_struct = type { %_anon4_struct* (i32, i32)*, i32 }
%_anon2_struct = type { i32 (i32, i32)*, i32 }
%_anon0_struct = type { %_anon1_struct* (i32, i32)*, i32 }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global %_anon1_struct* (i32, i32)* null
@__anon1_1 = global i32 (i32, i32)* null
@__anon10_1 = global i32 (i32, i32)* null
@__anon11_1 = global i32 (i32)* null
@__anon2_1 = global i32 (i32, i32)* null
@__anon3_1 = global %_anon4_struct* (i32, i32)* null
@__anon4_1 = global i32 (i32, i32)* null
@__anon5_1 = global i32 (i32, i32)* null
@__anon6_1 = global %_anon7_struct* (i32, i32)* null
@__anon7_1 = global i32 (i32, i32)* null
@__anon8_1 = global i32 (i32, i32)* null
@__anon9_1 = global %_anon10_struct* (i32, i32)* null
@_retx_1 = global %_anon11_struct* null
@_testAB_7 = global %_anon9_struct* null
@_testAB_6 = global %_anon8_struct* null
@_testAB_5 = global %_anon6_struct* null
@_testAB_4 = global %_anon5_struct* null
@_testAB_3 = global %_anon3_struct* null
@_testAB_2 = global %_anon2_struct* null
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
  store %_anon1_struct* (i32, i32)* @_anon0, %_anon1_struct* (i32, i32)** %funcField, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %freeField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 1
  store i32 %_x_1, i32* %freeField, align 4
  store %_anon0_struct* %gstruct, %_anon0_struct** @_testAB_1, align 8
  %gstruct1 = alloca %_anon2_struct, align 8
  %funcField2 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct1, i32 0, i32 0
  store i32 (i32, i32)* @_anon2, i32 (i32, i32)** %funcField2, align 8
  %_x_13 = load i32, i32* @_x_1, align 4
  %freeField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct1, i32 0, i32 1
  store i32 %_x_13, i32* %freeField4, align 4
  store %_anon2_struct* %gstruct1, %_anon2_struct** @_testAB_2, align 8
  %gstruct5 = alloca %_anon3_struct, align 8
  %funcField6 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 0
  store %_anon4_struct* (i32, i32)* @_anon3, %_anon4_struct* (i32, i32)** %funcField6, align 8
  %_x_17 = load i32, i32* @_x_1, align 4
  %freeField8 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 1
  store i32 %_x_17, i32* %freeField8, align 4
  store %_anon3_struct* %gstruct5, %_anon3_struct** @_testAB_3, align 8
  %_testAB_3 = load %_anon3_struct*, %_anon3_struct** @_testAB_3, align 8
  %freePtr = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_testAB_3, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_testAB_3, i32 0, i32 0
  %function_call = load %_anon4_struct* (i32, i32)*, %_anon4_struct* (i32, i32)** %function_access, align 8
  %function_result = call %_anon4_struct* %function_call(i32 5, i32 %freeVal)
  %gstruct9 = alloca %_anon5_struct, align 8
  %funcField10 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct9, i32 0, i32 0
  store i32 (i32, i32)* @_anon5, i32 (i32, i32)** %funcField10, align 8
  %_x_111 = load i32, i32* @_x_1, align 4
  %freeField12 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct9, i32 0, i32 1
  store i32 %_x_111, i32* %freeField12, align 4
  store %_anon5_struct* %gstruct9, %_anon5_struct** @_testAB_4, align 8
  %gstruct13 = alloca %_anon6_struct, align 8
  %funcField14 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct13, i32 0, i32 0
  store %_anon7_struct* (i32, i32)* @_anon6, %_anon7_struct* (i32, i32)** %funcField14, align 8
  %_x_115 = load i32, i32* @_x_1, align 4
  %freeField16 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct13, i32 0, i32 1
  store i32 %_x_115, i32* %freeField16, align 4
  store %_anon6_struct* %gstruct13, %_anon6_struct** @_testAB_5, align 8
  %_testAB_5 = load %_anon6_struct*, %_anon6_struct** @_testAB_5, align 8
  %freePtr17 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %_testAB_5, i32 0, i32 1
  %freeVal18 = load i32, i32* %freePtr17, align 4
  %function_access19 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %_testAB_5, i32 0, i32 0
  %function_call20 = load %_anon7_struct* (i32, i32)*, %_anon7_struct* (i32, i32)** %function_access19, align 8
  %function_result21 = call %_anon7_struct* %function_call20(i32 20, i32 %freeVal18)
  %freePtr22 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %function_result21, i32 0, i32 1
  %freeVal23 = load i32, i32* %freePtr22, align 4
  %function_access24 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %function_result21, i32 0, i32 0
  %function_call25 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access24, align 8
  %function_result26 = call i32 %function_call25(i32 12, i32 %freeVal23)
  %gstruct27 = alloca %_anon8_struct, align 8
  %funcField28 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %gstruct27, i32 0, i32 0
  store i32 (i32, i32)* @_anon8, i32 (i32, i32)** %funcField28, align 8
  %_x_129 = load i32, i32* @_x_1, align 4
  %freeField30 = getelementptr inbounds %_anon8_struct, %_anon8_struct* %gstruct27, i32 0, i32 1
  store i32 %_x_129, i32* %freeField30, align 4
  store %_anon8_struct* %gstruct27, %_anon8_struct** @_testAB_6, align 8
  %gstruct31 = alloca %_anon9_struct, align 8
  %funcField32 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %gstruct31, i32 0, i32 0
  store %_anon10_struct* (i32, i32)* @_anon9, %_anon10_struct* (i32, i32)** %funcField32, align 8
  %_x_133 = load i32, i32* @_x_1, align 4
  %freeField34 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %gstruct31, i32 0, i32 1
  store i32 %_x_133, i32* %freeField34, align 4
  store %_anon9_struct* %gstruct31, %_anon9_struct** @_testAB_7, align 8
  %_testAB_7 = load %_anon9_struct*, %_anon9_struct** @_testAB_7, align 8
  %freePtr35 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %_testAB_7, i32 0, i32 1
  %freeVal36 = load i32, i32* %freePtr35, align 4
  %function_access37 = getelementptr inbounds %_anon9_struct, %_anon9_struct* %_testAB_7, i32 0, i32 0
  %function_call38 = load %_anon10_struct* (i32, i32)*, %_anon10_struct* (i32, i32)** %function_access37, align 8
  %function_result39 = call %_anon10_struct* %function_call38(i32 20, i32 %freeVal36)
  %freePtr40 = getelementptr inbounds %_anon10_struct, %_anon10_struct* %function_result39, i32 0, i32 1
  %freeVal41 = load i32, i32* %freePtr40, align 4
  %function_access42 = getelementptr inbounds %_anon10_struct, %_anon10_struct* %function_result39, i32 0, i32 0
  %function_call43 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access42, align 8
  %function_result44 = call i32 %function_call43(i32 12, i32 %freeVal41)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result44)
  store i32 42, i32* @_x_2, align 4
  %gstruct45 = alloca %_anon11_struct, align 8
  %funcField46 = getelementptr inbounds %_anon11_struct, %_anon11_struct* %gstruct45, i32 0, i32 0
  store i32 (i32)* @_anon11, i32 (i32)** %funcField46, align 8
  %_x_2 = load i32, i32* @_x_2, align 4
  %freeField47 = getelementptr inbounds %_anon11_struct, %_anon11_struct* %gstruct45, i32 0, i32 1
  store i32 %_x_2, i32* %freeField47, align 4
  store %_anon11_struct* %gstruct45, %_anon11_struct** @_retx_1, align 8
  %_retx_1 = load %_anon11_struct*, %_anon11_struct** @_retx_1, align 8
  %freePtr48 = getelementptr inbounds %_anon11_struct, %_anon11_struct* %_retx_1, i32 0, i32 1
  %freeVal49 = load i32, i32* %freePtr48, align 4
  %function_access50 = getelementptr inbounds %_anon11_struct, %_anon11_struct* %_retx_1, i32 0, i32 0
  %function_call51 = load i32 (i32)*, i32 (i32)** %function_access50, align 8
  %function_result52 = call i32 %function_call51(i32 %freeVal49)
  %printi53 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result52)
  ret i32 0
}

define i32 @_anon11(i32 %_x_2) {
entry:
  %_x_21 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_21, align 4
  %_x_22 = load i32, i32* %_x_21, align 4
  ret i32 %_x_22
}

define %_anon10_struct* @_anon9(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon10_struct, align 8
  %funcField = getelementptr inbounds %_anon10_struct, %_anon10_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon10, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon10_struct, %_anon10_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon10_struct* %gstruct
}

define i32 @_anon10(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
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

define %_anon7_struct* @_anon6(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon7_struct, align 8
  %funcField = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon7, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon7_struct* %gstruct
}

define i32 @_anon7(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
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

define %_anon4_struct* @_anon3(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon4_struct, align 8
  %funcField = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon4, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon4_struct* %gstruct
}

define i32 @_anon4(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
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

define %_anon1_struct* @_anon0(i32 %a, i32 %_x_1) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %gstruct = alloca %_anon1_struct, align 8
  %funcField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField, align 8
  %_x_13 = load i32, i32* %_x_12, align 4
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 1
  store i32 %_x_13, i32* %freeField, align 4
  ret %_anon1_struct* %gstruct
}

define i32 @_anon1(i32 %b, i32 %_x_1) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_x_12 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_12, align 4
  %_x_13 = load i32, i32* %_x_12, align 4
  ret i32 %_x_13
}
