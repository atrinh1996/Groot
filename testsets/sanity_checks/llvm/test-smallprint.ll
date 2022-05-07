; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_x_2 = global i32 0
@_x_1 = global i32 0
@globalChar = private unnamed_addr constant [2 x i8] c"c\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 42, i32* @_x_1, align 4
  %_x_1 = load i32, i32* @_x_1, align 4
  %_x_11 = load i32, i32* @_x_1, align 4
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %_x_11)
  store i32 12, i32* @_x_2, align 4
  %_x_2 = load i32, i32* @_x_2, align 4
  %_x_22 = load i32, i32* @_x_2, align 4
  %printi3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %_x_22)
  %if-res-ptr = alloca i8*, align 8
  br i1 true, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i8*, i8** %if-res-ptr, align 8
  ret i32 0

then:                                             ; preds = %entry
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  %printc = call i32 @puts(i8* %character_ptr)
  store i32 %printc, i8** %if-res-ptr, align 4
  br label %merge

else:                                             ; preds = %entry
  %_x_24 = load i32, i32* @_x_2, align 4
  %printi5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %_x_24)
  store i32 %printi5, i8** %if-res-ptr, align 4
  br label %merge
}
