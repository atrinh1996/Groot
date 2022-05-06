; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@globalChar = private unnamed_addr constant [2 x i8] c"a\00", align 1
@globalChar.1 = private unnamed_addr constant [2 x i8] c"b\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %if-res-ptr = alloca i32, align 4
  %if-res-ptr1 = alloca i1, align 1
  br i1 true, label %then, label %else
  br i1 %if-res-val, label %then3, label %else4

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr1, align 1

then:                                             ; preds = %entry
  store i1 true, i1* %if-res-ptr1, align 1
  br label %merge

else:                                             ; preds = %entry
  store i1 false, i1* %if-res-ptr1, align 1
  br label %merge

merge2:                                           ; preds = %else4, %then3
  %if-res-val9 = load i32, i32* %if-res-ptr, align 4
  ret i32 0

then3:                                            ; preds = %entry
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  %printc = call i32 @puts(i8* %character_ptr)
  store i32 %printc, i32* %if-res-ptr, align 4
  br label %merge2

else4:                                            ; preds = %entry
  %spc5 = alloca i8*, align 8
  %loc6 = getelementptr i8*, i8** %spc5, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.1, i32 0, i32 0), i8** %loc6, align 8
  %character_ptr7 = load i8*, i8** %spc5, align 8
  %printc8 = call i32 @puts(i8* %character_ptr7)
  store i32 %printc8, i32* %if-res-ptr, align 4
  br label %merge2
}
