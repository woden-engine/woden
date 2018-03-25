Class {
	#name : #WTAthensMeshPathBuilderBackend,
	#superclass : #WTAthensPathBuilderBackend,
	#instVars : [
		'subpathFirstVertex',
		'subpathVertexCount',
		'boundingBox'
	],
	#category : 'Woden2-Athens'
}

{ #category : #adding }
WTAthensMeshPathBuilderBackend >> addIndex: anIndex [
	self subclassResponsibility
]

{ #category : #adding }
WTAthensMeshPathBuilderBackend >> addVertex: aPoint [
	self primitiveAddVertex: aPoint.
	boundingBox insertPoint: aPoint.
	subpathVertexCount := subpathVertexCount + 1.
	subpathVertexCount >= 3 ifTrue: [
		self
			addIndex: subpathFirstVertex;
			addIndex: subpathFirstVertex + subpathVertexCount - 2;
			addIndex: subpathFirstVertex + subpathVertexCount - 1
	]
]

{ #category : #accessing }
WTAthensMeshPathBuilderBackend >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WTAthensMeshPathBuilderBackend >> boundingBox: aWMBox2D [
	boundingBox := aWMBox2D
]

{ #category : #'as yet unclassified' }
WTAthensMeshPathBuilderBackend >> exportWavefront: fileReference [
	fileReference writeStreamDo: [ :out |
		out truncate.
		vertices do: [ :v | 
			out nextPutAll: 'v '; print: v x *0.1; space; print: v y *0.1; nextPutAll: ' 0.0'; lf.
		].
	
		0 to: indices size // 3 - 1 do: [ :i |
			out nextPutAll: 'f '; print: (indices at: i*3 + 1) + 1; space; print: (indices at: i*3 + 2) + 1; space; print: (indices at: i*3 + 3) + 1; lf
		]
	]
]

{ #category : #initialization }
WTAthensMeshPathBuilderBackend >> initialize [
	super initialize.
	boundingBox := WMBox2DF empty.
]

{ #category : #accessing }
WTAthensMeshPathBuilderBackend >> numberOfVertices [
	self subclassResponsibility
]

{ #category : #adding }
WTAthensMeshPathBuilderBackend >> primitiveAddVertex: aPoint [
]

{ #category : #accessing }
WTAthensMeshPathBuilderBackend >> reset [
	subpathFirstVertex := 0.
	subpathVertexCount := 0.
	boundingBox makeEmpty.
]

{ #category : #commands }
WTAthensMeshPathBuilderBackend >> subpathClosed [
	"Nothing to do"
]

{ #category : #commands }
WTAthensMeshPathBuilderBackend >> subpathStarted [
	subpathFirstVertex := self numberOfVertices.
	subpathVertexCount := 0.
]
