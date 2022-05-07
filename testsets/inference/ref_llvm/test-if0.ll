; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %if-res-ptr = alloca i1, align 1
  br i1 true, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr, align 1
  ret i32 0

then:                                             ; preds = %entry
  store i1 false, i1* %if-res-ptr, align 1
  br label %merge

else:                                             ; preds = %entry
  store i1 true, i1* %if-res-ptr, align 1
  br label %merge
}
