; ModuleID = 'gROOT'
source_filename = "gROOT"

%anon1_struct = type { i32 (i32, i32)*, i32 }
%anon0_struct = type { %anon1_struct* (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_anon0_1 = global %anon1_struct* (i32)* null
@_anon1_1 = global i32 (i32, i32)* null
@_testAB_1 = global %anon0_struct* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %anon0_struct, align 8
  %funcField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 0
  store %anon1_struct* (i32)* @anon0, %anon1_struct* (i32)** %funcField, align 8
  store %anon0_struct* %gstruct, %anon0_struct** @_testAB_1, align 8
  ret i32 0
}

define %anon1_struct* @anon0(i32 %a) {
entry:
  %a1 = alloca i32, align 4
  store i32 %a, i32* %a1, align 4
  %gstruct = alloca %anon1_struct, align 8
  %funcField = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @anon1, i32 (i32, i32)** %funcField, align 8
  %a2 = load i32, i32* %a1, align 4
  %freeField = getelementptr inbounds %anon1_struct, %anon1_struct* %gstruct, i32 0, i32 1
  store i32 %a2, i32* %freeField, align 4
  ret %anon1_struct* %gstruct
}

define i32 @anon1(i32 %b, i32 %a) {
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
