; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32)*, i32 }
%_anon0_struct = type { i32 (i32)*, i32 }
%_anon3_struct = type { i32 (i32, i32, i32)*, i32 }
%_anon2_struct = type { i32 (i32, i32, i32)*, i32 }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null
@__anon1_1 = global i32 (i32)* null
@__anon2_1 = global i32 (i32, i32, i32)* null
@__anon3_1 = global i32 (i32, i32, i32)* null
@_retx_2 = global %_anon1_struct* null
@_retx_1 = global %_anon0_struct* null
@_retx2_2 = global %_anon3_struct* null
@_retx2_1 = global %_anon2_struct* null
@_x_2 = global i32 0
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 42, i32* @_x_1, align 4
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon0, i32 (i32)** %funcField, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %freeField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 1
  store i32 %_x_1, i32* %freeField, align 4
  store %_anon0_struct* %gstruct, %_anon0_struct** @_retx_1, align 8
  %_retx_1 = load %_anon0_struct*, %_anon0_struct** @_retx_1, align 8
  %freePtr = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx_1, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx_1, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %freeVal)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  store i32 12, i32* @_x_2, align 4
  %_retx_11 = load %_anon0_struct*, %_anon0_struct** @_retx_1, align 8
  %freePtr2 = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx_11, i32 0, i32 1
  %freeVal3 = load i32, i32* %freePtr2, align 4
  %function_access4 = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx_11, i32 0, i32 0
  %function_call5 = load i32 (i32)*, i32 (i32)** %function_access4, align 8
  %function_result6 = call i32 %function_call5(i32 %freeVal3)
  %printi7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result6)
  %gstruct8 = alloca %_anon1_struct, align 8
  %funcField9 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct8, i32 0, i32 0
  store i32 (i32)* @_anon1, i32 (i32)** %funcField9, align 8
  %_x_2 = load i32, i32* @_x_2, align 4
  %freeField10 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct8, i32 0, i32 1
  store i32 %_x_2, i32* %freeField10, align 4
  store %_anon1_struct* %gstruct8, %_anon1_struct** @_retx_2, align 8
  %_retx_2 = load %_anon1_struct*, %_anon1_struct** @_retx_2, align 8
  %freePtr11 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_retx_2, i32 0, i32 1
  %freeVal12 = load i32, i32* %freePtr11, align 4
  %function_access13 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_retx_2, i32 0, i32 0
  %function_call14 = load i32 (i32)*, i32 (i32)** %function_access13, align 8
  %function_result15 = call i32 %function_call14(i32 %freeVal12)
  %printi16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result15)
  %gstruct17 = alloca %_anon2_struct, align 8
  %funcField18 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct17, i32 0, i32 0
  store i32 (i32, i32, i32)* @_anon2, i32 (i32, i32, i32)** %funcField18, align 8
  %_x_219 = load i32, i32* @_x_2, align 4
  %freeField20 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct17, i32 0, i32 1
  store i32 %_x_219, i32* %freeField20, align 4
  store %_anon2_struct* %gstruct17, %_anon2_struct** @_retx2_1, align 8
  %gstruct21 = alloca %_anon3_struct, align 8
  %funcField22 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct21, i32 0, i32 0
  store i32 (i32, i32, i32)* @_anon3, i32 (i32, i32, i32)** %funcField22, align 8
  %_x_223 = load i32, i32* @_x_2, align 4
  %freeField24 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct21, i32 0, i32 1
  store i32 %_x_223, i32* %freeField24, align 4
  store %_anon3_struct* %gstruct21, %_anon3_struct** @_retx2_2, align 8
  %_retx2_2 = load %_anon3_struct*, %_anon3_struct** @_retx2_2, align 8
  %freePtr25 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_retx2_2, i32 0, i32 1
  %freeVal26 = load i32, i32* %freePtr25, align 4
  %function_access27 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %_retx2_2, i32 0, i32 0
  %function_call28 = load i32 (i32, i32, i32)*, i32 (i32, i32, i32)** %function_access27, align 8
  %function_result29 = call i32 %function_call28(i32 9, i32 8, i32 %freeVal26)
  %printi30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result29)
  ret i32 0
}

define i32 @_anon3(i32 %n, i32 %m, i32 %_x_2) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %_x_23 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_23, align 4
  %_x_24 = load i32, i32* %_x_23, align 4
  ret i32 %_x_24
}

define i32 @_anon2(i32 %n, i32 %m, i32 %_x_2) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %_x_23 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_23, align 4
  %_x_24 = load i32, i32* %_x_23, align 4
  ret i32 %_x_24
}

define i32 @_anon1(i32 %_x_2) {
entry:
  %_x_21 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_21, align 4
  %_x_22 = load i32, i32* %_x_21, align 4
  ret i32 %_x_22
}

define i32 @_anon0(i32 %_x_1) {
entry:
  %_x_11 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_11, align 4
  %_x_12 = load i32, i32* %_x_11, align 4
  ret i32 %_x_12
}
