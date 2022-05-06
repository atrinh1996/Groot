; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i32 (i1)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i32 (i1)* null
@_x_1 = global %_anon0_struct* null
@_y_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i32 (i1)* @_anon0, i32 (i1)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_x_1, align 8
  %_x_1 = load %_anon0_struct*, %_anon0_struct** @_x_1, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_x_1, i32 0, i32 0
  %function_call = load i32 (i1)*, i32 (i1)** %function_access, align 8
  %function_result = call i32 %function_call(i1 false)
  store i32 %function_result, i32* @_y_1, align 4
  ret i32 0
}

define i32 @_anon0(i1 %x) {
entry:
  %x1 = alloca i1, align 1
  store i1 %x, i1* %x1, align 1
  %if-res-ptr = alloca i32, align 4
  %x2 = load i1, i1* %x1, align 1
  br i1 %x2, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i32, i32* %if-res-ptr, align 4
  ret i32 %if-res-val

then:                                             ; preds = %entry
  store i32 3, i32* %if-res-ptr, align 4
  br label %merge

else:                                             ; preds = %entry
  store i32 1, i32* %if-res-ptr, align 4
  br label %merge
}
