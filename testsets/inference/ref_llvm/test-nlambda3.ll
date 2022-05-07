; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon3_struct = type { i32 (i32, %_anon1_struct*, i32)*, %_anon1_struct*, i32 }
%_anon1_struct = type { i32 (i32, i32)* }
%_anon0_struct = type { i32 (i32, i32)* }
%_anon2_struct = type { %_anon3_struct* (i32, %_anon1_struct*)*, %_anon1_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32, i32)* null
@__anon1_1 = global i32 (i32, i32)* null
@__anon2_1 = global %_anon3_struct* (i32, %_anon1_struct*)* null
@__anon3_1 = global i32 (i32, %_anon1_struct*, i32)* null
@_retn_2 = global %_anon1_struct* null
@_retn_1 = global %_anon0_struct* null
@_test_1 = global %_anon2_struct* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon0, i32 (i32, i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_retn_1, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField2, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_retn_2, align 8
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store %_anon3_struct* (i32, %_anon1_struct*)* @_anon2, %_anon3_struct* (i32, %_anon1_struct*)** %funcField4, align 8
  %_retn_2 = load %_anon1_struct*, %_anon1_struct** @_retn_2, align 8
  %freeField = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 1
  store %_anon1_struct* %_retn_2, %_anon1_struct** %freeField, align 8
  store %_anon2_struct* %gstruct3, %_anon2_struct** @_test_1, align 8
  ret i32 0
}

define %_anon3_struct* @_anon2(i32 %a, %_anon1_struct* %_retn_2) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %_retn_22 = alloca %_anon1_struct*, align 8
  store %_anon1_struct* %_retn_2, %_anon1_struct** %_retn_22, align 8
  %gstruct = alloca %_anon3_struct, align 8
  %funcField = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct, i32 0, i32 0
  store i32 (i32, %_anon1_struct*, i32)* @_anon3, i32 (i32, %_anon1_struct*, i32)** %funcField, align 8
  %_retn_23 = load %_anon1_struct*, %_anon1_struct** %_retn_22, align 8
  %a4 = load i32, i32* %a1, align 4
  %freeField = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct, i32 0, i32 1
  %freeField5 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct, i32 0, i32 2
  store %_anon1_struct* %_retn_23, %_anon1_struct** %freeField, align 8
  store i32 %a4, i32* %freeField5, align 4
  ret %_anon3_struct* %gstruct
}

define i32 @_anon3(i32 %b, %_anon1_struct* %_retn_2, i32 %a) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %_retn_22 = alloca %_anon1_struct*, align 8
  store %_anon1_struct* %_retn_2, %_anon1_struct** %_retn_22, align 8
  %a3 = alloca i32, align 4
  store i32 %a, i32* %a3, align 4
  %_retn_24 = load %_anon1_struct*, %_anon1_struct** %_retn_22, align 8
  %a5 = load i32, i32* %a3, align 4
  %b6 = load i32, i32* %b1, align 4
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_retn_24, i32 0, i32 0
  %function_call = load i32 (i32, i32)*, i32 (i32, i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 %a5, i32 %b6)
  ret i32 %function_result
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
