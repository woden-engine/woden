"
I am a node  that poses a local coordinate system that is associated with a model matrix in the GPU.
"
Class {
	#name : #WDSGSpatialObject,
	#superclass : #WDSGAbstractSpatialObject,
	#instVars : [
		'renderable',
		'objectStateBuffer',
		'objectStateBindings',
		'renderableSceneData',
		'gpuObjectStates',
		'blendingMode'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGSpatialObject >> blendingMode [
	^ blendingMode
]

{ #category : #accessing }
WDSGSpatialObject >> blendingMode: anObject [
	blendingMode := anObject
]

{ #category : #testing }
WDSGSpatialObject >> canBeRendered [
	^ true
]

{ #category : #rendering }
WDSGSpatialObject >> createSceneDependentData [
	| neutralInstanceState |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	gpuObjectStates := scene genericObjectStatePool allocate: scene engine frameBufferingCount.
	neutralInstanceState := scene neutralGenericObjectInstanceState.
	objectStateBindings := gpuObjectStates collect: [ :state |
		scene shaderSignature newObjectState
			bind: 0 uniformBufferElement: state;
			bind: 1 storageBufferElement: neutralInstanceState;
			yourself.
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].

]

{ #category : #rendering }
WDSGSpatialObject >> currentGpuObjectState [
	gpuObjectStates ifNil: [ self createSceneDependentData ].
	^ gpuObjectStates at: scene engine bufferingFrameIndex
]

{ #category : #rendering }
WDSGSpatialObject >> currentObjectStateBinding [
	^ objectStateBindings at: scene engine bufferingFrameIndex.
]

{ #category : #initialization }
WDSGSpatialObject >> initialize [
	super initialize.
	blendingMode := WDCBlendingMode replace.
]

{ #category : #rendering }
WDSGSpatialObject >> performGpuStateUpdateWithCamera: aCamera [
	objectState transform: renderTransform.
	self currentGpuObjectState value: objectState.
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: scene engine bufferingFrameIndex into: renderableSceneData
	]
]

{ #category : #accessing }
WDSGSpatialObject >> renderModificationCountFor: mode submode: submode [
	^ modificationCount + (renderable ifNil: [ 0 ] ifNotNil: [ renderable renderModificationCountFor: mode submode: submode ])
]

{ #category : #rendering }
WDSGSpatialObject >> renderOn: stateTracker [
	renderable ifNil: [ ^ self ].
	
	stateTracker
		useShaderResources: self currentObjectStateBinding;
		objectBlendingMode: blendingMode.
		
	renderable renderOn: stateTracker instanceCount: 1 baseInstance: 0 baseVertex: 0
]

{ #category : #rendering }
WDSGSpatialObject >> renderOn: commandList mode: renderMode submode: submode [
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: 1 baseInstance: 0 baseVertex: 0
]

{ #category : #accessing }
WDSGSpatialObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WDSGSpatialObject >> renderable: anObject [
	renderable := anObject.
	self increaseModificationCount.
]

{ #category : #accessing }
WDSGSpatialObject >> renderableSceneData [
	^ renderableSceneData
]
