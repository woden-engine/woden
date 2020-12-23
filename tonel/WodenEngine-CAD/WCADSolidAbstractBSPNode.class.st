Class {
	#name : #WCADSolidAbstractBSPNode,
	#superclass : #Object,
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

{ #category : #exporting }
WCADSolidAbstractBSPNode >> encodeWaveFrontObj [
	^ ByteString streamContents: [ :out |
		self encodeWaveFrontObjInto: out
	]
]

{ #category : #exporting }
WCADSolidAbstractBSPNode >> encodeWaveFrontObjInto: out [
	| faceIndex baseVertex |
	faceIndex := 1.
	baseVertex := 1.
	
	self allFacesDo: [ :each |
		| normal |
		normal := each plane normal.
		out nextPutAll: 'vn '; nextPutAll: normal x asString;
			space; nextPutAll: normal y asString;
			space; nextPutAll: normal z asString;
			lf.
			
		each vertices do: [ :vertex |
			out nextPutAll: 'v '; nextPutAll: vertex x asString;
				space; nextPutAll: vertex y asString;
				space; nextPutAll: vertex z asString;
				lf.
		].
		
		out nextPut: $f.
		0 to: each vertices size - 1 do: [ :i |
			out space; nextPutAll: (i + baseVertex) asString; nextPutAll: '//'; nextPutAll: faceIndex asString
		].
		out lf; lf.
			
		baseVertex := baseVertex + each vertices size.
		faceIndex := faceIndex + 1.
	]
]

{ #category : #accessing }
WCADSolidAbstractBSPNode >> faces [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> fullTreeCopy [
	^ self transformNodesWith: [ :node | node ]
]

{ #category : #testing }
WCADSolidAbstractBSPNode >> isNullNode [
	^ false
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

{ #category : #'as yet unclassified' }
WCADSolidAbstractBSPNode >> transformNodesWith: aBlock [
	self subclassResponsibility
]

{ #category : #building }
WCADSolidAbstractBSPNode >> unionWith: otherTree [
	self subclassResponsibility
]
