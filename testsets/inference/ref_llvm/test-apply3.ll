; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i1 (i1)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i1 (i1)* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i1 (i1)* @_anon0, i1 (i1)** %funcField, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  %function_call = load i1 (i1)*, i1 (i1)** %function_access, align 8
  %function_result = call i1 %function_call(i1 false)
  ret i32 0
}

define i1 @_anon0(i1 %y) {
entry:
  %y1 = alloca i1, align 1
  store i1 %y, i1* %y1, align 1
  %if-res-ptr = alloca i1, align 1
  %y2 = load i1, i1* %y1, align 1
  br i1 %y2, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr, align 1
  ret i1 %if-res-val

then:                                             ; preds = %entry
  store i1 true, i1* %if-res-ptr, align 1
  br label %merge

else:                                             ; preds = %entry
  %y3 = load i1, i1* %y1, align 1
  store i1 %y3, i1* %if-res-ptr, align 1
  br label %merge
}
