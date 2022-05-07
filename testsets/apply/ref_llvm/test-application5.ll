; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon2_struct = type { i32 (i32, i32)* }
%_anon1_struct = type { i32 (i32, i32)* }
%_anon0_struct = type { i32 (i32, i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32, i32)* null
@__anon1_1 = global i32 (i32, i32)* null
@__anon2_1 = global i32 (i32, i32)* null
@_retn_3 = global %_anon2_struct* null
@_retn_2 = global %_anon1_struct* null
@_retn_1 = global %_anon0_struct* null
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 79, i32* @_x_1, align 4
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon0, i32 (i32, i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_retn_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField2, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_retn_2, align 8
  %_retn_2 = load %_anon1_struct*, %_anon1_struct** @_retn_2, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_retn_2, i32 0, i32 0
  %function_call = load i32 (i32, i32)*, i32 (i32, i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %_x_1, i32 9)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store i32 (i32, i32)* @_anon2, i32 (i32, i32)** %funcField4, align 8
  store %_anon2_struct* %gstruct3, %_anon2_struct** @_retn_3, align 8
  %_retn_3 = load %_anon2_struct*, %_anon2_struct** @_retn_3, align 8
  %function_access5 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_retn_3, i32 0, i32 0
  %function_call6 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access5, align 8
  %function_result7 = call i32 %function_call6(i32 7, i32 9)
  %printi8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result7)
  ret i32 0
}

define i32 @_anon2(i32 %n, i32 %m) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %n3 = load i32, i32* %n1, align 4
  ret i32 %n3
}

define i32 @_anon1(i32 %n, i32 %m) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %n3 = load i32, i32* %n1, align 4
  ret i32 %n3
}

define i32 @_anon0(i32 %n, i32 %m) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %n3 = load i32, i32* %n1, align 4
  ret i32 %n3
}
