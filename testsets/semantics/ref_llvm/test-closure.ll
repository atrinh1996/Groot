; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i32 (i32)*, i32 }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null
@_retx1_1 = global %_anon0_struct* null
@_x_2 = global i32 0
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 1, i32* @_x_1, align 4
  %_x_1 = load i32, i32* @_x_1, align 4
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %_x_1)
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon0, i32 (i32)** %funcField, align 8
  %_x_11 = load i32, i32* @_x_1, align 4
  %freeField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 1
  store i32 %_x_11, i32* %freeField, align 4
  store %_anon0_struct* %gstruct, %_anon0_struct** @_retx1_1, align 8
  %_retx1_1 = load %_anon0_struct*, %_anon0_struct** @_retx1_1, align 8
  %freePtr = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx1_1, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx1_1, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %freeVal)
  %printi2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  store i32 42, i32* @_x_2, align 4
  %_x_2 = load i32, i32* @_x_2, align 4
  %printi3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %_x_2)
  %_retx1_14 = load %_anon0_struct*, %_anon0_struct** @_retx1_1, align 8
  %freePtr5 = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx1_14, i32 0, i32 1
  %freeVal6 = load i32, i32* %freePtr5, align 4
  %function_access7 = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retx1_14, i32 0, i32 0
  %function_call8 = load i32 (i32)*, i32 (i32)** %function_access7, align 8
  %function_result9 = call i32 %function_call8(i32 %freeVal6)
  %printi10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result9)
  ret i32 0
}

define i32 @_anon0(i32 %_x_1) {
entry:
  %_x_11 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_11, align 4
  %_x_12 = load i32, i32* %_x_11, align 4
  ret i32 %_x_12
}
