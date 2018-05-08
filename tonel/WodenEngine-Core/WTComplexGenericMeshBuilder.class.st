Class {
	#name : #WTComplexGenericMeshBuilder,
	#superclass : #WTGenericMeshBuilder,
	#instVars : [
		'transform'
	],
	#classVars : [
		'NormalAxis'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	"Potential normal axis"
	NormalAxis := { 
		WMVector3F x: 1.0 y: 0.0 z: 0.0 .
		WMVector3F x: -1.0 y: 0.0 z: 0.0 .
		WMVector3F x: 0.0 y: 1.0 z: 0.0 .
		WMVector3F x: 0.0 y: -1.0 z: 0.0 .
		WMVector3F x: 0.0 y: 0.0 z: 1.0 .
		WMVector3F x: 0.0 y: 0.0 z: -1.0 .
	}.
]

{ #category : #adding }
WTComplexGenericMeshBuilder >> addP: position N: normal TC: texcoord [
	vertices add: (WTGenericVertexF new
		position: (transform transformPosition3: position);
		normal: (transform transformNormal: normal);
		texcoord: texcoord;
		color: currentColor;
		yourself)
]

{ #category : #adding }
WTComplexGenericMeshBuilder >> addP: position TC: texcoord [
	vertices add: (WTGenericVertexF new
		position: (transform transformPosition3: position);
		texcoord: texcoord;
		color: currentColor;
		yourself)
]

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder >> bitangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 3) rem: NormalAxis size) + 1
]

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder >> computeNormalAxis: normal [
	| amount bestAmount best |
	bestAmount := -1000.0.
	best := -1.
	1 to: NormalAxis size do: [ :i |
		amount := normal dot: (NormalAxis at: i).
		amount > bestAmount ifTrue: [
			bestAmount := amount.
			best := i.
		]
	].

	best < 1 ifTrue: [ self error: 'Using invalid normal.' ].
	^ best

]

{ #category : #initialization }
WTComplexGenericMeshBuilder >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
]

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder >> planeTextureScale: texScale offset: texOffset [
	self planeTextureTransform: (WMMatrix3F texScale: texScale offset: texOffset).
]

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder >> planeTextureTransform: textureMatrix [
	| vertex normal position normalAxis tangent bitangent uv |
	1 to: vertices size do: [ :vi |
		vertex := vertices at: vi.
		normal := vertex normal asWMVector3.
		position := vertex position asWMVector3.
		
		"Compute the predominant normal plane."
		normalAxis := self computeNormalAxis: normal.
		tangent := self tangentForAxis: normalAxis.
		bitangent := self bitangentForAxis: normalAxis.
		
		"Compute the new texcoord"
		uv := WMVector2F x: (tangent dot: position) y: (bitangent dot: position).
		vertex texcoord: (textureMatrix transformPosition2: uv).
		
		vertices at: vi put: vertex.
	]

]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateDegreesOnX: radians [
	transform rotateDegreesOnX: radians
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateDegreesOnY: radians [
	transform rotateDegreesOnY: radians
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateDegreesOnZ: radians [
	transform rotateDegreesOnZ: radians
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateRadiansOnX: radians [
	transform rotateRadiansOnX: radians
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateRadiansOnY: radians [
	transform rotateRadiansOnY: radians
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> rotateRadiansOnZ: radians [
	transform rotateRadiansOnZ: radians
]

{ #category : #'as yet unclassified' }
WTComplexGenericMeshBuilder >> tangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 1) rem: NormalAxis size) + 1
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> transform [
	^ transform
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> transform: aTransform [
	transform := aTransform
]

{ #category : #accessing }
WTComplexGenericMeshBuilder >> translateToX: tx y: ty z: tz [
	transform translateToX: tx y: ty z: tz
]
