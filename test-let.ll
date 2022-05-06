; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_var_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 2, i32* @_var_1, align 4
  %var = alloca i32, align 4
  store i32 4, i32* %var, align 4
  %var1 = load i32, i32* %var, align 4
  %printi = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %var1)
  %y = alloca i32, align 4
  store i32 4, i32* %y, align 4
  %y2 = load i32, i32* %y, align 4
  %printi3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %y2)
  %a = alloca i32, align 4
  store i32 2, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 3, i32* %b, align 4
  %a4 = load i32, i32* %a, align 4
  %b5 = load i32, i32* %b, align 4
  %addition = add i32 %a4, %b5
  %printi6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %addition)
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  %y7 = alloca i32, align 4
  store i32 5, i32* %y7, align 4
  %z = alloca i32, align 4
  %y8 = load i32, i32* %y7, align 4
  store i32 %y8, i32* %z, align 4
  %z9 = load i32, i32* %z, align 4
  %z10 = load i32, i32* %z, align 4
  %z11 = load i32, i32* %z, align 4
  %multiply = mul i32 %z10, %z11
  %multiply12 = mul i32 %z9, %multiply
  %printi13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %multiply12)
  ret i32 0
}
