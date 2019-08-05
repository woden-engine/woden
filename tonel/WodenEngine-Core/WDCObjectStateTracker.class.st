Class {
	#name : #WDCObjectStateTracker,
	#superclass : #WDCStateTracker,
	#instVars : [
		'activeVertexData',
		'activeMaterial',
		'objectBlendingMode',
		'materialBlendingMode',
		'materialCullMode',
		'objectCullMode',
		'sceneCullMode',
		'objectPolygonMode',
		'materialPolygonMode',
		'sceneDepthEnabled',
		'sceneDepthWriteMask',
		'sceneDepthFunction',
		'objectDepthEnabled',
		'objectDepthWriteMask',
		'objectDepthFunction',
		'materialDepthEnabled',
		'materialDepthWriteMask',
		'materialDepthFunction',
		'deformationState',
		'sceneBlendingMode'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #commands }
WDCObjectStateTracker >> activateMaterial: material [
	activeMaterial == material ifTrue: [ ^ true ].
	
	self
		materialBlendingMode: nil;
		materialCullMode: nil;
		materialPolygonMode: nil;
		materialDepthEnabled: nil;
		materialDepthWriteMask: nil;
		materialDepthFunction: nil.
	(material activateOn: self) ifTrue: [ 
		activeMaterial := material.
		^ true
	] ifFalse: [
		^ false
	]
	
]

{ #category : #private }
WDCObjectStateTracker >> applyBlendingModel [
	materialBlendingMode ifNotNil: [
		^ self blendingAllMode: materialBlendingMode.
	].

	objectBlendingMode ifNotNil: [
		^ self blendingAllMode: objectBlendingMode.
	].

	sceneBlendingMode ifNotNil: [ 
		^ self blendingAllMode: sceneBlendingMode.
	].

]

{ #category : #private }
WDCObjectStateTracker >> applyCullMode [
	materialCullMode ifNotNil: [
		^ self cullMode: materialCullMode.
	].

	objectCullMode ifNotNil: [
		^ self cullMode: objectCullMode.
	].

	sceneCullMode ifNotNil: [
		^ self cullMode: sceneCullMode.
	]
]

{ #category : #private }
WDCObjectStateTracker >> applyDepthEnabled [
	materialDepthEnabled ifNotNil: [
		^ self depthEnabled: materialDepthEnabled.
	].

	objectDepthEnabled ifNotNil: [
		^ self depthEnabled: objectDepthEnabled.
	].

	sceneDepthEnabled ifNotNil: [
		^ self depthEnabled: sceneDepthEnabled.
	]

]

{ #category : #private }
WDCObjectStateTracker >> applyDepthFunction [
	materialDepthFunction ifNotNil: [
		^ self depthFunction: materialDepthFunction.
	].

	objectDepthFunction ifNotNil: [
		^ self depthFunction: objectDepthFunction.
	].

	sceneDepthFunction ifNotNil: [
		^ self depthFunction: sceneDepthFunction.
	].
]

{ #category : #private }
WDCObjectStateTracker >> applyDepthWriteMask [
	materialDepthWriteMask ifNotNil: [
		^ self depthWriteMask: materialDepthWriteMask.
	].

	objectDepthWriteMask ifNotNil: [
		^ self depthWriteMask: objectDepthWriteMask.
	].

	sceneDepthWriteMask ifNotNil: [
		^ self depthWriteMask: sceneDepthWriteMask.
	]
]

{ #category : #private }
WDCObjectStateTracker >> applyPolygonMode [
	materialPolygonMode ifNotNil: [
		^ self polygonMode: materialPolygonMode.
	].

	objectPolygonMode ifNotNil: [
		^ self polygonMode: objectPolygonMode.
	]

]

{ #category : #commands }
WDCObjectStateTracker >> clearObjectRenderingStates [
	self
		objectDepthWriteMask: nil;
		objectDepthEnabled: nil;
		objectBlendingMode: nil
]

{ #category : #accessing }
WDCObjectStateTracker >> deformationState [
	^ deformationState
]

{ #category : #testing }
WDCObjectStateTracker >> hasSkinning [
	^ deformationState isNotNil and: [ deformationState isSkinningState ]
]

{ #category : #testing }
WDCObjectStateTracker >> hasTerrainDeformationState [
	^ deformationState isNotNil and: [ deformationState isTerrainDeformationState ]
]

{ #category : #testing }
WDCObjectStateTracker >> hasVertexColors [
	^ activeVertexData isNotNil and: [ activeVertexData hasVertexColors ]
]

{ #category : #testing }
WDCObjectStateTracker >> hasVertexTangents [
	^ activeVertexData isNotNil and: [ activeVertexData hasVertexTangents ]
]

{ #category : #testing }
WDCObjectStateTracker >> hasWaterDeformationState [
	^ deformationState isNotNil and: [ deformationState isWaterDeformationState ]
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialBlendingMode [
	^ materialBlendingMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialBlendingMode: anObject [
	materialBlendingMode := anObject.
	self applyBlendingModel
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialCullMode: anObject [
	materialCullMode := anObject.
	self applyCullMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthEnabled [
	^ materialDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthEnabled: anObject [
	materialDepthEnabled := anObject.
	self applyDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthFunction [
	^ materialDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthFunction: anObject [
	materialDepthFunction := anObject.
	self applyDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthWriteMask [
	^ materialDepthWriteMask
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialDepthWriteMask: anObject [
	materialDepthWriteMask := anObject.
	self applyDepthWriteMask
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> materialPolygonMode: anObject [
	materialPolygonMode := anObject.
	self applyPolygonMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectBlendingMode [
	^ objectBlendingMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectBlendingMode: anObject [
	objectBlendingMode := anObject.
	self applyBlendingModel
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectCullMode: anObject [
	objectCullMode := anObject.
	self applyCullMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthEnabled [
	^ objectDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthEnabled: anObject [
	objectDepthEnabled := anObject.
	self applyDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthFunction [
	^ objectDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthFunction: anObject [
	objectDepthFunction := anObject.
	self applyDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthWriteMask [
	^ objectDepthWriteMask
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectDepthWriteMask: anObject [
	objectDepthWriteMask := anObject.
	self applyDepthWriteMask
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> objectPolygonMode: anObject [
	objectPolygonMode := anObject.
	self applyPolygonMode
]

{ #category : #accessing }
WDCObjectStateTracker >> reset [
	super reset.
	activeMaterial := nil.
	activeVertexData := nil.

	objectBlendingMode := nil.
	objectCullMode := nil.
	objectPolygonMode := AGPU_POLYGON_MODE_FILL.
	materialBlendingMode := nil.
	materialCullMode := nil.
	materialPolygonMode := nil.
	objectDepthEnabled := nil.
	objectDepthWriteMask := nil.
	objectDepthFunction := nil.
	materialDepthEnabled := nil.
	materialDepthWriteMask := nil.
	materialDepthFunction := nil.
	deformationState := nil
]

{ #category : #accessing }
WDCObjectStateTracker >> sceneBlendingMode [
	^ sceneBlendingMode
]

{ #category : #accessing }
WDCObjectStateTracker >> sceneBlendingMode: anObject [
	sceneBlendingMode := anObject
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneCullMode: anObject [
	sceneCullMode := anObject.
	self applyCullMode
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneDepthEnabled [
	^ sceneDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneDepthEnabled: anObject [
	sceneDepthEnabled := anObject.
	self applyDepthEnabled
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneDepthFunction [
	^ sceneDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneDepthFunction: anObject [
	sceneDepthFunction := anObject.
	self applyDepthFunction
]

{ #category : #'per object per material states' }
WDCObjectStateTracker >> sceneDepthWriteMask: anObject [
	sceneDepthWriteMask := anObject.
	self applyDepthWriteMask
]

{ #category : #'as yet unclassified' }
WDCObjectStateTracker >> withDeformationState: newDeformationState do: aBlock [
	| oldActiveDeformationState |
	oldActiveDeformationState := deformationState.
	deformationState := newDeformationState.
	aBlock ensure: [
		deformationState := oldActiveDeformationState
	]
]

{ #category : #'as yet unclassified' }
WDCObjectStateTracker >> withVertexData: vertexData do: aBlock [
	| oldActiveVertexData |
	oldActiveVertexData := activeVertexData.
	activeVertexData := vertexData.
	^ aBlock ensure: [
		activeVertexData := oldActiveVertexData.
	]
]
