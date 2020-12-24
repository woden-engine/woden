Class {
	#name : #WCADSolidAbstractBSPNode,
	#superclass : #WCADObject,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #enumerating }
WCADSolidAbstractBSPNode >> allFaces [
	| result |
	result := OrderedCollection new.
	self allFacesDo: [:each | result add: each].
	^ result
]

{ #category : #enumerating }
WCADSolidAbstractBSPNode >> allFacesDo: aBlock [
	self subclassResponsibility
]

{ #category : #building }
WCADSolidAbstractBSPNode >> complement [
	self subclassResponsibility
]

{ #category : #building }
WCADSolidAbstractBSPNode >> differenceWith: otherTree [
	^ self mergeWith: otherTree operateLeafWith: [:leaf :tree | leaf differenceWith: tree ]
]

{ #category : #exporting }
WCADSolidAbstractBSPNode >> encodeWaveFrontObj [
	^ ByteString streamContents: [ :out |
		self encodeWaveFrontObjInto: out
	]
]

{ #category : #exporting }
WCADSolidAbstractBSPNode >> encodeWaveFrontObjInto: out [
	| vertices normals faces vertexDictionary normalDictionary |
	vertices := OrderedCollection new.
	normals := OrderedCollection new.
	faces := OrderedCollection new.
	vertexDictionary := Dictionary new.
	normalDictionary := Dictionary new.
	
	self allFacesDo: [ :face |
		| faceIndices normal normalIndex |
		faceIndices := face vertices collect: [ :v |
			| roundedVertex |
			roundedVertex := (v / Epsilon) floor * Epsilon.
			vertexDictionary at: roundedVertex ifAbsentPut: [
				vertices
					add: roundedVertex;
					size
			]
		].
	
		normal := face plane normal.
		normalIndex := normalDictionary at: normal ifAbsentPut: [
			normals add: normal; size
		].
	
		faces add: { faceIndices . normalIndex }
	].

	vertices do: [ :v |
		out nextPutAll: 'v '; print: v x; space; print: v y; space; print: v z; lf
	].

	normals do: [ :n |
		out nextPutAll: 'vn '; print: n x; space; print: n y; space; print: n z; lf
	].

	faces do: [ :f |
		| faceVertices normal |
		faceVertices := f first.
		normal := f second.
		
		out nextPut: $f. 
		faceVertices do: [ :v |
			 out space; print: v; nextPutAll: '//'; print: normal
		].
		out lf
	].

]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> extractExteriorBoundaryFacesOf: listOfFaces [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> extractInteriorBoundaryFacesOf: listOfFaces [
	self subclassResponsibility
]

{ #category : #accessing }
WCADSolidAbstractBSPNode >> faces [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> fullTreeCopy [
	^ self transformNodesWith: [ :node | node ]
]

{ #category : #building }
WCADSolidAbstractBSPNode >> intersectionWith: otherTree [
	^ self mergeWith: otherTree operateLeafWith: [:leaf :tree | leaf intersectionWith: tree ]
]

{ #category : #testing }
WCADSolidAbstractBSPNode >> isInSetLeaf [
	^ false
]

{ #category : #testing }
WCADSolidAbstractBSPNode >> isLeaf [
	^ false
]

{ #category : #testing }
WCADSolidAbstractBSPNode >> isNotInSetLeaf [
	^ false
]

{ #category : #building }
WCADSolidAbstractBSPNode >> mergeWith: otherTree operateLeafWith: leafBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
WCADSolidAbstractBSPNode >> mesh [
	^ WCADSolidBSPMeshBuilder new addFaces: self allFaces; yourself
]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> partitionWithPlane: partitionPlane [
	self subclassResponsibility
]

{ #category : #exporting }
WCADSolidAbstractBSPNode >> saveWaveFrontObjTo: outputFileName [
	^ outputFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self encodeWaveFrontObjInto: out
	]
]

{ #category : #building }
WCADSolidAbstractBSPNode >> symmetricDifferenceWith: otherTree [
	"^ (self differenceWith: otherTree) unionWith: (otherTree differenceWith: self)"
	^ self mergeWith: otherTree operateLeafWith: [:leaf :tree | leaf symmetricDifferenceWith: tree ]
]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> transformNodesWith: aBlock [
	self subclassResponsibility
]

{ #category : #building }
WCADSolidAbstractBSPNode >> unionWith: otherTree [
	^ self mergeWith: otherTree operateLeafWith: [:leaf :tree | leaf unionWith: tree ]
]
