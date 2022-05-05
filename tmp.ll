; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon1_struct = type { i32 (i32, i32)* }
%_anon0_struct = type { i32 (i32, i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@"_+_2" = global %_anon1_struct* null
@"_+_1" = global %_anon0_struct* null
@__anon0_1 = global i32 (i32, i32)* null
@__anon1_1 = global i32 (i32, i32)* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32, i32)* @_anon0, i32 (i32, i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @"_+_1", align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 (i32, i32)* @_anon1, i32 (i32, i32)** %funcField2, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @"_+_2", align 8
  %"_+_2" = load %_anon1_struct*, %_anon1_struct** @"_+_2", align 8
  %function_access = getelementptr inbounds %_anon1_struct, %_anon1_struct* %"_+_2", i32 0, i32 0
  %function_call = load i32 (i32, i32)*, i32 (i32, i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 1, i32 222)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %function_result)
  ret i32 0
}

define i32 @_anon1(i32 %x, i32 %y) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %y2 = alloca i32, align 4
  store i32 %y, i32* %y2, align 4
  %x3 = load i32, i32* %x1, align 4
  ret i32 %x3
}

define i32 @_anon0(i32 %x, i32 %y) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %y2 = alloca i32, align 4
  store i32 %y, i32* %y2, align 4
  %x3 = load i32, i32* %x1, align 4
  ret i32 %x3
}
