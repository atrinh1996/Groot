; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i32 (i32)* }
%_anon1_struct = type { i32 (%_anon0_struct*)*, %_anon0_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null
@__anon1_1 = global i32 (%_anon0_struct*)* null
@_retn_1 = global %_anon0_struct* null
@_test_1 = global %_anon1_struct* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon0, i32 (i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_retn_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (%_anon0_struct*)* @_anon1, i32 (%_anon0_struct*)** %funcField2, align 8
  %_retn_1 = load %_anon0_struct*, %_anon0_struct** @_retn_1, align 8
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 1
  store %_anon0_struct* %_retn_1, %_anon0_struct** %freeField, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_test_1, align 8
  ret i32 0
}

define i32 @_anon1(%_anon0_struct* %_retn_1) {
entry:
  %_retn_11 = alloca %_anon0_struct*, align 8
  store %_anon0_struct* %_retn_1, %_anon0_struct** %_retn_11, align 8
  %_retn_12 = load %_anon0_struct*, %_anon0_struct** %_retn_11, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_retn_12, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 5)
  ret i32 %function_result
}

define i32 @_anon0(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %n2 = load i32, i32* %n1, align 4
  ret i32 %n2
}
