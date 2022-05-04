; ModuleID = 'gROOT'
source_filename = "gROOT"

%anon0_struct = type { i32 ()* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_anon0_1 = global i32 ()* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %anon0_struct, align 8
  %funcField = getelementptr inbounds %anon0_struct, %anon0_struct* %gstruct, i32 0, i32 0
  store i32 ()* @anon0, i32 ()** %funcField, align 8
  ret i32 0
}

define i32 @anon0() {
entry:
  ret i32 4
}
