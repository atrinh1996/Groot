; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_a_1 = global i8* null
@_b_1 = global i8* null
@globalChar = private unnamed_addr constant [2 x i8] c"a\00", align 1
@globalChar.1 = private unnamed_addr constant [2 x i8] c"b\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  store i8* %character_ptr, i8** @_a_1, align 8
  %spc1 = alloca i8*, align 8
  %loc2 = getelementptr i8*, i8** %spc1, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.1, i32 0, i32 0), i8** %loc2, align 8
  %character_ptr3 = load i8*, i8** %spc1, align 8
  store i8* %character_ptr3, i8** @_b_1, align 8
  %if-res-ptr = alloca i8*, align 8
  %if-res-ptr4 = alloca i1, align 1
  br i1 true, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr4, align 1
  br i1 %if-res-val, label %then6, label %else7

then:                                             ; preds = %entry
  store i1 true, i1* %if-res-ptr4, align 1
  br label %merge

else:                                             ; preds = %entry
  store i1 false, i1* %if-res-ptr4, align 1
  br label %merge

merge5:                                           ; preds = %else7, %then6
  %if-res-val9 = load i8*, i8** %if-res-ptr, align 8
  ret i32 0

then6:                                            ; preds = %merge
  %_a_1 = load i8*, i8** @_a_1, align 8
  %printc = call i32 @puts(i8* %_a_1)
  store i32 %printc, i8** %if-res-ptr, align 4
  br label %merge5

else7:                                            ; preds = %merge
  %_b_1 = load i8*, i8** @_b_1, align 8
  %printc8 = call i32 @puts(i8* %_b_1)
  store i32 %printc8, i8** %if-res-ptr, align 4
  br label %merge5
}
