; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32, i32)*, i32 }
%_anon0_struct = type { %_anon1_struct* (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global %_anon1_struct* (i32)* null
@__anon1_1 = global i32 (i32, i32)* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store %_anon1_struct* (i32)* @_anon0, %_anon1_struct* (i32)** %funcField, align 8
  ret i32 0
}

define %_anon1_struct* @_anon0(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %gstruct = alloca %_anon1_struct, align 8
  %funcField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField, align 8
  %n2 = load i32, i32* %n1, align 4
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct, i32 0, i32 1
  store i32 %n2, i32* %freeField, align 4
  ret %_anon1_struct* %gstruct
}

define i32 @_anon1(i32 %x, i32 %n) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %n2 = alloca i32, align 4
  store i32 %n, i32* %n2, align 4
  %x3 = load i32, i32* %x1, align 4
  %n4 = load i32, i32* %n2, align 4
  %addition = add i32 %x3, %n4
  ret i32 %addition
}
