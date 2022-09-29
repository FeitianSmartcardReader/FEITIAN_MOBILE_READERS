; ModuleID = 'obj\Release\120\android\compressed_assemblies.armeabi-v7a.ll'
source_filename = "obj\Release\120\android\compressed_assemblies.armeabi-v7a.ll"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-unknown-linux-android"


%struct.CompressedAssemblyDescriptor = type {
	i32,; uint32_t uncompressed_file_size
	i8,; bool loaded
	i8*; uint8_t* data
}

%struct.CompressedAssemblies = type {
	i32,; uint32_t count
	%struct.CompressedAssemblyDescriptor*; CompressedAssemblyDescriptor* descriptors
}
@__CompressedAssemblyDescriptor_data_0 = internal global [189952 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_1 = internal global [572928 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_2 = internal global [456704 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_3 = internal global [20992 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_4 = internal global [135168 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_5 = internal global [16384 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_6 = internal global [67072 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_7 = internal global [359936 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_8 = internal global [72192 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_9 = internal global [9728 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_10 = internal global [9728 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_11 = internal global [18944 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_12 = internal global [15360 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_13 = internal global [8704 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_14 = internal global [78848 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_15 = internal global [11776 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_16 = internal global [33280 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_17 = internal global [5632 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_18 = internal global [5632 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_19 = internal global [32768 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_20 = internal global [13312 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_21 = internal global [4608 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_22 = internal global [167424 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_23 = internal global [6525952 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_24 = internal global [66560 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_25 = internal global [23040 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_26 = internal global [5120 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_27 = internal global [300032 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_28 = internal global [13312 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_29 = internal global [10752 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_30 = internal global [14848 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_31 = internal global [12800 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_32 = internal global [14336 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_33 = internal global [13824 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_34 = internal global [16384 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_35 = internal global [26624 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_36 = internal global [48640 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_37 = internal global [8192 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_38 = internal global [26112 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_39 = internal global [29696 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_40 = internal global [36864 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_41 = internal global [20992 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_42 = internal global [7168 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_43 = internal global [16384 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_44 = internal global [26624 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_45 = internal global [2263040 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_46 = internal global [122880 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_47 = internal global [444416 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_48 = internal global [682496 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_49 = internal global [1136640 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_50 = internal global [1569280 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_51 = internal global [6144 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_52 = internal global [6144 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_53 = internal global [15360 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_54 = internal global [47104 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_55 = internal global [31744 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_56 = internal global [6656 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_57 = internal global [27648 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_58 = internal global [6144 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_59 = internal global [126976 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_60 = internal global [8704 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_61 = internal global [16384 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_62 = internal global [14728 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_63 = internal global [365056 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_64 = internal global [1073664 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_65 = internal global [748032 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_66 = internal global [26112 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_67 = internal global [60928 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_68 = internal global [224768 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_69 = internal global [51200 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_70 = internal global [7168 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_71 = internal global [419840 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_72 = internal global [11776 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_73 = internal global [151040 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_74 = internal global [79872 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_75 = internal global [7680 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_76 = internal global [6656 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_77 = internal global [55808 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_78 = internal global [22528 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_79 = internal global [44544 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_80 = internal global [15248 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_81 = internal global [65024 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_82 = internal global [1632256 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_83 = internal global [963072 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_84 = internal global [53248 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_85 = internal global [17408 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_86 = internal global [463360 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_87 = internal global [17920 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_88 = internal global [79360 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_89 = internal global [585728 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_90 = internal global [9216 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_91 = internal global [44032 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_92 = internal global [175104 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_93 = internal global [15872 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_94 = internal global [15360 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_95 = internal global [16384 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_96 = internal global [17408 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_97 = internal global [36864 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_98 = internal global [424448 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_99 = internal global [13312 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_100 = internal global [40448 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_101 = internal global [57856 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_102 = internal global [26112 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_103 = internal global [1207808 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_104 = internal global [934912 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_105 = internal global [263040 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_106 = internal global [103424 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_107 = internal global [258048 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_108 = internal global [18072 x i8] zeroinitializer, align 1
@__CompressedAssemblyDescriptor_data_109 = internal global [2308096 x i8] zeroinitializer, align 1


; Compressed assembly data storage
@compressed_assembly_descriptors = internal global [110 x %struct.CompressedAssemblyDescriptor] [
	; 0
	%struct.CompressedAssemblyDescriptor {
		i32 189952, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([189952 x i8], [189952 x i8]* @__CompressedAssemblyDescriptor_data_0, i32 0, i32 0); data
	}, 
	; 1
	%struct.CompressedAssemblyDescriptor {
		i32 572928, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([572928 x i8], [572928 x i8]* @__CompressedAssemblyDescriptor_data_1, i32 0, i32 0); data
	}, 
	; 2
	%struct.CompressedAssemblyDescriptor {
		i32 456704, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([456704 x i8], [456704 x i8]* @__CompressedAssemblyDescriptor_data_2, i32 0, i32 0); data
	}, 
	; 3
	%struct.CompressedAssemblyDescriptor {
		i32 20992, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([20992 x i8], [20992 x i8]* @__CompressedAssemblyDescriptor_data_3, i32 0, i32 0); data
	}, 
	; 4
	%struct.CompressedAssemblyDescriptor {
		i32 135168, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([135168 x i8], [135168 x i8]* @__CompressedAssemblyDescriptor_data_4, i32 0, i32 0); data
	}, 
	; 5
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__CompressedAssemblyDescriptor_data_5, i32 0, i32 0); data
	}, 
	; 6
	%struct.CompressedAssemblyDescriptor {
		i32 67072, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([67072 x i8], [67072 x i8]* @__CompressedAssemblyDescriptor_data_6, i32 0, i32 0); data
	}, 
	; 7
	%struct.CompressedAssemblyDescriptor {
		i32 359936, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([359936 x i8], [359936 x i8]* @__CompressedAssemblyDescriptor_data_7, i32 0, i32 0); data
	}, 
	; 8
	%struct.CompressedAssemblyDescriptor {
		i32 72192, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([72192 x i8], [72192 x i8]* @__CompressedAssemblyDescriptor_data_8, i32 0, i32 0); data
	}, 
	; 9
	%struct.CompressedAssemblyDescriptor {
		i32 9728, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([9728 x i8], [9728 x i8]* @__CompressedAssemblyDescriptor_data_9, i32 0, i32 0); data
	}, 
	; 10
	%struct.CompressedAssemblyDescriptor {
		i32 9728, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([9728 x i8], [9728 x i8]* @__CompressedAssemblyDescriptor_data_10, i32 0, i32 0); data
	}, 
	; 11
	%struct.CompressedAssemblyDescriptor {
		i32 18944, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([18944 x i8], [18944 x i8]* @__CompressedAssemblyDescriptor_data_11, i32 0, i32 0); data
	}, 
	; 12
	%struct.CompressedAssemblyDescriptor {
		i32 15360, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([15360 x i8], [15360 x i8]* @__CompressedAssemblyDescriptor_data_12, i32 0, i32 0); data
	}, 
	; 13
	%struct.CompressedAssemblyDescriptor {
		i32 8704, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([8704 x i8], [8704 x i8]* @__CompressedAssemblyDescriptor_data_13, i32 0, i32 0); data
	}, 
	; 14
	%struct.CompressedAssemblyDescriptor {
		i32 78848, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([78848 x i8], [78848 x i8]* @__CompressedAssemblyDescriptor_data_14, i32 0, i32 0); data
	}, 
	; 15
	%struct.CompressedAssemblyDescriptor {
		i32 11776, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([11776 x i8], [11776 x i8]* @__CompressedAssemblyDescriptor_data_15, i32 0, i32 0); data
	}, 
	; 16
	%struct.CompressedAssemblyDescriptor {
		i32 33280, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([33280 x i8], [33280 x i8]* @__CompressedAssemblyDescriptor_data_16, i32 0, i32 0); data
	}, 
	; 17
	%struct.CompressedAssemblyDescriptor {
		i32 5632, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([5632 x i8], [5632 x i8]* @__CompressedAssemblyDescriptor_data_17, i32 0, i32 0); data
	}, 
	; 18
	%struct.CompressedAssemblyDescriptor {
		i32 5632, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([5632 x i8], [5632 x i8]* @__CompressedAssemblyDescriptor_data_18, i32 0, i32 0); data
	}, 
	; 19
	%struct.CompressedAssemblyDescriptor {
		i32 32768, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([32768 x i8], [32768 x i8]* @__CompressedAssemblyDescriptor_data_19, i32 0, i32 0); data
	}, 
	; 20
	%struct.CompressedAssemblyDescriptor {
		i32 13312, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([13312 x i8], [13312 x i8]* @__CompressedAssemblyDescriptor_data_20, i32 0, i32 0); data
	}, 
	; 21
	%struct.CompressedAssemblyDescriptor {
		i32 4608, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([4608 x i8], [4608 x i8]* @__CompressedAssemblyDescriptor_data_21, i32 0, i32 0); data
	}, 
	; 22
	%struct.CompressedAssemblyDescriptor {
		i32 167424, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([167424 x i8], [167424 x i8]* @__CompressedAssemblyDescriptor_data_22, i32 0, i32 0); data
	}, 
	; 23
	%struct.CompressedAssemblyDescriptor {
		i32 6525952, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6525952 x i8], [6525952 x i8]* @__CompressedAssemblyDescriptor_data_23, i32 0, i32 0); data
	}, 
	; 24
	%struct.CompressedAssemblyDescriptor {
		i32 66560, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([66560 x i8], [66560 x i8]* @__CompressedAssemblyDescriptor_data_24, i32 0, i32 0); data
	}, 
	; 25
	%struct.CompressedAssemblyDescriptor {
		i32 23040, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([23040 x i8], [23040 x i8]* @__CompressedAssemblyDescriptor_data_25, i32 0, i32 0); data
	}, 
	; 26
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([5120 x i8], [5120 x i8]* @__CompressedAssemblyDescriptor_data_26, i32 0, i32 0); data
	}, 
	; 27
	%struct.CompressedAssemblyDescriptor {
		i32 300032, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([300032 x i8], [300032 x i8]* @__CompressedAssemblyDescriptor_data_27, i32 0, i32 0); data
	}, 
	; 28
	%struct.CompressedAssemblyDescriptor {
		i32 13312, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([13312 x i8], [13312 x i8]* @__CompressedAssemblyDescriptor_data_28, i32 0, i32 0); data
	}, 
	; 29
	%struct.CompressedAssemblyDescriptor {
		i32 10752, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([10752 x i8], [10752 x i8]* @__CompressedAssemblyDescriptor_data_29, i32 0, i32 0); data
	}, 
	; 30
	%struct.CompressedAssemblyDescriptor {
		i32 14848, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([14848 x i8], [14848 x i8]* @__CompressedAssemblyDescriptor_data_30, i32 0, i32 0); data
	}, 
	; 31
	%struct.CompressedAssemblyDescriptor {
		i32 12800, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([12800 x i8], [12800 x i8]* @__CompressedAssemblyDescriptor_data_31, i32 0, i32 0); data
	}, 
	; 32
	%struct.CompressedAssemblyDescriptor {
		i32 14336, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([14336 x i8], [14336 x i8]* @__CompressedAssemblyDescriptor_data_32, i32 0, i32 0); data
	}, 
	; 33
	%struct.CompressedAssemblyDescriptor {
		i32 13824, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([13824 x i8], [13824 x i8]* @__CompressedAssemblyDescriptor_data_33, i32 0, i32 0); data
	}, 
	; 34
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__CompressedAssemblyDescriptor_data_34, i32 0, i32 0); data
	}, 
	; 35
	%struct.CompressedAssemblyDescriptor {
		i32 26624, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([26624 x i8], [26624 x i8]* @__CompressedAssemblyDescriptor_data_35, i32 0, i32 0); data
	}, 
	; 36
	%struct.CompressedAssemblyDescriptor {
		i32 48640, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([48640 x i8], [48640 x i8]* @__CompressedAssemblyDescriptor_data_36, i32 0, i32 0); data
	}, 
	; 37
	%struct.CompressedAssemblyDescriptor {
		i32 8192, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([8192 x i8], [8192 x i8]* @__CompressedAssemblyDescriptor_data_37, i32 0, i32 0); data
	}, 
	; 38
	%struct.CompressedAssemblyDescriptor {
		i32 26112, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([26112 x i8], [26112 x i8]* @__CompressedAssemblyDescriptor_data_38, i32 0, i32 0); data
	}, 
	; 39
	%struct.CompressedAssemblyDescriptor {
		i32 29696, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([29696 x i8], [29696 x i8]* @__CompressedAssemblyDescriptor_data_39, i32 0, i32 0); data
	}, 
	; 40
	%struct.CompressedAssemblyDescriptor {
		i32 36864, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([36864 x i8], [36864 x i8]* @__CompressedAssemblyDescriptor_data_40, i32 0, i32 0); data
	}, 
	; 41
	%struct.CompressedAssemblyDescriptor {
		i32 20992, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([20992 x i8], [20992 x i8]* @__CompressedAssemblyDescriptor_data_41, i32 0, i32 0); data
	}, 
	; 42
	%struct.CompressedAssemblyDescriptor {
		i32 7168, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([7168 x i8], [7168 x i8]* @__CompressedAssemblyDescriptor_data_42, i32 0, i32 0); data
	}, 
	; 43
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__CompressedAssemblyDescriptor_data_43, i32 0, i32 0); data
	}, 
	; 44
	%struct.CompressedAssemblyDescriptor {
		i32 26624, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([26624 x i8], [26624 x i8]* @__CompressedAssemblyDescriptor_data_44, i32 0, i32 0); data
	}, 
	; 45
	%struct.CompressedAssemblyDescriptor {
		i32 2263040, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([2263040 x i8], [2263040 x i8]* @__CompressedAssemblyDescriptor_data_45, i32 0, i32 0); data
	}, 
	; 46
	%struct.CompressedAssemblyDescriptor {
		i32 122880, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([122880 x i8], [122880 x i8]* @__CompressedAssemblyDescriptor_data_46, i32 0, i32 0); data
	}, 
	; 47
	%struct.CompressedAssemblyDescriptor {
		i32 444416, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([444416 x i8], [444416 x i8]* @__CompressedAssemblyDescriptor_data_47, i32 0, i32 0); data
	}, 
	; 48
	%struct.CompressedAssemblyDescriptor {
		i32 682496, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([682496 x i8], [682496 x i8]* @__CompressedAssemblyDescriptor_data_48, i32 0, i32 0); data
	}, 
	; 49
	%struct.CompressedAssemblyDescriptor {
		i32 1136640, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([1136640 x i8], [1136640 x i8]* @__CompressedAssemblyDescriptor_data_49, i32 0, i32 0); data
	}, 
	; 50
	%struct.CompressedAssemblyDescriptor {
		i32 1569280, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([1569280 x i8], [1569280 x i8]* @__CompressedAssemblyDescriptor_data_50, i32 0, i32 0); data
	}, 
	; 51
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6144 x i8], [6144 x i8]* @__CompressedAssemblyDescriptor_data_51, i32 0, i32 0); data
	}, 
	; 52
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6144 x i8], [6144 x i8]* @__CompressedAssemblyDescriptor_data_52, i32 0, i32 0); data
	}, 
	; 53
	%struct.CompressedAssemblyDescriptor {
		i32 15360, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([15360 x i8], [15360 x i8]* @__CompressedAssemblyDescriptor_data_53, i32 0, i32 0); data
	}, 
	; 54
	%struct.CompressedAssemblyDescriptor {
		i32 47104, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([47104 x i8], [47104 x i8]* @__CompressedAssemblyDescriptor_data_54, i32 0, i32 0); data
	}, 
	; 55
	%struct.CompressedAssemblyDescriptor {
		i32 31744, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([31744 x i8], [31744 x i8]* @__CompressedAssemblyDescriptor_data_55, i32 0, i32 0); data
	}, 
	; 56
	%struct.CompressedAssemblyDescriptor {
		i32 6656, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6656 x i8], [6656 x i8]* @__CompressedAssemblyDescriptor_data_56, i32 0, i32 0); data
	}, 
	; 57
	%struct.CompressedAssemblyDescriptor {
		i32 27648, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([27648 x i8], [27648 x i8]* @__CompressedAssemblyDescriptor_data_57, i32 0, i32 0); data
	}, 
	; 58
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6144 x i8], [6144 x i8]* @__CompressedAssemblyDescriptor_data_58, i32 0, i32 0); data
	}, 
	; 59
	%struct.CompressedAssemblyDescriptor {
		i32 126976, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([126976 x i8], [126976 x i8]* @__CompressedAssemblyDescriptor_data_59, i32 0, i32 0); data
	}, 
	; 60
	%struct.CompressedAssemblyDescriptor {
		i32 8704, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([8704 x i8], [8704 x i8]* @__CompressedAssemblyDescriptor_data_60, i32 0, i32 0); data
	}, 
	; 61
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__CompressedAssemblyDescriptor_data_61, i32 0, i32 0); data
	}, 
	; 62
	%struct.CompressedAssemblyDescriptor {
		i32 14728, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([14728 x i8], [14728 x i8]* @__CompressedAssemblyDescriptor_data_62, i32 0, i32 0); data
	}, 
	; 63
	%struct.CompressedAssemblyDescriptor {
		i32 365056, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([365056 x i8], [365056 x i8]* @__CompressedAssemblyDescriptor_data_63, i32 0, i32 0); data
	}, 
	; 64
	%struct.CompressedAssemblyDescriptor {
		i32 1073664, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([1073664 x i8], [1073664 x i8]* @__CompressedAssemblyDescriptor_data_64, i32 0, i32 0); data
	}, 
	; 65
	%struct.CompressedAssemblyDescriptor {
		i32 748032, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([748032 x i8], [748032 x i8]* @__CompressedAssemblyDescriptor_data_65, i32 0, i32 0); data
	}, 
	; 66
	%struct.CompressedAssemblyDescriptor {
		i32 26112, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([26112 x i8], [26112 x i8]* @__CompressedAssemblyDescriptor_data_66, i32 0, i32 0); data
	}, 
	; 67
	%struct.CompressedAssemblyDescriptor {
		i32 60928, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([60928 x i8], [60928 x i8]* @__CompressedAssemblyDescriptor_data_67, i32 0, i32 0); data
	}, 
	; 68
	%struct.CompressedAssemblyDescriptor {
		i32 224768, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([224768 x i8], [224768 x i8]* @__CompressedAssemblyDescriptor_data_68, i32 0, i32 0); data
	}, 
	; 69
	%struct.CompressedAssemblyDescriptor {
		i32 51200, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([51200 x i8], [51200 x i8]* @__CompressedAssemblyDescriptor_data_69, i32 0, i32 0); data
	}, 
	; 70
	%struct.CompressedAssemblyDescriptor {
		i32 7168, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([7168 x i8], [7168 x i8]* @__CompressedAssemblyDescriptor_data_70, i32 0, i32 0); data
	}, 
	; 71
	%struct.CompressedAssemblyDescriptor {
		i32 419840, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([419840 x i8], [419840 x i8]* @__CompressedAssemblyDescriptor_data_71, i32 0, i32 0); data
	}, 
	; 72
	%struct.CompressedAssemblyDescriptor {
		i32 11776, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([11776 x i8], [11776 x i8]* @__CompressedAssemblyDescriptor_data_72, i32 0, i32 0); data
	}, 
	; 73
	%struct.CompressedAssemblyDescriptor {
		i32 151040, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([151040 x i8], [151040 x i8]* @__CompressedAssemblyDescriptor_data_73, i32 0, i32 0); data
	}, 
	; 74
	%struct.CompressedAssemblyDescriptor {
		i32 79872, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([79872 x i8], [79872 x i8]* @__CompressedAssemblyDescriptor_data_74, i32 0, i32 0); data
	}, 
	; 75
	%struct.CompressedAssemblyDescriptor {
		i32 7680, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([7680 x i8], [7680 x i8]* @__CompressedAssemblyDescriptor_data_75, i32 0, i32 0); data
	}, 
	; 76
	%struct.CompressedAssemblyDescriptor {
		i32 6656, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([6656 x i8], [6656 x i8]* @__CompressedAssemblyDescriptor_data_76, i32 0, i32 0); data
	}, 
	; 77
	%struct.CompressedAssemblyDescriptor {
		i32 55808, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([55808 x i8], [55808 x i8]* @__CompressedAssemblyDescriptor_data_77, i32 0, i32 0); data
	}, 
	; 78
	%struct.CompressedAssemblyDescriptor {
		i32 22528, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([22528 x i8], [22528 x i8]* @__CompressedAssemblyDescriptor_data_78, i32 0, i32 0); data
	}, 
	; 79
	%struct.CompressedAssemblyDescriptor {
		i32 44544, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([44544 x i8], [44544 x i8]* @__CompressedAssemblyDescriptor_data_79, i32 0, i32 0); data
	}, 
	; 80
	%struct.CompressedAssemblyDescriptor {
		i32 15248, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([15248 x i8], [15248 x i8]* @__CompressedAssemblyDescriptor_data_80, i32 0, i32 0); data
	}, 
	; 81
	%struct.CompressedAssemblyDescriptor {
		i32 65024, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([65024 x i8], [65024 x i8]* @__CompressedAssemblyDescriptor_data_81, i32 0, i32 0); data
	}, 
	; 82
	%struct.CompressedAssemblyDescriptor {
		i32 1632256, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([1632256 x i8], [1632256 x i8]* @__CompressedAssemblyDescriptor_data_82, i32 0, i32 0); data
	}, 
	; 83
	%struct.CompressedAssemblyDescriptor {
		i32 963072, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([963072 x i8], [963072 x i8]* @__CompressedAssemblyDescriptor_data_83, i32 0, i32 0); data
	}, 
	; 84
	%struct.CompressedAssemblyDescriptor {
		i32 53248, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([53248 x i8], [53248 x i8]* @__CompressedAssemblyDescriptor_data_84, i32 0, i32 0); data
	}, 
	; 85
	%struct.CompressedAssemblyDescriptor {
		i32 17408, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([17408 x i8], [17408 x i8]* @__CompressedAssemblyDescriptor_data_85, i32 0, i32 0); data
	}, 
	; 86
	%struct.CompressedAssemblyDescriptor {
		i32 463360, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([463360 x i8], [463360 x i8]* @__CompressedAssemblyDescriptor_data_86, i32 0, i32 0); data
	}, 
	; 87
	%struct.CompressedAssemblyDescriptor {
		i32 17920, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([17920 x i8], [17920 x i8]* @__CompressedAssemblyDescriptor_data_87, i32 0, i32 0); data
	}, 
	; 88
	%struct.CompressedAssemblyDescriptor {
		i32 79360, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([79360 x i8], [79360 x i8]* @__CompressedAssemblyDescriptor_data_88, i32 0, i32 0); data
	}, 
	; 89
	%struct.CompressedAssemblyDescriptor {
		i32 585728, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([585728 x i8], [585728 x i8]* @__CompressedAssemblyDescriptor_data_89, i32 0, i32 0); data
	}, 
	; 90
	%struct.CompressedAssemblyDescriptor {
		i32 9216, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([9216 x i8], [9216 x i8]* @__CompressedAssemblyDescriptor_data_90, i32 0, i32 0); data
	}, 
	; 91
	%struct.CompressedAssemblyDescriptor {
		i32 44032, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([44032 x i8], [44032 x i8]* @__CompressedAssemblyDescriptor_data_91, i32 0, i32 0); data
	}, 
	; 92
	%struct.CompressedAssemblyDescriptor {
		i32 175104, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([175104 x i8], [175104 x i8]* @__CompressedAssemblyDescriptor_data_92, i32 0, i32 0); data
	}, 
	; 93
	%struct.CompressedAssemblyDescriptor {
		i32 15872, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([15872 x i8], [15872 x i8]* @__CompressedAssemblyDescriptor_data_93, i32 0, i32 0); data
	}, 
	; 94
	%struct.CompressedAssemblyDescriptor {
		i32 15360, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([15360 x i8], [15360 x i8]* @__CompressedAssemblyDescriptor_data_94, i32 0, i32 0); data
	}, 
	; 95
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__CompressedAssemblyDescriptor_data_95, i32 0, i32 0); data
	}, 
	; 96
	%struct.CompressedAssemblyDescriptor {
		i32 17408, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([17408 x i8], [17408 x i8]* @__CompressedAssemblyDescriptor_data_96, i32 0, i32 0); data
	}, 
	; 97
	%struct.CompressedAssemblyDescriptor {
		i32 36864, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([36864 x i8], [36864 x i8]* @__CompressedAssemblyDescriptor_data_97, i32 0, i32 0); data
	}, 
	; 98
	%struct.CompressedAssemblyDescriptor {
		i32 424448, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([424448 x i8], [424448 x i8]* @__CompressedAssemblyDescriptor_data_98, i32 0, i32 0); data
	}, 
	; 99
	%struct.CompressedAssemblyDescriptor {
		i32 13312, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([13312 x i8], [13312 x i8]* @__CompressedAssemblyDescriptor_data_99, i32 0, i32 0); data
	}, 
	; 100
	%struct.CompressedAssemblyDescriptor {
		i32 40448, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([40448 x i8], [40448 x i8]* @__CompressedAssemblyDescriptor_data_100, i32 0, i32 0); data
	}, 
	; 101
	%struct.CompressedAssemblyDescriptor {
		i32 57856, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([57856 x i8], [57856 x i8]* @__CompressedAssemblyDescriptor_data_101, i32 0, i32 0); data
	}, 
	; 102
	%struct.CompressedAssemblyDescriptor {
		i32 26112, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([26112 x i8], [26112 x i8]* @__CompressedAssemblyDescriptor_data_102, i32 0, i32 0); data
	}, 
	; 103
	%struct.CompressedAssemblyDescriptor {
		i32 1207808, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([1207808 x i8], [1207808 x i8]* @__CompressedAssemblyDescriptor_data_103, i32 0, i32 0); data
	}, 
	; 104
	%struct.CompressedAssemblyDescriptor {
		i32 934912, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([934912 x i8], [934912 x i8]* @__CompressedAssemblyDescriptor_data_104, i32 0, i32 0); data
	}, 
	; 105
	%struct.CompressedAssemblyDescriptor {
		i32 263040, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([263040 x i8], [263040 x i8]* @__CompressedAssemblyDescriptor_data_105, i32 0, i32 0); data
	}, 
	; 106
	%struct.CompressedAssemblyDescriptor {
		i32 103424, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([103424 x i8], [103424 x i8]* @__CompressedAssemblyDescriptor_data_106, i32 0, i32 0); data
	}, 
	; 107
	%struct.CompressedAssemblyDescriptor {
		i32 258048, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([258048 x i8], [258048 x i8]* @__CompressedAssemblyDescriptor_data_107, i32 0, i32 0); data
	}, 
	; 108
	%struct.CompressedAssemblyDescriptor {
		i32 18072, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([18072 x i8], [18072 x i8]* @__CompressedAssemblyDescriptor_data_108, i32 0, i32 0); data
	}, 
	; 109
	%struct.CompressedAssemblyDescriptor {
		i32 2308096, ; uncompressed_file_size
		i8 0, ; loaded
		i8* getelementptr inbounds ([2308096 x i8], [2308096 x i8]* @__CompressedAssemblyDescriptor_data_109, i32 0, i32 0); data
	}
], align 4; end of 'compressed_assembly_descriptors' array


; compressed_assemblies
@compressed_assemblies = local_unnamed_addr global %struct.CompressedAssemblies {
	i32 110, ; count
	%struct.CompressedAssemblyDescriptor* getelementptr inbounds ([110 x %struct.CompressedAssemblyDescriptor], [110 x %struct.CompressedAssemblyDescriptor]* @compressed_assembly_descriptors, i32 0, i32 0); descriptors
}, align 4


!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 1, !"min_enum_size", i32 4}
!3 = !{!"Xamarin.Android remotes/origin/d17-3 @ 030cd63c06d95a6b0d0f563fe9b9d537f84cb84b"}
