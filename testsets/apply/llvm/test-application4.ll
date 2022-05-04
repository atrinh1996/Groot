; ModuleID = 'gROOT'
source_filename = "gROOT"

%anon1_struct = type { i32 (i32)*, i32 }
%anon0_struct = type { i32 (i32)*, i32 }
%anon2_struct = type { i32 (i32, i32, i32)*, i32 }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_anon0_1 = global i32 (i32)* null
@_anon1_1 = global i32 (i32)* null
@_anon2_1 = global i32 (i32, i32, i32)* null
@_retx_2 = global %anon1_struct* null
@_retx_1 = global %anon0_struct* null
@_retx2_1 = global %anon2_struct* null
@_x_2 = global i32 0
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 42, i32* @_x_1, align 4
  %gstruct = alloca %anon0_struct, align 8
  %funcField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @anon0, i32 (i32)** %funcField, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %freeField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 1
  store i32 %_x_1, i32* %freeField, align 4
  store %anon0_struct* %gstruct, %anon0_struct** @_retx_1, align 8
  %_retx_1 = load %anon0_struct*, %anon0_struct** @_retx_1, align 8
  %freePtr = getelementptr inbounds %anon0_struct, %anon0_struct* %_retx_1, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %anon0_struct, %anon0_struct* %_retx_1, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %freeVal)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  store i32 12, i32* @_x_2, align 4
  %_retx_11 = load %anon0_struct*, %anon0_struct** @_retx_1, align 8
  %freePtr2 = getelementptr inbounds %anon0_struct, %anon0_struct* %_retx_11, i32 0, i32 1
  %freeVal3 = load i32, i32* %freePtr2, align 4
  %function_access4 = getelementptr inbounds %anon0_struct, %anon0_struct* %_retx_11, i32 0, i32 0
  %function_call5 = load i32 (i32)*, i32 (i32)** %function_access4, align 8
  %function_result6 = call i32 %function_call5(i32 %freeVal3)
  %printi7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result6)
  %gstruct8 = alloca %anon1_struct, align 8
  %funcField9 = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct8, i32 0, i32 0
  store i32 (i32)* @anon1, i32 (i32)** %funcField9, align 8
  %_x_2 = load i32, i32* @_x_2, align 4
  %freeField10 = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct8, i32 0, i32 1
  store i32 %_x_2, i32* %freeField10, align 4
  store %anon1_struct* %gstruct8, %anon1_struct** @_retx_2, align 8
  %_retx_2 = load %anon1_struct*, %anon1_struct** @_retx_2, align 8
  %freePtr11 = getelementptr inbounds %anon1_struct, %anon1_struct* %_retx_2, i32 0, i32 1
  %freeVal12 = load i32, i32* %freePtr11, align 4
  %function_access13 = getelementptr inbounds %anon1_struct, %anon1_struct* %_retx_2, i32 0, i32 0
  %function_call14 = load i32 (i32)*, i32 (i32)** %function_access13, align 8
  %function_result15 = call i32 %function_call14(i32 %freeVal12)
  %printi16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result15)
  %gstruct17 = alloca %anon2_struct, align 8
  %funcField18 = getelementptr inbounds %anon2_struct, %anon2_struct* %gstruct17, i32 0, i32 0
  store i32 (i32, i32, i32)* @anon2, i32 (i32, i32, i32)** %funcField18, align 8
  %_x_219 = load i32, i32* @_x_2, align 4
  %freeField20 = getelementptr inbounds %anon2_struct, %anon2_struct* %gstruct17, i32 0, i32 1
  store i32 %_x_219, i32* %freeField20, align 4
  store %anon2_struct* %gstruct17, %anon2_struct** @_retx2_1, align 8
  %_retx2_1 = load %anon2_struct*, %anon2_struct** @_retx2_1, align 8
  %freePtr21 = getelementptr inbounds %anon2_struct, %anon2_struct* %_retx2_1, i32 0, i32 1
  %freeVal22 = load i32, i32* %freePtr21, align 4
  %function_access23 = getelementptr inbounds %anon2_struct, %anon2_struct* %_retx2_1, i32 0, i32 0
  %function_call24 = load i32 (i32, i32, i32)*, i32 (i32, i32, i32)** %function_access23, align 8
  %function_result25 = call i32 %function_call24(i32 9, i32 8, i32 %freeVal22)
  %printi26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result25)
  ret i32 0
}

define i32 @anon2(i32 %n, i32 %m, i32 %_x_2) {
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

define i32 @anon1(i32 %_x_2) {
entry:
  %_x_21 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_21, align 4
  %_x_22 = load i32, i32* %_x_21, align 4
  ret i32 %_x_22
}

define i32 @anon0(i32 %_x_1) {
entry:
  %_x_11 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_11, align 4
  %_x_12 = load i32, i32* %_x_11, align 4
  ret i32 %_x_12
}
