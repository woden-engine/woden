Class {
	#name : #WDCObjectStateTracker,
	#superclass : #WDCStateTracker,
	#instVars : [
		'activeMaterial',
		'objectBlendingMode',
		'materialBlendingMode',
		'materialCullMode',
		'objectCullMode',
		'objectPolygonMode',
		'materialPolygonMode',
		'objectDepthEnabled',
		'objectDepthWriteMask',
		'objectDepthFunction',
		'materialDepthEnabled',
		'materialDepthWriteMask',
		'materialDepthFunction'
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
	]

]

{ #category : #private }
WDCObjectStateTracker >> applyCullMode [
	materialCullMode ifNotNil: [
		^ self cullMode: materialCullMode.
	].

	objectCullMode ifNotNil: [
		^ self cullMode: objectCullMode.
	]

]

{ #category : #private }
WDCObjectStateTracker >> applyDepthEnabled [
	materialDepthEnabled ifNotNil: [
		^ self depthEnabled: materialDepthEnabled.
	].

	objectDepthEnabled ifNotNil: [
		^ self depthEnabled: objectDepthEnabled.
	]

]

{ #category : #private }
WDCObjectStateTracker >> applyDepthFunction [
	materialDepthFunction ifNotNil: [
		^ self depthFunction: materialDepthFunction.
	].

	objectDepthFunction ifNotNil: [
		^ self depthFunction: objectDepthFunction.
	]

]

{ #category : #private }
WDCObjectStateTracker >> applyDepthWriteMask [
	materialDepthWriteMask ifNotNil: [
		^ self depthWriteMask: materialDepthWriteMask.
	].

	objectDepthWriteMask ifNotNil: [
		^ self depthWriteMask: objectDepthWriteMask.
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
]
