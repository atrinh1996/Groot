; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i32 ()* }
%_anon2_struct = type { i32 (i32)*, i32 }
%_anon1_struct = type { i32 (%_anon0_struct*)*, %_anon0_struct* }
%_anon4_struct = type { i32 ()* }
%_anon3_struct = type { i32 (i32, %_anon2_struct*)*, %_anon2_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 ()* null
@__anon1_1 = global i32 (%_anon0_struct*)* null
@__anon2_1 = global i32 (i32)* null
@__anon3_1 = global i32 (i32, %_anon2_struct*)* null
@__anon4_1 = global i32 ()* null
@_call4_1 = global %_anon1_struct* null
@_ret4_2 = global %_anon4_struct* null
@_ret4_1 = global %_anon0_struct* null
@_retx_1 = global %_anon2_struct* null
@_takenthenx_1 = global %_anon3_struct* null
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 ()* @_anon0, i32 ()** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_ret4_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (%_anon0_struct*)* @_anon1, i32 (%_anon0_struct*)** %funcField2, align 8
  %_ret4_1 = load %_anon0_struct*, %_anon0_struct** @_ret4_1, align 8
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 1
  store %_anon0_struct* %_ret4_1, %_anon0_struct** %freeField, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_call4_1, align 8
  %_call4_1 = load %_anon1_struct*, %_anon1_struct** @_call4_1, align 8
  %freePtr = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_call4_1, i32 0, i32 1
  %freeVal = load %_anon0_struct*, %_anon0_struct** %freePtr, align 8
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_call4_1, i32 0, i32 0
  %function_call = load i32 (%_anon0_struct*)*, i32 (%_anon0_struct*)** %function_access, align 8
  %function_result = call i32 %function_call(%_anon0_struct* %freeVal)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  store i32 17, i32* @_x_1, align 4
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store i32 (i32)* @_anon2, i32 (i32)** %funcField4, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %freeField5 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 1
  store i32 %_x_1, i32* %freeField5, align 4
  store %_anon2_struct* %gstruct3, %_anon2_struct** @_retx_1, align 8
  %gstruct6 = alloca %_anon3_struct, align 8
  %funcField7 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct6, i32 0, i32 0
  store i32 (i32, %_anon2_struct*)* @_anon3, i32 (i32, %_anon2_struct*)** %funcField7, align 8
  %_retx_1 = load %_anon2_struct*, %_anon2_struct** @_retx_1, align 8
  %freeField8 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct6, i32 0, i32 1
  store %_anon2_struct* %_retx_1, %_anon2_struct** %freeField8, align 8
  store %_anon3_struct* %gstruct6, %_anon3_struct** @_takenthenx_1, align 8
  %_takenthenx_1 = load %_anon3_struct*, %_anon3_struct** @_takenthenx_1, align 8
  %freePtr9 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_takenthenx_1, i32 0, i32 1
  %freeVal10 = load %_anon2_struct*, %_anon2_struct** %freePtr9, align 8
  %function_access11 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_takenthenx_1, i32 0, i32 0
  %function_call12 = load i32 (i32, %_anon2_struct*)*, i32 (i32, %_anon2_struct*)** %function_access11, align 8
  %function_result13 = call i32 %function_call12(i32 9, %_anon2_struct* %freeVal10)
  %printi14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result13)
  %gstruct15 = alloca %_anon4_struct, align 8
  %funcField16 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct15, i32 0, i32 0
  store i32 ()* @_anon4, i32 ()** %funcField16, align 8
  store %_anon4_struct* %gstruct15, %_anon4_struct** @_ret4_2, align 8
  %_ret4_2 = load %_anon4_struct*, %_anon4_struct** @_ret4_2, align 8
  %function_access17 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %_ret4_2, i32 0, i32 0
  %function_call18 = load i32 ()*, i32 ()** %function_access17, align 8
  %function_result19 = call i32 %function_call18()
  %printi20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result19)
  ret i32 0
}

define i32 @_anon4() {
entry:
  ret i32 16
}

define i32 @_anon3(i32 %n, %_anon2_struct* %_retx_1) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %_retx_12 = alloca %_anon2_struct*, align 8
  store %_anon2_struct* %_retx_1, %_anon2_struct** %_retx_12, align 8
  %_retx_13 = load %_anon2_struct*, %_anon2_struct** %_retx_12, align 8
  %freePtr = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_retx_13, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_retx_13, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %freeVal)
  ret i32 %function_result
}

define i32 @_anon2(i32 %_x_1) {
entry:
  %_x_11 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_11, align 4
  %_x_12 = load i32, i32* %_x_11, align 4
  ret i32 %_x_12
}

define i32 @_anon1(%_anon0_struct* %_ret4_1) {
entry:
  %_ret4_11 = alloca %_anon0_struct*, align 8
  store %_anon0_struct* %_ret4_1, %_anon0_struct** %_ret4_11, align 8
  %_ret4_12 = load %_anon0_struct*, %_anon0_struct** %_ret4_11, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_ret4_12, i32 0, i32 0
  %function_call = load i32 ()*, i32 ()** %function_access, align 8
  %function_result = call i32 %function_call()
  ret i32 %function_result
}

define i32 @_anon0() {
entry:
  ret i32 4
}
