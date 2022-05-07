; ModuleID = 'gROOT'
source_filename = "gROOT"

%_anon0_struct = type { i1 (i1, i1, i1)* }
%_anon1_struct = type { i32 ()* }
%_anon2_struct = type { i32 (i32)* }
%_anon3_struct = type { i32 (i32)* }
%_anon4_struct = type { i32 (i32, i32)* }
%_anon5_struct = type { i32 (i32, i32)* }
%_anon6_struct = type { i32 (i32)* }
%_anon7_struct = type { i32 (i32, i32)* }

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@boolT = private unnamed_addr constant [3 x i8] c"#t\00", align 1
@boolF = private unnamed_addr constant [3 x i8] c"#f\00", align 1
@__anon0_1 = global i1 (i1, i1, i1)* null
@__anon1_1 = global i32 ()* null
@__anon2_1 = global i32 (i32)* null
@__anon3_1 = global i32 (i32)* null
@__anon4_1 = global i32 (i32, i32)* null
@__anon5_1 = global i32 (i32, i32)* null
@__anon6_1 = global i32 (i32)* null
@__anon7_1 = global i32 (i32, i32)* null

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define i32 @main() {
entry:
  %gstruct = alloca %_anon0_struct, align 8
  %funcField = getelementptr inbounds %_anon0_struct, %_anon0_struct* %gstruct, i32 0, i32 0
  store i1 (i1, i1, i1)* @_anon0, i1 (i1, i1, i1)** %funcField, align 8
  %gstruct1 = alloca %_anon1_struct, align 8
  %funcField2 = getelementptr inbounds %_anon1_struct, %_anon1_struct* %gstruct1, i32 0, i32 0
  store i32 ()* @_anon1, i32 ()** %funcField2, align 8
  %gstruct3 = alloca %_anon2_struct, align 8
  %funcField4 = getelementptr inbounds %_anon2_struct, %_anon2_struct* %gstruct3, i32 0, i32 0
  store i32 (i32)* @_anon2, i32 (i32)** %funcField4, align 8
  %gstruct5 = alloca %_anon3_struct, align 8
  %funcField6 = getelementptr inbounds %_anon3_struct, %_anon3_struct* %gstruct5, i32 0, i32 0
  store i32 (i32)* @_anon3, i32 (i32)** %funcField6, align 8
  %gstruct7 = alloca %_anon4_struct, align 8
  %funcField8 = getelementptr inbounds %_anon4_struct, %_anon4_struct* %gstruct7, i32 0, i32 0
  store i32 (i32, i32)* @_anon4, i32 (i32, i32)** %funcField8, align 8
  %gstruct9 = alloca %_anon5_struct, align 8
  %funcField10 = getelementptr inbounds %_anon5_struct, %_anon5_struct* %gstruct9, i32 0, i32 0
  store i32 (i32, i32)* @_anon5, i32 (i32, i32)** %funcField10, align 8
  %gstruct11 = alloca %_anon6_struct, align 8
  %funcField12 = getelementptr inbounds %_anon6_struct, %_anon6_struct* %gstruct11, i32 0, i32 0
  store i32 (i32)* @_anon6, i32 (i32)** %funcField12, align 8
  %gstruct13 = alloca %_anon7_struct, align 8
  %funcField14 = getelementptr inbounds %_anon7_struct, %_anon7_struct* %gstruct13, i32 0, i32 0
  store i32 (i32, i32)* @_anon7, i32 (i32, i32)** %funcField14, align 8
  ret i32 0
}

define i32 @_anon7(i32 %y, i32 %x) {
entry:
  %y1 = alloca i32, align 4
  store i32 %y, i32* %y1, align 4
  %x2 = alloca i32, align 4
  store i32 %x, i32* %x2, align 4
  ret i32 9
}

define i32 @_anon6(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  ret i32 4
}

define i32 @_anon5(i32 %x, i32 %y) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %y2 = alloca i32, align 4
  store i32 %y, i32* %y2, align 4
  ret i32 3
}

define i32 @_anon4(i32 %x, i32 %y) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  %y2 = alloca i32, align 4
  store i32 %y, i32* %y2, align 4
  ret i32 9
}

define i32 @_anon3(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  ret i32 9
}

define i32 @_anon2(i32 %x) {
entry:
  %x1 = alloca i32, align 4
  store i32 %x, i32* %x1, align 4
  ret i32 4
}

define i32 @_anon1() {
entry:
  ret i32 4
}

define i1 @_anon0(i1 %x, i1 %y, i1 %z) {
entry:
  %x1 = alloca i1, align 1
  store i1 %x, i1* %x1, align 1
  %y2 = alloca i1, align 1
  store i1 %y, i1* %y2, align 1
  %z3 = alloca i1, align 1
  store i1 %z, i1* %z3, align 1
  %if-res-ptr = alloca i1, align 1
  %z4 = load i1, i1* %z3, align 1
  br i1 %z4, label %then, label %else

merge:                                            ; preds = %else, %then
  %if-res-val = load i1, i1* %if-res-ptr, align 1
  ret i1 %if-res-val

then:                                             ; preds = %entry
  %x5 = load i1, i1* %x1, align 1
  %y6 = load i1, i1* %y2, align 1
  %logOR = or i1 %x5, %y6
  store i1 %logOR, i1* %if-res-ptr, align 1
  br label %merge

else:                                             ; preds = %entry
  %x7 = load i1, i1* %x1, align 1
  %y8 = load i1, i1* %y2, align 1
  %logAND = and i1 %x7, %y8
  store i1 %logAND, i1* %if-res-ptr, align 1
  br label %merge
}
