; ModuleID = 'gROOT'
source_filename = "gROOT"

%anon1_struct = type { i32 (i32, i32)* }
%anon0_struct = type { i32 (i32, i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_anon0_1 = global i32 (i32, i32)* null
@_anon1_1 = global i32 (i32, i32)* null
@_retn_2 = global %anon1_struct* null
@_retn_1 = global %anon0_struct* null
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 79, i32* @_x_1, align 4
  %gstruct = alloca %anon0_struct, align 8
  %funcField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @anon0, i32 (i32, i32)** %funcField, align 8
  store %anon0_struct* %gstruct, %anon0_struct** @_retn_1, align 8
  %_retn_1 = load %anon0_struct*, %anon0_struct** @_retn_1, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %function_access = getelementptr inbounds %anon0_struct, %anon0_struct* %_retn_1, i32 0, i32 0
  %function_call = load i32 (i32, i32)*, i32 (i32, i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %_x_1, i32 9)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  %gstruct1 = alloca %anon1_struct, align 8
  %funcField2 = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (i32, i32)* @anon1, i32 (i32, i32)** %funcField2, align 8
  store %anon1_struct* %gstruct1, %anon1_struct** @_retn_2, align 8
  %_retn_2 = load %anon1_struct*, %anon1_struct** @_retn_2, align 8
  %function_access3 = getelementptr inbounds %anon1_struct, %anon1_struct* %_retn_2, i32 0, i32 0
  %function_call4 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access3, align 8
  %function_result5 = call i32 %function_call4(i32 7, i32 9)
  %printi6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result5)
  ret i32 0
}

define i32 @anon1(i32 %n, i32 %m) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %n3 = load i32, i32* %n1, align 4
  ret i32 %n3
}

define i32 @anon0(i32 %n, i32 %m) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %n3 = load i32, i32* %n1, align 4
  ret i32 %n3
}
