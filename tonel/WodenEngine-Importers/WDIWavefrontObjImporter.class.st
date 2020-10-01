"
I am an importer for wavefront .obj 3d models.
"
Class {
	#name : #WDIWavefrontObjImporter,
	#superclass : #WDCSimpleModelLoader,
	#instVars : [
		'currentDirectory',
		'materialLibrary',
		'currentObjectName',
		'rawPositions',
		'rawNormals',
		'rawTexcoords',
		'positions',
		'normals',
		'texcoords',
		'indices',
		'concreteVertexDictionary',
		'submeshes',
		'currentMaterial'
	],
	#classVars : [
		'CommandDictionary'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Importers-Obj'
}

{ #category : #accessing }
WDIWavefrontObjImporter class >> extension [
	^ 'obj'
]

{ #category : #initialization }
WDIWavefrontObjImporter class >> initialize [
	super initialize.
	CommandDictionary := Dictionary newFromPairs: {
		#mtllib . [ :myself :arguments | myself useMaterialLibrary: arguments second ].
		#usemtl . [ :myself :arguments | myself useMaterial: arguments second ].
		#o . [ :myself :arguments | myself beginObject: arguments second ].
		#v . [ :myself :arguments | myself parsePosition: arguments ].
		#vt . [ :myself :arguments | myself parseTexcoord: arguments ].
		#vn . [ :myself :arguments | myself parseNormal: arguments ].
		#f . [ :myself :arguments | myself parseFace: arguments ].
		#l . [ :myself :arguments | myself parseLine: arguments ].
	}
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> addTriangleI1: i1 i2: i2 i3: i3 [
	self beginTriangles.
	indices
		add: i1;
		add: i2;
		add: i3
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> beginLines [
	self beginSubmesh: AGPU_LINES
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> beginObject: objectName [
	currentObjectName := objectName
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> beginSubmesh: primitiveType [
	| submesh |
	submeshes ifNotEmpty: [
		(submeshes last primitiveType = primitiveType and: [ submeshes last material == currentMaterial ]) ifTrue: [ ^ self ].
	].

	self finishCurrentSubmesh.
	submesh := WDCModelSubmesh new
		firstIndex: indices size;
		indexCount: 0;
		primitiveType: primitiveType;
		material: currentMaterial;
		yourself.
	submeshes add: submesh.
	
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> beginTriangles [
	self beginSubmesh: AGPU_TRIANGLES
]

{ #category : #parsing }
WDIWavefrontObjImporter >> buildFaceWithIndices: faceIndices [
	3 to: faceIndices size do: [ :i |
		self addTriangleI1: faceIndices first i2: (faceIndices at: i - 1) i3: (faceIndices at: i)
	]
]

{ #category : #parsing }
WDIWavefrontObjImporter >> concretizeVertex: vertexTopology [
	^ concreteVertexDictionary at: vertexTopology ifAbsentPut: [ self createConcreteVertexIndexFor: vertexTopology ]
]

{ #category : #parsing }
WDIWavefrontObjImporter >> concretizeVertex: vertexTopology faceNormal: faceNormal [
	| position texcoord normal nextIndex |
	position := rawPositions at: vertexTopology first.
	texcoord := vertexTopology second
		ifNil: [Float32x2 zeros]
		ifNotNil: [:index | rawTexcoords at: index].
	normal := vertexTopology third
		ifNil: [faceNormal ]
		ifNotNil: [:index | rawNormals at: index].
	
	^ concreteVertexDictionary at: { position . texcoord . normal } ifAbsentPut: [
		nextIndex := positions size.
		positions add: position.
		texcoords add: texcoord.
		normals add: normal.
		nextIndex
	]
]

{ #category : #'submesh building' }
WDIWavefrontObjImporter >> finishCurrentSubmesh [
	submeshes ifEmpty: [ ^ self ].
	submeshes last indexCount: indices size - submeshes last firstIndex
]

{ #category : #parsing }
WDIWavefrontObjImporter >> finishLoading [
	| vertices |
	self finishCurrentSubmesh.
	vertices := WDCMeshImplicitSeparatedVertexData new.
	vertices
		vertexCount: positions size;
		addChannelNativePositions: positions asNativeArray;
		addChannelNativeTexcoords: texcoords asNativeArray;
		addChannelNativeNormals: normals asNativeArray;
		computeTangents4WithTriangles: (WDCSubmeshTriangleIterator indices: indices submeshes: submeshes);
		generateWhiteColorChannel;
		sortChannels;
		yourself.
	
	^ WDCSimpleModel new
		vertices: vertices;
		indices: indices asNativeArray;
		submeshes: submeshes asArray;
		boundingBox: vertices computeBoundingBox;
		yourself
]

{ #category : #initialization }
WDIWavefrontObjImporter >> initializeLoading [
	rawPositions := OrderedCollection new.
	rawNormals := OrderedCollection new.
	rawTexcoords := OrderedCollection new.
	
	positions := StdnVector newFor: Float32x3.
	normals := StdnVector newFor: Float32x3.
	texcoords := StdnVector newFor: Float32x2.
	
	indices := StdnVector newFor: UInt32.
	
	concreteVertexDictionary := Dictionary new.
	submeshes := OrderedCollection new.
]

{ #category : #loading }
WDIWavefrontObjImporter >> loadFromFileReference: fileRef [
	currentDirectory := fileRef parent.
	^ fileRef readStreamDo: [ :fin |
		self initializeLoading;
			parseLinesWith: (WDCLineReader on: fin);
			finishLoading
	]
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseFace: components [
	| topologies p1 p2 p3 u v n |
	topologies := components allButFirst collect: [ :vertex |
		self parseFaceVertex: vertex
	].

	p1 := rawPositions at: topologies first first.
	p2 := rawPositions at: topologies second first.
	p3 := rawPositions at: topologies third first.
	
	u := p2 - p1.
	v := p3 - p1.
	n := (u cross: v) normalized.

	self buildFaceWithIndices: (topologies collect: [ :topo | self concretizeVertex: topo faceNormal: n])
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseFaceElement: faceElement [
	^ faceElement ifEmpty: [ nil ] ifNotEmpty: [ faceElement asInteger ]
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseFaceVertex: encodedFace [
	| parts |
	parts := (encodedFace splitOn: '/') collect: [ :part | self parseFaceElement: part ].
	parts size = 1 ifTrue: [ ^ parts , #(nil nil) ].
	parts size = 2 ifTrue: [ ^ parts , #(nil) ].
	^ parts
	
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseLine: line [
	| components command |
	line ifEmpty: [ ^ self ].
	line first = $# ifTrue: [ ^ self ].
	
	components := line substrings.
	command := components first.
	(CommandDictionary at: command ifAbsent: [ ^ self ]) value: self value: components
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseLinesWith: lineReader [
	[lineReader atEnd] whileFalse: [
		self parseLine: lineReader nextLine
	].

]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseNormal: components [
	rawNormals add: (Float32x3 x: components second asNumber asFloat y: components third asNumber asFloat z: components fourth asNumber asFloat)
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parsePosition: components [
	rawPositions add: (Float32x3 x: components second asNumber asFloat y: components third asNumber asFloat z: components fourth asNumber asFloat)
]

{ #category : #parsing }
WDIWavefrontObjImporter >> parseTexcoord: components [
	rawTexcoords add: (Float32x2 x: components second asNumber asFloat y: 1.0 - components third asNumber asFloat)
]

{ #category : #parsing }
WDIWavefrontObjImporter >> useMaterial: materialName [
	| newMaterial |
	newMaterial := materialLibrary ifNotNil: [ :lib | materialLibrary at: materialName ifAbsent: [ nil ] ].
	currentMaterial ~= newMaterial ifTrue: [ 
		self finishCurrentSubmesh.
		currentMaterial := newMaterial
	]
	
]

{ #category : #parsing }
WDIWavefrontObjImporter >> useMaterialLibrary: fileName [
	materialLibrary := WDIWavefrontMTLImporter loadFromFile: (currentDirectory resolve: fileName asFileReference)
]
