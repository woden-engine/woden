"
I am importer for models in the Standford PLY format.

https://en.wikipedia.org/wiki/PLY_(file_format)

"
Class {
	#name : #WDIStanfordPLYImporter,
	#superclass : #WDCSimpleModelLoader,
	#instVars : [
		'elements',
		'elementDictionary',
		'currentElement'
	],
	#classVars : [
		'CommandDictionary'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #accessing }
WDIStanfordPLYImporter class >> extension [
	^ 'ply'
]

{ #category : #initialization }
WDIStanfordPLYImporter class >> initialize [
	super initialize.
	
	CommandDictionary := Dictionary new.
	
	{
		#comment . [ :myself :argument | ].
		#element . [ :myself :arguments | myself beginElement: arguments ].
		#property . [ :myself :arguments | myself parseProperty: arguments].
	} pairsDo: [ :command :action |
		CommandDictionary at: command put: action
	]
]

{ #category : #loading }
WDIStanfordPLYImporter >> addTriangleI1: i1 i2: i2 i3: i3 into: indices [
	indices
		add: i1;
		add: i2;
		add: i3
]

{ #category : #'header parsing' }
WDIStanfordPLYImporter >> beginElement: arguments [
	| name count |
	name := arguments second.
	count := arguments third asInteger.
	currentElement := WDIStanfordPLYElement new
		name: name;
		count: count;
		yourself.
		
	elements add: currentElement.
	elementDictionary at: name put: currentElement
]

{ #category : #loading }
WDIStanfordPLYImporter >> extractIndices [
	| faceElement indexOfFaceIndices indexList indices |
	indices := StdnVector newFor: UInt32.
	
	faceElement := elementDictionary at: #face.
	indexOfFaceIndices := faceElement indexOfProperty: #vertex_indices.
	faceElement values do: [ :faceValue |
		indexList := faceValue at: indexOfFaceIndices.
		self triangulateFace: indexList into: indices
	].

	^ indices asNativeArray
]

{ #category : #loading }
WDIStanfordPLYImporter >> extractPositions [
	| vertexElement positions values xi yi zi x y z vertexValue |
	vertexElement := elementDictionary at: 'vertex'.
	positions := SLVMNativeArray for: Float32x3 new: vertexElement count.
	values := vertexElement values.
	xi := vertexElement indexOfProperty: #x.
	yi := vertexElement indexOfProperty: #y.
	zi := vertexElement indexOfProperty: #z.
	
	1 to: vertexElement count do: [ :index |
		vertexValue := values at: index.
		x := vertexValue at: xi.
		y := vertexValue at: yi.
		z := vertexValue at: zi.
		
		positions at: index put: (Float32x3 x: x y: y z: z)
	].

	^ positions
]

{ #category : #loading }
WDIStanfordPLYImporter >> finishLoading [
	| positions indices submesh submeshes vertices triangles |
	positions := self extractPositions.
	indices := self extractIndices.
	
	submesh := WDCModelSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: WDCMetallicRoughnessMaterial new;
		yourself.
	submeshes := {submesh}.
		
	triangles := WDCSubmeshTriangleIterator indices: indices submeshes: submeshes.
	vertices := WDCMeshImplicitSeparatedVertexData new.
	vertices
		vertexCount: positions size;
		addChannelNativePositions: positions asNativeArray;
		generateEmptyTexcoords;
		computeNormalsWithTriangles: triangles;
		computeTangents4WithTriangles: triangles;
		generateWhiteColorChannel;
		sortChannels.
	
	^ WDCSimpleModel new
		vertices: vertices;
		indices: indices asNativeArray;
		submeshes: submeshes asArray;
		boundingBox: vertices computeBoundingBox;
		yourself
]

{ #category : #loading }
WDIStanfordPLYImporter >> initializeLoading [
	elements := OrderedCollection new.
	elementDictionary := Dictionary new.
]

{ #category : #loading }
WDIStanfordPLYImporter >> loadFromFileReference: fileRef [
	^ fileRef readStreamDo: [ :fin |
		self initializeLoading;
			parseLinesWith: (WDCLineReader on: fin);
			finishLoading
	]
]

{ #category : #'content parsing' }
WDIStanfordPLYImporter >> parseContentWith: tokenReader [
	elements do: [ :element | self parseElementContent: element with: tokenReader ]
]

{ #category : #'content parsing' }
WDIStanfordPLYImporter >> parseElementContent: element with: tokenReader [
	| values properties |
	properties := element properties asArray.
	values := (1 to: element count) collect: [ :i |
		properties collect: [ :property | property readFrom: tokenReader ].
	].

	element values: values
]

{ #category : #'header parsing' }
WDIStanfordPLYImporter >> parseHeaderWith: lineReader [
	| line arguments |
	lineReader nextLine ~= 'ply' ifTrue: [ self error: 'Expected ply header' ].
	lineReader nextLine ~= 'format ascii 1.0' ifTrue: [ self error: 'Only ASCII ply format is supported.' ].
	
	[ lineReader atEnd ] whileFalse: [ 
		line := lineReader nextLine.
		line = 'end_header' ifTrue: [ ^ self ].
		
		arguments := line splitOn: ' '.
		(CommandDictionary at: arguments first) value: self value: arguments
	]

]

{ #category : #loading }
WDIStanfordPLYImporter >> parseLinesWith: lineReader [
	self
		parseHeaderWith: lineReader;
		parseContentWith: lineReader asSpaceTokenReader
]

{ #category : #'header parsing' }
WDIStanfordPLYImporter >> parseProperty: arguments [
	| type name property |
	type := arguments second.
	type = 'list' ifTrue: [ ^ self parsePropertyList: arguments ].

	name := arguments third.
	property := (WDIStanfordPLYProperty findPropertyClassFromType: type) new name: name.
	currentElement addProperty: property
	
]

{ #category : #'header parsing' }
WDIStanfordPLYImporter >> parsePropertyList: arguments [
	| countType elementType name property |
	countType := WDIStanfordPLYProperty findPropertyClassFromType: arguments third.
	elementType := WDIStanfordPLYProperty findPropertyClassFromType: arguments fourth.
	name := arguments fifth.
	
	property := WDIStanfordPLYPropertyList new name: name;
		countType: countType new;
		elementType: elementType new;
		yourself.
	currentElement addProperty: property
]

{ #category : #loading }
WDIStanfordPLYImporter >> triangulateFace: faceIndices into: indices [
	3 to: faceIndices size do: [ :i |
		self addTriangleI1: faceIndices first i2: (faceIndices at: i - 1) i3: (faceIndices at: i) into: indices
	]
]
