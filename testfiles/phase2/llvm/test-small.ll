; ModuleID = 'gROOT'
source_filename = "gROOT"

%tree_struct = type { i32, %tree_struct*, %tree_struct* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_retx_2.1 = global i32 (i32)* null
@_retx_1.2 = global i32 (i32)* null
@_retx2_1.3 = global i32 (i32, i32, i32)* null
@_x_2 = global i32 0
@_x_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

declare void @__die__()

define i32 @main(%tree_struct %0) {
entry:
  store i32 42, i32* @_x_1, align 4
  store i32 (i32)* @_retx_1, i32 (i32)** @_retx_1.2, align 8
  %_x_1 = load i32, i32* @_x_1, align 4
  %_retx_1 = load i32 (i32)*, i32 (i32)** @_retx_1.2, align 8
  %fun_name = call i32 %_retx_1(i32 %_x_1)
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fun_name)
  store i32 12, i32* @_x_2, align 4
  %_x_11 = load i32, i32* @_x_1, align 4
  %_retx_12 = load i32 (i32)*, i32 (i32)** @_retx_1.2, align 8
  %fun_name3 = call i32 %_retx_12(i32 %_x_11)
  %printi4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fun_name3)
  store i32 (i32)* @_retx_2, i32 (i32)** @_retx_2.1, align 8
  %_x_2 = load i32, i32* @_x_2, align 4
  %_retx_2 = load i32 (i32)*, i32 (i32)** @_retx_2.1, align 8
  %fun_name5 = call i32 %_retx_2(i32 %_x_2)
  %printi6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fun_name5)
  store i32 (i32, i32, i32)* @_retx2_1, i32 (i32, i32, i32)** @_retx2_1.3, align 8
  %_x_27 = load i32, i32* @_x_2, align 4
  %_retx2_1 = load i32 (i32, i32, i32)*, i32 (i32, i32, i32)** @_retx2_1.3, align 8
  %fun_name8 = call i32 %_retx2_1(i32 9, i32 8, i32 %_x_27)
  %printi9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fun_name8)
  ret i32 0
}

define i32 @_retx2_1(i32 %n, i32 %m, i32 %_x_2) {
entry:
  %n1 = alloca i32, align 4
  store i32 %n, i32* %n1, align 4
  %m2 = alloca i32, align 4
  store i32 %m, i32* %m2, align 4
  %_x_23 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_23, align 4
  %_x_24 = load i32, i32* %_x_23, align 4
  ret i32 %_x_24
}

define i32 @_retx_2(i32 %_x_2) {
entry:
  %_x_21 = alloca i32, align 4
  store i32 %_x_2, i32* %_x_21, align 4
  %_x_22 = load i32, i32* %_x_21, align 4
  ret i32 %_x_22
}

define i32 @_retx_1(i32 %_x_1) {
entry:
  %_x_11 = alloca i32, align 4
  store i32 %_x_1, i32* %_x_11, align 4
  %_x_12 = load i32, i32* %_x_11, align 4
  ret i32 %_x_12
}
