; ModuleID = 'gROOT'
source_filename = "gROOT"

%tree_struct = type { i32, %tree_struct*, %tree_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@hello = private unnamed_addr constant [15 x i8] c"Hello, world!\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @main(%tree_struct %0) {
entry:
  %print_hello = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @hello, i32 0, i32 0))
  ret void
}
