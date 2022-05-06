; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@globalChar = private unnamed_addr constant [2 x i8] c"H\00", align 1
@globalChar.1 = private unnamed_addr constant [2 x i8] c"e\00", align 1
@globalChar.2 = private unnamed_addr constant [2 x i8] c"l\00", align 1
@globalChar.3 = private unnamed_addr constant [2 x i8] c"l\00", align 1
@globalChar.4 = private unnamed_addr constant [2 x i8] c"o\00", align 1
@globalChar.5 = private unnamed_addr constant [2 x i8] c" \00", align 1
@globalChar.6 = private unnamed_addr constant [2 x i8] c"W\00", align 1
@globalChar.7 = private unnamed_addr constant [2 x i8] c"o\00", align 1
@globalChar.8 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@globalChar.9 = private unnamed_addr constant [2 x i8] c"l\00", align 1
@globalChar.10 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@globalChar.11 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@globalChar.12 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  %printc = call i32 @puts(i8* %character_ptr)
  %spc1 = alloca i8*, align 8
  %loc2 = getelementptr i8*, i8** %spc1, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.1, i32 0, i32 0), i8** %loc2, align 8
  %character_ptr3 = load i8*, i8** %spc1, align 8
  %printc4 = call i32 @puts(i8* %character_ptr3)
  %spc5 = alloca i8*, align 8
  %loc6 = getelementptr i8*, i8** %spc5, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.2, i32 0, i32 0), i8** %loc6, align 8
  %character_ptr7 = load i8*, i8** %spc5, align 8
  %printc8 = call i32 @puts(i8* %character_ptr7)
  %spc9 = alloca i8*, align 8
  %loc10 = getelementptr i8*, i8** %spc9, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.3, i32 0, i32 0), i8** %loc10, align 8
  %character_ptr11 = load i8*, i8** %spc9, align 8
  %printc12 = call i32 @puts(i8* %character_ptr11)
  %spc13 = alloca i8*, align 8
  %loc14 = getelementptr i8*, i8** %spc13, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.4, i32 0, i32 0), i8** %loc14, align 8
  %character_ptr15 = load i8*, i8** %spc13, align 8
  %printc16 = call i32 @puts(i8* %character_ptr15)
  %spc17 = alloca i8*, align 8
  %loc18 = getelementptr i8*, i8** %spc17, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.5, i32 0, i32 0), i8** %loc18, align 8
  %character_ptr19 = load i8*, i8** %spc17, align 8
  %printc20 = call i32 @puts(i8* %character_ptr19)
  %spc21 = alloca i8*, align 8
  %loc22 = getelementptr i8*, i8** %spc21, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.6, i32 0, i32 0), i8** %loc22, align 8
  %character_ptr23 = load i8*, i8** %spc21, align 8
  %printc24 = call i32 @puts(i8* %character_ptr23)
  %spc25 = alloca i8*, align 8
  %loc26 = getelementptr i8*, i8** %spc25, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.7, i32 0, i32 0), i8** %loc26, align 8
  %character_ptr27 = load i8*, i8** %spc25, align 8
  %printc28 = call i32 @puts(i8* %character_ptr27)
  %spc29 = alloca i8*, align 8
  %loc30 = getelementptr i8*, i8** %spc29, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.8, i32 0, i32 0), i8** %loc30, align 8
  %character_ptr31 = load i8*, i8** %spc29, align 8
  %printc32 = call i32 @puts(i8* %character_ptr31)
  %spc33 = alloca i8*, align 8
  %loc34 = getelementptr i8*, i8** %spc33, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.9, i32 0, i32 0), i8** %loc34, align 8
  %character_ptr35 = load i8*, i8** %spc33, align 8
  %printc36 = call i32 @puts(i8* %character_ptr35)
  %spc37 = alloca i8*, align 8
  %loc38 = getelementptr i8*, i8** %spc37, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.10, i32 0, i32 0), i8** %loc38, align 8
  %character_ptr39 = load i8*, i8** %spc37, align 8
  %printc40 = call i32 @puts(i8* %character_ptr39)
  %spc41 = alloca i8*, align 8
  %loc42 = getelementptr i8*, i8** %spc41, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.11, i32 0, i32 0), i8** %loc42, align 8
  %character_ptr43 = load i8*, i8** %spc41, align 8
  %printc44 = call i32 @puts(i8* %character_ptr43)
  %spc45 = alloca i8*, align 8
  %loc46 = getelementptr i8*, i8** %spc45, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.12, i32 0, i32 0), i8** %loc46, align 8
  %character_ptr47 = load i8*, i8** %spc45, align 8
  %printc48 = call i32 @puts(i8* %character_ptr47)
  ret i32 0
}
