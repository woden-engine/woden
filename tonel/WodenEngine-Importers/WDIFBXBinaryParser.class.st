Class {
	#name : #WDIFBXBinaryParser,
	#superclass : #Object,
	#instVars : [
		'version',
		'in'
	],
	#classVars : [
		'MagicString',
		'PropertyTypeParserDictionary'
	],
	#category : #'WodenEngine-Importers-FBX'
}

{ #category : #initialization }
WDIFBXBinaryParser class >> initialize [
	super initialize.
	MagicString := 'Kaydara FBX Binary  ' asByteArray , #[0 16r1a 16r00].
	
	PropertyTypeParserDictionary := Dictionary newFromPairs: #(
		"Primitive types"
		$Y readInt16
		$C readBoolean
		$I readInt32
		$F readFloat32
		$D readFloat64
		$L readInt64

		"Array types"
		$f readFloat32Array
		$d readFloat64Array
		$l readInt64Array
		$i readInt32Array
		$b readBooleanArray

		"Special types"
		$S readString
		$R readBinary
	)
]

{ #category : #'as yet unclassified' }
WDIFBXBinaryParser class >> loadFromFile: aFileName [
	^ self new loadFromFile: aFileName
]

{ #category : #'as yet unclassified' }
WDIFBXBinaryParser >> loadFromFile: aFileName [
	aFileName asFileReference readStreamDo: [ :i |
		i binary.
		^ self loadFromStream: i
	].
	
]

{ #category : #reading }
WDIFBXBinaryParser >> loadFromStream: i [
	in := WDCBinaryLittleEndianReadStream on: i.
	(in next: MagicString size) ~= MagicString ifTrue: [
		self error: 'Invalid binary FBX magic string.'
	].
	version := in nextUInt32.
	^ self readRootNode
]

{ #category : #reading }
WDIFBXBinaryParser >> readArrayWithElementType: elementType [
	| arrayLength encoding compressedLength zlibStream |
	arrayLength := in nextUInt32.
	encoding := in nextUInt32.
	compressedLength := in nextUInt32.

	self flag: 'TODO: Support endiannes conversion'.
	encoding = 0 ifTrue: [
		^ SLVMNativeArray for: elementType withBytes: (in next: arrayLength * elementType size)
	].
	encoding = 1 ifTrue: [
		zlibStream := ZLibReadStream on: (in next: compressedLength).
		^ SLVMNativeArray for: elementType withBytes: (zlibStream next: arrayLength * elementType size)
	].

	self error: 'Unsupport fbx array encoding type ' , encoding printString
]

{ #category : #reading }
WDIFBXBinaryParser >> readBinary [
	| length |
	length := in nextUInt32.
	^ in next: length
]

{ #category : #reading }
WDIFBXBinaryParser >> readBoolean [
	^ in nextUInt8 ~= 0
]

{ #category : #reading }
WDIFBXBinaryParser >> readBooleanArray [
	^ self readArrayWithElementType: SLVMCompilationTargetTypes forCurrentImage bool
]

{ #category : #reading }
WDIFBXBinaryParser >> readFloat32 [
	^ in nextFloat32
]

{ #category : #reading }
WDIFBXBinaryParser >> readFloat32Array [
	^ self readArrayWithElementType: SLVMCompilationTargetTypes forCurrentImage float32
]

{ #category : #reading }
WDIFBXBinaryParser >> readFloat64 [
	^ in nextFloat64
]

{ #category : #reading }
WDIFBXBinaryParser >> readFloat64Array [
	^ self readArrayWithElementType: SLVMCompilationTargetTypes forCurrentImage float64
]

{ #category : #reading }
WDIFBXBinaryParser >> readInt16 [
	^ in nextInt16
]

{ #category : #reading }
WDIFBXBinaryParser >> readInt32 [
	^ in nextInt32
]

{ #category : #reading }
WDIFBXBinaryParser >> readInt32Array [
	^ self readArrayWithElementType: SLVMCompilationTargetTypes forCurrentImage int32
]

{ #category : #reading }
WDIFBXBinaryParser >> readInt64 [
	^ in nextInt64
]

{ #category : #reading }
WDIFBXBinaryParser >> readInt64Array [
	^ self readArrayWithElementType: SLVMCompilationTargetTypes forCurrentImage int64
]

{ #category : #'as yet unclassified' }
WDIFBXBinaryParser >> readNode [
	| endOffset numProperties propertyListLen nameLen name result child |
	endOffset := in nextUInt32.
	numProperties := in nextUInt32.
	propertyListLen := in nextUInt32.
	nameLen := in nextUInt8.
	name := (in next: nameLen) asString.
	
	result := WDIFBXNode new type: name asSymbol.
	result attributes: ((1 to: numProperties) collect: [ :i | self readProperty ]).
	result children: (Array streamContents: [:out |
		[in atEnd not and: [in position < endOffset]] whileTrue: [
			child := self readNode.
			child type ifNotEmpty: [ 
				out nextPut: child.
			]
		]
	]).

	^ result
]

{ #category : #'as yet unclassified' }
WDIFBXBinaryParser >> readProperty [
	| type |
	type := in next asCharacter.
	^ self perform: (PropertyTypeParserDictionary at: type)
]

{ #category : #reading }
WDIFBXBinaryParser >> readRootNode [
	| node rootNodes |
	node := self readNode.
	node type ifEmpty: [ ^ node ].
	
	rootNodes := Array streamContents: [ :out |
		out nextPut: node.
		[in atEnd not and: [node type isNotEmpty] ] whileTrue: [
			node := self readNode.
			node type ifNotEmpty: [ 
				out nextPut: node
			]
		]
	].
	^ WDIFBXNode new
		type: #__Root__;
		children: rootNodes;
		yourself
		
]

{ #category : #reading }
WDIFBXBinaryParser >> readString [
	| length |
	length := in nextUInt32.
	^ (in next: length) asString
]
