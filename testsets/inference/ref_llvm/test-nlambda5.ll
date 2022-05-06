; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32, i32)*, i32 }
%_anon0_struct = type { %_anon1_struct* (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global %_anon1_struct* (i32)* null
@__anon1_1 = global i32 (i32, i32)* null
@_testAB_1 = global %_anon0_struct* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store %_anon1_struct* (i32)* @_anon0, %_anon1_struct* (i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_testAB_1, align 8
  %_testAB_1 = load %_anon0_struct*, %_anon0_struct** @_testAB_1, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_testAB_1, i32 0, i32 0
  %function_call = load %_anon1_struct* (i32)*, %_anon1_struct* (i32)** %function_access, align 8
  %function_result = call %_anon1_struct* %function_call(i32 9)
  %freePtr = getelementptr inbounds %_anon1_struct, %_anon1_struct* %function_result, i32 0, i32 1
  %freeVal = load i32, i32* %freePtr, align 4
  %function_access1 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %function_result, i32 0, i32 0
  %function_call2 = load i32 (i32, i32)*, i32 (i32, i32)** %function_access1, align 8
  %function_result3 = call i32 %function_call2(i32 8, i32 %freeVal)
  ret i32 0
}

define %_anon1_struct* @_anon0(i32 %a) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %gstruct = alloca %_anon1_struct, align 8
  %funcField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField, align 8
  %a2 = load i32, i32* %a1, align 4
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 1
  store i32 %a2, i32* %freeField, align 4
  ret %_anon1_struct* %gstruct
}

define i32 @_anon1(i32 %b, i32 %a) {
entry:
  %b1 = alloca i32, align 4
  store i32 %b, i32* %b1, align 4
  %a2 = alloca i32, align 4
  store i32 %a, i32* %a2, align 4
  %a3 = load i32, i32* %a2, align 4
  %b4 = load i32, i32* %b1, align 4
  %"+" = add i32 %a3, %b4
  ret i32 %"+"
}
