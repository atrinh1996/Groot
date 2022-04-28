; ModuleID = 'gROOT'
source_filename = "gROOT"

%tree_struct = type { i32, %tree_struct*, %tree_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define void @main(%tree_struct %0) {
entry:
  %printb = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolT, i32 0, i32 0))
  ret void
}
