; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@globalChar = private unnamed_addr constant [2 x i8] c"H\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define void @main() {
entry:
  %spc = alloca i8*

  %loc = getelementptr inbounds i8*, i8** %spc, i32 0

  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc

  %charA = load i8*, i8** %spc

  %printc = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.1, i32 0, i32 0), i8* %charA)

  ret void
}