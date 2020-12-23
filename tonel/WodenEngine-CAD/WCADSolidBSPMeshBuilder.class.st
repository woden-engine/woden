Class {
	#name : #WCADSolidBSPMeshBuilder,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'vertexDictionary',
		'indices'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #adding }
WCADSolidBSPMeshBuilder >> addFace: face [
	| normal faceIndices |
	normal := face plane normal.
	faceIndices := face vertices collect: [ :vertex |
		self addVertex: vertex normal: normal
	].
	self addTriangleFanFor: faceIndices
]

{ #category : #adding }
WCADSolidBSPMeshBuilder >> addFaces: faces [
	faces do: [ :each | self addFace: each ]
]

{ #category : #adding }
WCADSolidBSPMeshBuilder >> addTriangleFanFor: faceIndices [
	3 to: faceIndices size do: [ :i |
		indices
			add: faceIndices first;
			add: (faceIndices at: i - 1);
			add: (faceIndices at: i)
	]
]

{ #category : #adding }
WCADSolidBSPMeshBuilder >> addVertex: position normal: normal [
	| vertex |
	vertex := WCADSolidBSPMeshVertex new position: position; normal: normal; yourself.
	^ vertexDictionary at: vertex ifAbsentPut: [ 
		| index |
		index := vertices size.
		vertices add: vertex.
		index
	]
]

{ #category : #exporting }
WCADSolidBSPMeshBuilder >> encodeWaveFrontObj [
	^ ByteString streamContents: [ :out |
		self encodeWaveFrontObjInto: out
	]
]

{ #category : #exporting }
WCADSolidBSPMeshBuilder >> encodeWaveFrontObjInto: out [
	| triangleCount nextIndex |
	vertices do: [ :each |
		| position normal |
		position := each position.
		out nextPutAll: 'v '; nextPutAll: position x asString;
			space; nextPutAll: position y asString;
			space; nextPutAll: position z asString;
			lf.

		normal := each normal.
		out nextPutAll: 'vn '; nextPutAll: normal x asString;
			space; nextPutAll: normal y asString;
			space; nextPutAll: normal z asString;
			lf.
	].

	triangleCount := indices size // 3.
	nextIndex := 1.
	1 to: triangleCount do: [ :index |
		| i1 i2 i3 |
		i1 := (indices at: nextIndex) + 1.
		nextIndex := nextIndex + 1.

		i2 := (indices at: nextIndex) + 1.
		nextIndex := nextIndex + 1.

		i3 := (indices at: nextIndex) + 1.
		nextIndex := nextIndex + 1.

		out nextPutAll: 'f '; nextPutAll: i1 asString; nextPutAll: '//'; nextPutAll: i1 asString;
			space; nextPutAll: i2 asString; nextPutAll: '//'; nextPutAll: i2 asString;
			space; nextPutAll: i3 asString; nextPutAll: '//'; nextPutAll: i3 asString;
			lf.
	]
]

{ #category : #initialization }
WCADSolidBSPMeshBuilder >> initialize [
	super initialize.
	vertices := OrderedCollection new.
	vertexDictionary := Dictionary new.
	indices := OrderedCollection new.
]

{ #category : #exporting }
WCADSolidBSPMeshBuilder >> saveWaveFrontObjTo: outputFileName [
	^ outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self encodeWaveFrontObjInto: out
	]
]
