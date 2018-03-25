Class {
	#name : #WTAthensSurfaceThinLinePathBuilderBackend,
	#superclass : #WTAthensPathBuilderBackend,
	#instVars : [
		'surface',
		'closed',
		'subpathFirstVertex',
		'pathVertexCount',
		'subpathVertexCount'
	],
	#category : 'Woden2-Athens'
}

{ #category : #adding }
WTAthensSurfaceThinLinePathBuilderBackend >> addVertex: aPoint [
	surface addVertex: aPoint asWMVector2F.
	pathVertexCount := pathVertexCount + 1.
	subpathVertexCount := subpathVertexCount + 1.
	subpathVertexCount >= 2 ifTrue: [
		surface
			addIndex: subpathFirstVertex + subpathVertexCount - 2;
			addIndex: subpathFirstVertex + subpathVertexCount - 1
	]
]

{ #category : #accessing }
WTAthensSurfaceThinLinePathBuilderBackend >> reset [
	closed := true.
	subpathFirstVertex := 0.
	subpathVertexCount := 0.
	pathVertexCount := 0.
]

{ #category : #commands }
WTAthensSurfaceThinLinePathBuilderBackend >> subpathClosed [
	closed ifTrue: [ ^ self ].
	subpathVertexCount > 2 ifTrue: [ 
		surface
			addIndex: subpathFirstVertex + subpathVertexCount - 1;
			addIndex: subpathFirstVertex.
	].

	closed := true.
]

{ #category : #commands }
WTAthensSurfaceThinLinePathBuilderBackend >> subpathStarted [
	subpathFirstVertex := pathVertexCount.
	subpathVertexCount := 0.
	closed := false.
]

{ #category : #accessing }
WTAthensSurfaceThinLinePathBuilderBackend >> surface [
	^ surface
]

{ #category : #accessing }
WTAthensSurfaceThinLinePathBuilderBackend >> surface: anObject [
	surface := anObject
]
