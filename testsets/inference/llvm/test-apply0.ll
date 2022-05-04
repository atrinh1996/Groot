; ModuleID = 'gROOT'
source_filename = "gROOT"

%anon0_struct = type { i32 (i32)* }
%anon1_struct = type { i32 (%anon0_struct*)*, %anon0_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_anon0_1 = global i32 (i32)* null
@_anon1_1 = global i32 (%anon0_struct*)* null
@_retn_1 = global %anon0_struct* null
@_test_1 = global %anon1_struct* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %anon0_struct, align 8
  %funcField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @anon0, i32 (i32)** %funcField, align 8
  store %anon0_struct* %gstruct, %anon0_struct** @_retn_1, align 8
  %gstruct1 = alloca %anon1_struct, align 8
  %funcField2 = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (%anon0_struct*)* @anon1, i32 (%anon0_struct*)** %funcField2, align 8
  %_retn_1 = load %anon0_struct*, %anon0_struct** @_retn_1, align 8
  %freeField = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct1, i32 0, i32 1
  store %anon0_struct* %_retn_1, %anon0_struct** %freeField, align 8
  store %anon1_struct* %gstruct1, %anon1_struct** @_test_1, align 8
  ret i32 0
}

define i32 @anon1(%anon0_struct* %_retn_1) {
entry:
  %_retn_11 = alloca %anon0_struct*, align 8
  store %anon0_struct* %_retn_1, %anon0_struct** %_retn_11, align 8
  %_retn_12 = load %anon0_struct*, %anon0_struct** %_retn_11, align 8
  %function_access = getelementptr inbounds %anon0_struct, %anon0_struct* %_retn_12, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 5)
  ret i32 %function_result
}

define i32 @anon0(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %n2 = load i32, i32* %n1, align 4
  ret i32 %n2
}
