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
		'materialPolygonMode'
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
		materialPolygonMode: nil.
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
]
