Class {
	#name : #WDCStructureFieldType,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'componentType',
		'components',
		'rows',
		'normalized',
		'size',
		'alignment',
		'sysmelType'
	],
	#classVars : [
		'FieldTypes'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Structures'
}

{ #category : #'class initialization' }
WDCStructureFieldType class >> initializeFieldTypes [
	<script>
	"
	self initializeFieldTypes
	"
	FieldTypes := Dictionary new.
	#(
		R32G32B32A32_TYPELESS 		(uint 	4 false 16 4)
		R32G32B32A32_FLOAT 			(float 4 false 16 4 Float32x4)
		R32G32B32A32_UINT 				(uint 	4 false 16 4)
		R32G32B32A32_SINT 				(int 	4 false 16 4)

		R32G32B32_TYPELESS 			(uint  3 false 12 4)
		R32G32B32_FLOAT 				(float 3 false 12 4 CompactFloat32x3)
		R32G32B32_UINT 					(uint  3 false 12 4)
		R32G32B32_SINT 					(int  3 false 12 4)

		R16G16B16A16_TYPELESS 		(ushort  4 false 8 4 WMVector4US)
		R16G16B16A16_FLOAT 			(float  4 false 8 4)
		R16G16B16A16_UNORM 			(ushort  4 true 8 4 WMVector4NUS)
		R16G16B16A16_UINT 				(ushort   4 false 8 4 WMVector4US)
		R16G16B16A16_SNORM  			(short  4 true 8 4 WMVector4NS)
		R16G16B16A16_SINT 				(short    4 false 8 4 WMVector4S)

		R32G32_TYPELESS 				(uint  2 false 8 4)
		R32G32_FLOAT 					(float  2 false 8 4 Float32x2)
		R32G32_UINT 						(uint  2 false 8 4)
		R32G32_SINT 						(int  2 false 8 4)
		R32G8X24_TYPELESS 				(uint  2 false 8 4)
		D32_FLOAT_S8X24_UINT 			((float byte)  2 false 8 4)
		R32_FLOAT_S8X24_TYPELESS 	((float byte)  2 false 8 4)
		X32_TYPELESS_G8X24_UINT 		(uint  2 false 8 4)
		R10G10B10A2_TYPELESS 			(uint  4 false 4 4)
		R10G10B10A2_UNORM 				(uint  4 true 4 4)
		R10G10B10A2_UINT 				(uint  4 false 4 4)
		R11G11B10_FLOAT 				(float  3 false 4 4)
						
		R8G8B8A8_TYPELESS 				(byte  4 false 4 4)
		R8G8B8A8_UNORM 					(byte  4 true 4 4)
		R8G8B8A8_UNORM_SRGB 			(byte  4 true 4 4)
		R8G8B8A8_UINT 					(byte  4 false 4 4)
		R8G8B8A8_SNORM 					(sbyte  4 true 4 4)
		R8G8B8A8_SINT 					(sbyte  4 false 4 4)
							
		R16G16_TYPELESS 				(ushort  2 false 4 4)
		R16G16_FLOAT 					(float  2 false 4 4)
		R16G16_UNORM 					(ushort  2 true 4 4)
		R16G16_UINT 						(ushort  2 false 4 4)
		R16G16_SNORM 					(short  2 true 4 4)
		R16G16_SINT 						(short  2 false 4 4)
								
		R32_TYPELESS 					(uint 1 false 4 4)
		D32_FLOAT 						(float 1 false 4 4)
		R32_FLOAT 						(float 1 false 4 4)
		R32_UINT 							(uint 1 false 4 4)
		R32_SINT 							(sint 1 false 4 4)
									
		"R24G8_TYPELESS
		D24_UNORM_S8_UINT
		R24_UNORM_X8_TYPELESS
		X24TG8_UINT
		
		R8G8_TYPELESS
		R8G8_UNORM
		R8G8_UINT
		R8G8_SNORM
		R8G8_SINT
		
		R16_TYPELESS
		R16_FLOAT
		D16_UNORM
		R16_UNORM
		R16_UINT
		R16_SNORM
		R16_SINT
		
		R8_TYPELESS
		R8_UNORM
		R8_UINT
		R8_SNORM
		R8_SINT
		A8_UNORM
		R1_UNORM
		
		B5G6R5_UNORM
		B5G5R5A1_UNORM
		B8G8R8A8_UNORM
		B8G8R8X8_UNORM
		B8G8R8A8_TYPELESS
		B8G8R8A8_UNORM_SRGB
		B8G8R8X8_TYPELESS
		B8G8R8X8_UNORM_SRGB"
	) pairsDo: [ :formatName :spec |
		| formatId componentType components normalized size alignment type sysmelType |
		formatId := (AGPUConstants bindingOf: (#AGPU_TEXTURE_FORMAT_ , formatName) asSymbol) value.
		self assert: formatId isNotNil.
		componentType := spec first.
		components := spec second.
		normalized := spec third.
		size := spec fourth.
		alignment := spec fifth.
		sysmelType := self parseOptionalSLVMType: (spec at: 6 ifAbsent: nil).
		type := self new
			name: formatName asSymbol;
			componentType: componentType;
			components: components; 
			format: formatId;
			normalized: normalized;
			rows: 1;
			size: size;
			alignment: alignment;
			sysmelType: sysmelType;
			yourself.
		FieldTypes at: type name put: type
	].

	#(
		byte 		(UNKNOWN byte 1 false 1 1 UInt8)
		byte2 		(UNKNOWN byte 2 false 2 2 UInt8x2)
		byte3 		(UNKNOWN byte 3 false 3 4 UInt8x3)
		byte4 		(R8G8B8A8_UINT byte 4 false 4 4 UInt8x4)

		ushort		(R16_UINT ushort 1 false 2 2 UInt16)
		ushort2	(R16G16_UINT ushort 2 false 4 4 UInt16x2)
		ushort3	(UNKNOWN ushort 3 false 6 8 UInt16x3)
		ushort4	(R16G16B16A16_UINT ushort 4 false 8 8 UInt16x4)

		uint	(R32_UINT uint 1 false 4 4 UInt32)
		uint2	(R32G32_UINT uint 2 false 8 8 UInt32x2)
		uint3	(R32G32B32_UINT uint 3 false 12 16 UInt32x3)
		uint4	(R32G32B32A32_UINT uint 4 false 16 16 UInt32x4)

		float 		(R32_FLOAT float 1 false 4 4 Float32)
		float2 	(R32G32_FLOAT float 2 false 8 8 Float32x2)
		float3 	(R32G32B32_FLOAT  float 3 false 16 16 Float32x3)
		float4 	(R32G32B32A32_FLOAT  float 4 false 16 16 Float32x4)

		float2x2 	(R32G32_FLOAT float 2 false 16 8 Float32x2x2 2)
		float3x3 	(R32G32B32_FLOAT float 3 false 48 16 Float32x3x3 3)
		float4x4 	(R32G32B32A32_FLOAT float 4 false 64 16 Float32x4x4 4)
	) pairsDo: [ :formatName :spec |
		| formatId componentType components normalized size alignment type sysmelType rows |
		formatId := (AGPUConstants bindingOf: (#AGPU_TEXTURE_FORMAT_ , spec first) asSymbol) value.
		self assert: formatId isNotNil.
		componentType := spec second.
		components := spec third.
		normalized := spec fourth.
		size := spec fifth.
		alignment := spec sixth.
		sysmelType := self parseOptionalSLVMType: (spec at: 7 ifAbsent: [nil]).
		rows := spec at: 8 ifAbsent: [1].
		type := self new
			name: formatName asSymbol;
			componentType: componentType;
			components: components; 
			format: formatId;
			normalized: normalized;
			rows: rows;
			size: size;
			alignment: alignment;
			sysmelType: sysmelType;
			yourself.
		FieldTypes at: type name put: type
	]
]

{ #category : #'class initialization' }
WDCStructureFieldType class >> parseOptionalSLVMType: typeName [
	typeName ifNil: [ ^ typeName ].
	
	^ (self bindingOf: typeName) ifNil: [typeName ] ifNotNil: [:binding | binding value]
]

{ #category : #accessing }
WDCStructureFieldType class >> typeNamed: typeName [
	FieldTypes ifNil: [ self initializeFieldTypes ].
	^ FieldTypes at: typeName asSymbol
]

{ #category : #accessing }
WDCStructureFieldType >> alignment [
	^ alignment
]

{ #category : #accessing }
WDCStructureFieldType >> alignment: anObject [
	alignment := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> componentType [
	^ componentType
]

{ #category : #accessing }
WDCStructureFieldType >> componentType: anObject [
	componentType := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> components [
	^ components
]

{ #category : #accessing }
WDCStructureFieldType >> components: anObject [
	components := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> format [
	^ format
]

{ #category : #accessing }
WDCStructureFieldType >> format: anObject [
	format := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> name [
	^ name
]

{ #category : #accessing }
WDCStructureFieldType >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> normalized [
	^ normalized
]

{ #category : #accessing }
WDCStructureFieldType >> normalized: anObject [
	normalized := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> rows [
	^ rows
]

{ #category : #accessing }
WDCStructureFieldType >> rows: anObject [
	rows := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> size [
	^ size
]

{ #category : #accessing }
WDCStructureFieldType >> size: anObject [
	size := anObject
]

{ #category : #accessing }
WDCStructureFieldType >> sysmelType [
	^ sysmelType
]

{ #category : #accessing }
WDCStructureFieldType >> sysmelType: anObject [
	sysmelType := anObject
]
