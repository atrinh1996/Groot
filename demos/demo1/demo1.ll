; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i8* (i32)* }
%_anon1_struct = type { i8* (i32, i32, i32, %_anon0_struct*)*, %_anon0_struct* }
%_anon2_struct = type { i8* (i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i8* (i32)* null
@__anon1_1 = global i8* (i32, i32, i32, %_anon0_struct*)* null
@__anon2_1 = global i8* (i32)* null
@_computeGrade_1 = global %_anon1_struct* null
@_letterGrade_2 = global %_anon2_struct* null
@_letterGrade_1 = global %_anon0_struct* null
@globalChar = private unnamed_addr constant [2 x i8] c"A\00", align 1
@globalChar.1 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@globalChar.2 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@globalChar.3 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@globalChar.4 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@globalChar.5 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@globalChar.6 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@globalChar.7 = private unnamed_addr constant [2 x i8] c"D\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i8* (i32)* @_anon0, i8* (i32)** %funcField, align 8
  store %_anon0_struct* %gstruct, %_anon0_struct** @_letterGrade_1, align 8
  %_letterGrade_1 = load %_anon0_struct*, %_anon0_struct** @_letterGrade_1, align 8
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_letterGrade_1, i32 0, i32 0
  %function_call = load i8* (i32)*, i8* (i32)** %function_access, align 8
  %function_result = call i8* %function_call(i32 89)
  %printc = call i32 @puts(i8* %function_result)
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i8* (i32, i32, i32, %_anon0_struct*)* @_anon1, i8* (i32, i32, i32, %_anon0_struct*)** %funcField2, align 8
  %_letterGrade_13 = load %_anon0_struct*, %_anon0_struct** @_letterGrade_1, align 8
  %freeField = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 1
  store %_anon0_struct* %_letterGrade_13, %_anon0_struct** %freeField, align 8
  store %_anon1_struct* %gstruct1, %_anon1_struct** @_computeGrade_1, align 8
  %_computeGrade_1 = load %_anon1_struct*, %_anon1_struct** @_computeGrade_1, align 8
  %freePtr = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_computeGrade_1, i32 0, i32 1
  %freeVal = load %_anon0_struct*, %_anon0_struct** %freePtr, align 8
  %function_access4 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_computeGrade_1, i32 0, i32 0
  %function_call5 = load i8* (i32, i32, i32, %_anon0_struct*)*, i8* (i32, i32, i32, %_anon0_struct*)** %function_access4, align 8
  %function_result6 = call i8* %function_call5(i32 88, i32 90, i32 91, %_anon0_struct* %freeVal)
  %printc7 = call i32 @puts(i8* %function_result6)
  %gstruct8 = alloca %_anon2_struct, align 8
  %funcField9 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct8, i32 0, i32 0
  store i8* (i32)* @_anon2, i8* (i32)** %funcField9, align 8
  store %_anon2_struct* %gstruct8, %_anon2_struct** @_letterGrade_2, align 8
  %_letterGrade_2 = load %_anon2_struct*, %_anon2_struct** @_letterGrade_2, align 8
  %function_access10 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %_letterGrade_2, i32 0, i32 0
  %function_call11 = load i8* (i32)*, i8* (i32)** %function_access10, align 8
  %function_result12 = call i8* %function_call11(i32 89)
  %printc13 = call i32 @puts(i8* %function_result12)
  %_computeGrade_114 = load %_anon1_struct*, %_anon1_struct** @_computeGrade_1, align 8
  %freePtr15 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_computeGrade_114, i32 0, i32 1
  %freeVal16 = load %_anon0_struct*, %_anon0_struct** %freePtr15, align 8
  %function_access17 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %_computeGrade_114, i32 0, i32 0
  %function_call18 = load i8* (i32, i32, i32, %_anon0_struct*)*, i8* (i32, i32, i32, %_anon0_struct*)** %function_access17, align 8
  %function_result19 = call i8* %function_call18(i32 88, i32 90, i32 91, %_anon0_struct* %freeVal16)
  %printc20 = call i32 @puts(i8* %function_result19)
  ret i32 0
}

define i8* @_anon2(i32 %test) {
entry:
  %test1 = alloca i32, align 4
  store i32 %test, i32* %test1, align 4
  %if-res-ptr = alloca i8*, align 8
  %test2 = load i32, i32* %test1, align 4
  %lt = icmp slt i32 85, %test2
  br i1 %lt, label %then, label %else

merge:                                            ; preds = %merge6, %then
  %if-res-val25 = load i8*, i8** %if-res-ptr, align 8
  ret i8* %if-res-val25

then:                                             ; preds = %entry
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  store i8* %character_ptr, i8** %if-res-ptr, align 8
  br label %merge

else:                                             ; preds = %entry
  %if-res-ptr3 = alloca i8*, align 8
  %test4 = load i32, i32* %test1, align 4
  %lt5 = icmp slt i32 75, %test4
  br i1 %lt5, label %then7, label %else11

merge6:                                           ; preds = %merge15, %then7
  %if-res-val24 = load i8*, i8** %if-res-ptr3, align 8
  store i8* %if-res-val24, i8** %if-res-ptr, align 8
  br label %merge

then7:                                            ; preds = %else
  %spc8 = alloca i8*, align 8
  %loc9 = getelementptr i8*, i8** %spc8, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.1, i32 0, i32 0), i8** %loc9, align 8
  %character_ptr10 = load i8*, i8** %spc8, align 8
  store i8* %character_ptr10, i8** %if-res-ptr3, align 8
  br label %merge6

else11:                                           ; preds = %else
  %if-res-ptr12 = alloca i8*, align 8
  %test13 = load i32, i32* %test1, align 4
  %lt14 = icmp slt i32 65, %test13
  br i1 %lt14, label %then16, label %else20

merge15:                                          ; preds = %else20, %then16
  %if-res-val = load i8*, i8** %if-res-ptr12, align 8
  store i8* %if-res-val, i8** %if-res-ptr3, align 8
  br label %merge6

then16:                                           ; preds = %else11
  %spc17 = alloca i8*, align 8
  %loc18 = getelementptr i8*, i8** %spc17, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.2, i32 0, i32 0), i8** %loc18, align 8
  %character_ptr19 = load i8*, i8** %spc17, align 8
  store i8* %character_ptr19, i8** %if-res-ptr12, align 8
  br label %merge15

else20:                                           ; preds = %else11
  %spc21 = alloca i8*, align 8
  %loc22 = getelementptr i8*, i8** %spc21, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.3, i32 0, i32 0), i8** %loc22, align 8
  %character_ptr23 = load i8*, i8** %spc21, align 8
  store i8* %character_ptr23, i8** %if-res-ptr12, align 8
  br label %merge15
}

define i8* @_anon1(i32 %test, i32 %test2, i32 %test3, %_anon0_struct* %_letterGrade_1) {
entry:
  %test1 = alloca i32, align 4
  store i32 %test, i32* %test1, align 4
  %test22 = alloca i32, align 4
  store i32 %test2, i32* %test22, align 4
  %test33 = alloca i32, align 4
  store i32 %test3, i32* %test33, align 4
  %_letterGrade_14 = alloca %_anon0_struct*, align 8
  store %_anon0_struct* %_letterGrade_1, %_anon0_struct** %_letterGrade_14, align 8
  %sum = alloca i32, align 4
  %test5 = load i32, i32* %test1, align 4
  %test26 = load i32, i32* %test22, align 4
  %addition = add i32 %test5, %test26
  %test37 = load i32, i32* %test33, align 4
  %addition8 = add i32 %addition, %test37
  store i32 %addition8, i32* %sum, align 4
  %avg = alloca i32, align 4
  %sum9 = load i32, i32* %sum, align 4
  %division = sdiv i32 %sum9, 3
  store i32 %division, i32* %avg, align 4
  %_letterGrade_110 = load %_anon0_struct*, %_anon0_struct** %_letterGrade_14, align 8
  %avg11 = load i32, i32* %avg, align 4
  %function_access = getelementptr inbounds %_anon0_struct, %_anon0_struct* %_letterGrade_110, i32 0, i32 0
  %function_call = load i8* (i32)*, i8* (i32)** %function_access, align 8
  %function_result = call i8* %function_call(i32 %avg11)
  ret i8* %function_result
}

define i8* @_anon0(i32 %test) {
entry:
  %test1 = alloca i32, align 4
  store i32 %test, i32* %test1, align 4
  %if-res-ptr = alloca i8*, align 8
  %test2 = load i32, i32* %test1, align 4
  %lt = icmp slt i32 90, %test2
  br i1 %lt, label %then, label %else

merge:                                            ; preds = %merge6, %then
  %if-res-val25 = load i8*, i8** %if-res-ptr, align 8
  ret i8* %if-res-val25

then:                                             ; preds = %entry
  %spc = alloca i8*, align 8
  %loc = getelementptr i8*, i8** %spc, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.4, i32 0, i32 0), i8** %loc, align 8
  %character_ptr = load i8*, i8** %spc, align 8
  store i8* %character_ptr, i8** %if-res-ptr, align 8
  br label %merge

else:                                             ; preds = %entry
  %if-res-ptr3 = alloca i8*, align 8
  %test4 = load i32, i32* %test1, align 4
  %lt5 = icmp slt i32 80, %test4
  br i1 %lt5, label %then7, label %else11

merge6:                                           ; preds = %merge15, %then7
  %if-res-val24 = load i8*, i8** %if-res-ptr3, align 8
  store i8* %if-res-val24, i8** %if-res-ptr, align 8
  br label %merge

then7:                                            ; preds = %else
  %spc8 = alloca i8*, align 8
  %loc9 = getelementptr i8*, i8** %spc8, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.5, i32 0, i32 0), i8** %loc9, align 8
  %character_ptr10 = load i8*, i8** %spc8, align 8
  store i8* %character_ptr10, i8** %if-res-ptr3, align 8
  br label %merge6

else11:                                           ; preds = %else
  %if-res-ptr12 = alloca i8*, align 8
  %test13 = load i32, i32* %test1, align 4
  %lt14 = icmp slt i32 70, %test13
  br i1 %lt14, label %then16, label %else20

merge15:                                          ; preds = %else20, %then16
  %if-res-val = load i8*, i8** %if-res-ptr12, align 8
  store i8* %if-res-val, i8** %if-res-ptr3, align 8
  br label %merge6

then16:                                           ; preds = %else11
  %spc17 = alloca i8*, align 8
  %loc18 = getelementptr i8*, i8** %spc17, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.6, i32 0, i32 0), i8** %loc18, align 8
  %character_ptr19 = load i8*, i8** %spc17, align 8
  store i8* %character_ptr19, i8** %if-res-ptr12, align 8
  br label %merge15

else20:                                           ; preds = %else11
  %spc21 = alloca i8*, align 8
  %loc22 = getelementptr i8*, i8** %spc21, i32 0
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @globalChar.7, i32 0, i32 0), i8** %loc22, align 8
  %character_ptr23 = load i8*, i8** %spc21, align 8
  store i8* %character_ptr23, i8** %if-res-ptr12, align 8
  br label %merge15
}
