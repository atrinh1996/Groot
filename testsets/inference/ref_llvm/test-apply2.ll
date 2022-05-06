; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32)* }
%_anon0_struct = type { i32 (i32)* }
%_anon3_struct = type { i32 (i32, i32)* }
%_anon2_struct = type { i32 (%_anon1_struct*)*, %_anon1_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null
@__anon1_1 = global i32 (i32)* null
@__anon2_1 = global i32 (%_anon1_struct*)* null
@__anon3_1 = global i32 (i32, i32)* null
@_retn_2 = global %_anon1_struct* null
@_retn_1 = global %_anon0_struct* null
@_t_1 = global %_anon3_struct* null
@_test_1 = global %_anon2_struct* null

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
  store i32 (i32)* @_anon1, i32 (i32)** %funcField2, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_retn_2, align 8
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store i32 (%_anon1_struct*)* @_anon2, i32 (%_anon1_struct*)** %funcField4, align 8
  %_retn_2 = load %_anon1_struct*, %_anon1_struct** @_retn_2, align 8
  %freeField = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 1
  store %_anon1_struct* %_retn_2, %_anon1_struct** %freeField, align 8
  store %_anon2_struct* %gstruct3, %_anon2_struct** @_test_1, align 8
  %_test_1 = load %_anon2_struct*, %_anon2_struct** @_test_1, align 8
  %freePtr = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_test_1, i32 0, i32 1
  %freeVal = load %_anon1_struct*, %_anon1_struct** %freePtr, align 8
  %function_access = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_test_1, i32 0, i32 0
  %function_call = load i32 (%_anon1_struct*)*, i32 (%_anon1_struct*)** %function_access, align 8
  %function_result = call i32 %function_call(%_anon1_struct* %freeVal)
  %gstruct5 = alloca %_anon3_struct, align 8
  %funcField6 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 0
  store i32 (i32, i32)* @_anon3, i32 (i32, i32)** %funcField6, align 8
  store %_anon3_struct* %gstruct5, %_anon3_struct** @_t_1, align 8
  ret i32 0
}

define i32 @_anon3(i32 %n, i32 %e) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %e2 = alloca i32, align 4
  store i32 %e, i32* %e2, align 4
  %e3 = load i32, i32* %e2, align 4
  ret i32 %e3
}

define i32 @_anon2(%_anon1_struct* %_retn_2) {
entry:
  %_retn_21 = alloca %_anon1_struct*, align 8
  store %_anon1_struct* %_retn_2, %_anon1_struct** %_retn_21, align 8
  %_retn_22 = load %_anon1_struct*, %_anon1_struct** %_retn_21, align 8
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_retn_22, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 5)
  ret i32 %function_result
}

define i32 @_anon1(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %n2 = load i32, i32* %n1, align 4
  ret i32 %n2
}

define i32 @_anon0(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %n2 = load i32, i32* %n1, align 4
  ret i32 %n2
}
