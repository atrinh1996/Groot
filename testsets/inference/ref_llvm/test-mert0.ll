; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 3, i32* @_x_1, align 4
  %if-res-ptr = alloca i32, align 4
  br i1 true, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i32, i32* %if-res-ptr, align 4
  ret i32 0

then:                                             ; preds = %entry
  %_x_1 = load i32, i32* @_x_1, align 4
  store i32 %_x_1, i32* %if-res-ptr, align 4
  br label %merge

else:                                             ; preds = %entry
  store i32 10, i32* %if-res-ptr, align 4
  br label %merge
}
