; ModuleID = 'gROOT'
source_filename = "gROOT"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@_a_1 = global i32 0
@_b_1 = global i32 0
@_c_1 = global i32 0
@_d_1 = global i32 0

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  store i32 12, i32* @_a_1, align 4
  store i32 12, i32* @_b_1, align 4
  store i32 10, i32* @_c_1, align 4
  %_a_1 = load i32, i32* @_a_1, align 4
  %"=i" = icmp eq i32 %_a_1, 12
  %printb = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_b_1 = load i32, i32* @_b_1, align 4
  %"=i1" = icmp eq i32 %_b_1, 12
  %printb2 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_a_13 = load i32, i32* @_a_1, align 4
  %_b_14 = load i32, i32* @_b_1, align 4
  %"=i5" = icmp eq i32 %_a_13, %_b_14
  %printb6 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_b_17 = load i32, i32* @_b_1, align 4
  %_a_18 = load i32, i32* @_a_1, align 4
  %"=i9" = icmp eq i32 %_b_17, %_a_18
  %printb10 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_a_111 = load i32, i32* @_a_1, align 4
  %_a_112 = load i32, i32* @_a_1, align 4
  %"=i13" = icmp eq i32 %_a_111, %_a_112
  %printb14 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_b_115 = load i32, i32* @_b_1, align 4
  %_b_116 = load i32, i32* @_b_1, align 4
  %"=i17" = icmp eq i32 %_b_115, %_b_116
  %printb18 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_c_1 = load i32, i32* @_c_1, align 4
  %"=i19" = icmp eq i32 %_c_1, 12
  %printb20 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_c_121 = load i32, i32* @_c_1, align 4
  %_a_122 = load i32, i32* @_a_1, align 4
  %"=i23" = icmp eq i32 %_c_121, %_a_122
  %printb24 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_c_125 = load i32, i32* @_c_1, align 4
  %_b_126 = load i32, i32* @_b_1, align 4
  %"=i27" = icmp eq i32 %_c_125, %_b_126
  %printb28 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_a_129 = load i32, i32* @_a_1, align 4
  store i32 %_a_129, i32* @_d_1, align 4
  %_a_130 = load i32, i32* @_a_1, align 4
  %_d_1 = load i32, i32* @_d_1, align 4
  %"=i31" = icmp eq i32 %_a_130, %_d_1
  %printb32 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  %_d_133 = load i32, i32* @_d_1, align 4
  %"=i34" = icmp eq i32 %_d_133, 12
  %printb35 = call i32 @puts(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @boolF, i32 0, i32 0))
  ret i32 0
}
