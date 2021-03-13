Class {
	#name : #WDCSimpleModelExporter,
	#superclass : #WDCAbstractModelExporter,
	#instVars : [
		'currentTransform',
		'transformStack',
		'positions',
		'colors',
		'texcoords',
		'normals',
		'tangents4',
		'boneIndices',
		'boneWeights',
		'baseVertex',
		'indices',
		'baseIndex',
		'vertexCount',
		'baseIndexStack',
		'currentInverseTransposed',
		'currentSubmesh',
		'submeshes'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> beginLight [
	"Ignored"
]

{ #category : #accessing }
WDCSimpleModelExporter >> beginMesh [
	baseVertex := vertexCount.
	baseIndex := indices size.
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> beginNode [
	transformStack add: currentTransform.
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> beginScene [
]

{ #category : #accessing }
WDCSimpleModelExporter >> beginSubmesh [
	baseIndexStack add: baseIndex.
	currentSubmesh := WDCSimpleModelExporterSubmesh new.
	submeshes add: currentSubmesh.
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> beginVertex [
]

{ #category : #accessing }
WDCSimpleModelExporter >> color: color [
	colors add: color
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> endLight [
	"Ignored"
]

{ #category : #accessing }
WDCSimpleModelExporter >> endMesh [
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> endNode [
	currentTransform := transformStack last.
	currentInverseTransposed := currentTransform inverseMatrix transpose.
	transformStack removeLast.
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> endScene [
]

{ #category : #accessing }
WDCSimpleModelExporter >> endSubmesh [
	baseIndex := baseIndexStack last.
	baseIndexStack removeLast
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> endVertex [
	positions size to: vertexCount do: [ :i |
		positions add: Float32x3 zeros
	].

	colors ifNotEmpty: [ 
		colors size to: vertexCount do: [ :i |
			colors add: Float32x4 ones
		].
	].

	normals ifNotEmpty: [ 
		normals size to: vertexCount do: [ :i |
			normals add: (Float32x3 z: 1.0)
		].
	].

	tangents4 ifNotEmpty: [ 
		tangents4 size to: vertexCount do: [ :i |
			tangents4 add: (Float32x4 x: 1.0 y: 0.0 z: 0.0 w: 1.0)
		].
	].

	boneIndices ifNotEmpty: [ 
		boneIndices size to: vertexCount do: [ :i |
			boneIndices add: UInt32x4 zeros
		].
	].

	boneWeights ifNotEmpty: [ 
		boneWeights size to: vertexCount do: [ :i |
			boneWeights add: (Float32x4 x: 1.0)
		].
	].
	vertexCount := vertexCount + 1.
]

{ #category : #accessing }
WDCSimpleModelExporter >> firstIndex: firstIndex [
	currentSubmesh firstIndex: firstIndex + baseIndex
]

{ #category : #accessing }
WDCSimpleModelExporter >> index: anIndex [
	indices add: anIndex + baseVertex
]

{ #category : #accessing }
WDCSimpleModelExporter >> indexCount: indexCount [
	currentSubmesh indexCount: indexCount
]

{ #category : #accessing }
WDCSimpleModelExporter >> indices: aListOfIndices [
	baseIndex := indices size.
	^ super indices: aListOfIndices
]

{ #category : #initialization }
WDCSimpleModelExporter >> initialize [
	super initialize.
	currentTransform := ReversibleAffineTransform3dF32 identity.
	transformStack := OrderedCollection new.
	positions := OrderedCollection new.
	colors := OrderedCollection new.
	texcoords := OrderedCollection new.
	normals := OrderedCollection new.
	tangents4 := OrderedCollection new.
	boneIndices := OrderedCollection new.
	boneWeights := OrderedCollection new.
	indices := OrderedCollection new.
	submeshes := OrderedCollection new.
	baseVertex := 0.
	baseIndex := 0.
	baseIndexStack := OrderedCollection new.
	vertexCount := 0.
]

{ #category : #accessing }
WDCSimpleModelExporter >> normal: normal [
	normals add: (currentInverseTransposed transpose * normal) normalized
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> parentTransform [
	^ transformStack
		ifEmpty: [ ReversibleAffineTransform3dF32 identity ]
		ifNotEmpty: [ transformStack last ]
]

{ #category : #accessing }
WDCSimpleModelExporter >> position: position [
	positions add: (currentTransform transformPosition: position)
]

{ #category : #accessing }
WDCSimpleModelExporter >> primitiveType: primitiveType [
	currentSubmesh primitiveType: (AgpuPrimitiveTypeMap at: primitiveType)
]

{ #category : #accessing }
WDCSimpleModelExporter >> renderable: aRenderable [
	^ aRenderable exportModelWith: self
]

{ #category : #accessing }
WDCSimpleModelExporter >> scaleFactor: scaleFactor [
	currentTransform scaleBy: scaleFactor
]

{ #category : #accessing }
WDCSimpleModelExporter >> tangent4: tangent4 [
	tangents4 add: (Float32x4 xyz: ((currentInverseTransposed * tangent4 xyz) normalized) w: tangent4 w)
]

{ #category : #accessing }
WDCSimpleModelExporter >> texcoord: texcoord [
	texcoords add: texcoord
]

{ #category : #'as yet unclassified' }
WDCSimpleModelExporter >> transform: newTransform [
	currentTransform := self parentTransform transformTransform: newTransform.
	currentInverseTransposed := currentTransform inverseMatrix transpose.
]

{ #category : #accessing }
WDCSimpleModelExporter >> vertexBoneIndices: vertexBoneIndices [
	boneIndices add: vertexBoneIndices
]

{ #category : #accessing }
WDCSimpleModelExporter >> vertexBoneWeights: vertexBoneWeights [
	boneWeights add: vertexBoneWeights
]

{ #category : #accessing }
WDCSimpleModelExporter >> visible: aBoolean [
]
