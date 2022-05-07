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
  %if-res-ptr1 = alloca i1, align 1
  br i1 true, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr1, align 1
  br i1 %if-res-val, label %then3, label %else9

then:                                             ; preds = %entry
  store i1 true, i1* %if-res-ptr1, align 1
  br label %merge

else:                                             ; preds = %entry
  store i1 false, i1* %if-res-ptr1, align 1
  br label %merge

merge2:                                           ; preds = %merge11, %merge5
  %if-res-val15 = load i1, i1* %if-res-ptr, align 1
  ret i32 0

then3:                                            ; preds = %merge
  %if-res-ptr4 = alloca i1, align 1
  br i1 true, label %then6, label %else7

merge5:                                           ; preds = %else7, %then6
  %if-res-val8 = load i1, i1* %if-res-ptr4, align 1
  store i1 %if-res-val8, i1* %if-res-ptr, align 1
  br label %merge2

then6:                                            ; preds = %then3
  store i1 true, i1* %if-res-ptr4, align 1
  br label %merge5

else7:                                            ; preds = %then3
  store i1 false, i1* %if-res-ptr4, align 1
  br label %merge5

else9:                                            ; preds = %merge
  %if-res-ptr10 = alloca i1, align 1
  br i1 true, label %then12, label %else13

merge11:                                          ; preds = %else13, %then12
  %if-res-val14 = load i1, i1* %if-res-ptr10, align 1
  store i1 %if-res-val14, i1* %if-res-ptr, align 1
  br label %merge2

then12:                                           ; preds = %else9
  store i1 false, i1* %if-res-ptr10, align 1
  br label %merge11

else13:                                           ; preds = %else9
  store i1 false, i1* %if-res-ptr10, align 1
  br label %merge11
}
