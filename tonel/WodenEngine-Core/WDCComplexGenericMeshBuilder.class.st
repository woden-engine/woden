"
I am a generic mesh builder that also has supports for transformations.
"
Class {
	#name : #WDCComplexGenericMeshBuilder,
	#superclass : #WDCGenericMeshBuilder,
	#instVars : [
		'transform'
	],
	#classVars : [
		'NormalAxis'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	"Potential normal axis"
	NormalAxis := { 
		Float32x3 x: 1.0 y: 0.0 z: 0.0 .
		Float32x3 x: -1.0 y: 0.0 z: 0.0 .
		Float32x3 x: 0.0 y: 1.0 z: 0.0 .
		Float32x3 x: 0.0 y: -1.0 z: 0.0 .
		Float32x3 x: 0.0 y: 0.0 z: 1.0 .
		Float32x3 x: 0.0 y: 0.0 z: -1.0 .
	}.
]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		color: currentColor;
		yourself)

]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position C: color [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		color: color asFloat32x4;
		yourself)

]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position N: normal [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		normal: (transform transformNormal: normal);
		color: currentColor;
		yourself)

]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position N: normal T4: tangent4 TC: texcoord [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		normal: (transform transformNormal: normal);
		tangent4: (Float32x4 xyz: (transform transformNormal: tangent4 xyz) w: tangent4 w);
		texcoord: texcoord;
		color: currentColor;
		yourself)
]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position N: normal TC: texcoord [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		normal: (transform transformNormal: normal);
		texcoord: texcoord;
		color: currentColor;
		yourself)
]

{ #category : #adding }
WDCComplexGenericMeshBuilder >> addP: position TC: texcoord [
	vertices add: (WDCGenericVertexF32 new
		position: (transform transformPosition: position);
		texcoord: texcoord;
		color: currentColor;
		yourself)
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> addSolidBox: box [
	self restoreTransformAfter: [
		transform translateBy: box center asFloat32x3.
		self addCubeWithWidth: box width height: box height depth: box depth
	]
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> addWireBox: box [
	self restoreTransformAfter: [
		transform translateBy: box center asFloat32x3.
		self addWireCubeWithWidth: box width height: box height depth: box depth
	]
]

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder >> bitangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 3) rem: NormalAxis size) + 1
]

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder >> computeNormalAxis: normal [
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
WDCComplexGenericMeshBuilder >> initialize [
	super initialize.
	transform := ReversibleAffineTransform3dF32 identity.
]

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder >> planeTextureScale: texScale offset: texOffset [
	self planeTextureTransform: (Float32x3x3 texScale: texScale offset: texOffset).
]

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder >> planeTextureTransform: textureMatrix [
	| vertex normal position normalAxis tangent bitangent uv |
	1 to: vertices size do: [ :vi |
		vertex := vertices at: vi.
		normal := vertex normal asFloat32x3.
		position := vertex position asFloat32x3.
		
		"Compute the predominant normal plane."
		normalAxis := self computeNormalAxis: normal.
		tangent := self tangentForAxis: normalAxis.
		bitangent := self bitangentForAxis: normalAxis.
		
		"Compute the new texcoord"
		uv := Float32x2 x: (tangent dot: position) y: (bitangent dot: position).
		vertex texcoord: (textureMatrix transformVector2: uv).
		
		vertices at: vi put: vertex.
	]

]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> restoreTransformAfter: aBlock [
	| transformCopy |
	transformCopy := transform copy.
	[ 
		aBlock value
	] ensure: [ transform := transformCopy ]
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateDegreesOnX: radians [
	transform rotateDegreesOnX: radians
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateDegreesOnY: radians [
	transform rotateDegreesOnY: radians
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateDegreesOnZ: radians [
	transform rotateDegreesOnZ: radians
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateRadiansOnX: radians [
	transform rotateRadiansOnX: radians
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateRadiansOnY: radians [
	transform rotateRadiansOnY: radians
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> rotateRadiansOnZ: radians [
	transform rotateRadiansOnZ: radians
]

{ #category : #initialization }
WDCComplexGenericMeshBuilder >> setIdentityTransform [
	self transform: ReversibleAffineTransform3dF32 identity
]

{ #category : #'as yet unclassified' }
WDCComplexGenericMeshBuilder >> tangentForAxis: normalAxis [
	^ NormalAxis at: ((normalAxis + 1) rem: NormalAxis size) + 1
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> transform [
	^ transform
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> transform: aTransform [
	transform := aTransform
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> translateToX: tx y: ty z: tz [
	transform translateToX: tx y: ty z: tz
]

{ #category : #accessing }
WDCComplexGenericMeshBuilder >> withTransform: newTransform do: aBlock [
	| oldTransform |
	oldTransform := transform.
	transform := newTransform.
	[
		aBlock cull: self
	] ensure: [ transform := oldTransform ]
]
