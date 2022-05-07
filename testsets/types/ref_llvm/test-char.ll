; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@globalChar = private unnamed_addr constant [2 x i8] c"a\00", align 1
@globalChar.1 = private unnamed_addr constant [2 x i8] c" \00", align 1
@globalChar.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  %spc1 = alloca i8*, align 8
  %loc2 = getelementptr i8*, i8** %spc1, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.1, i32 0, i32 0), i8** %loc2, align 8
  %character_ptr3 = load i8*, i8** %spc1, align 8
  %spc4 = alloca i8*, align 8
  %loc5 = getelementptr i8*, i8** %spc4, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.2, i32 0, i32 0), i8** %loc5, align 8
  %character_ptr6 = load i8*, i8** %spc4, align 8
  ret i32 0
}
