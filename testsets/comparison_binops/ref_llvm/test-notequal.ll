; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_a_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %printb = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolT, i32 0, i32 0))
  store i32 4, i32* @_a_1, align 4
  %_a_1 = load i32, i32* @_a_1, align 4
  %neqI = icmp ne i32 6, %_a_1
  %printb1 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_a_12 = load i32, i32* @_a_1, align 4
  %neqI3 = icmp ne i32 %_a_12, 6
  %printb4 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_a_15 = load i32, i32* @_a_1, align 4
  %_a_16 = load i32, i32* @_a_1, align 4
  %neqI7 = icmp ne i32 %_a_15, %_a_16
  %printb8 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %printb9 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  ret i32 0
}
