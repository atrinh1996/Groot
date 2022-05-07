; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i32 (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i32)* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i32)* @_anon0, i32 (i32)** %funcField, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  %function_call = load i32 (i32)*, i32 (i32)** %function_access, align 8
  %function_result = call i32 %function_call(i32 6)
  ret i32 0
}

define i32 @_anon0(i32 %n) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %n2 = load i32, i32* %n1, align 4
  ret i32 %n2
}
