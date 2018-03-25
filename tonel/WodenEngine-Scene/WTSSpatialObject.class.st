"
I am a node  that poses a local coordinate system that is associated with a model matrix in the GPU.
"
Class {
	#name : #WTSSpatialObject,
	#superclass : #WTSAbstractSpatialObject,
	#instVars : [
		'renderable',
		'objectStateBuffer',
		'objectStateBindings',
		'renderableSceneData',
		'gpuObjectStates',
		'blendingMode'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WTSSpatialObject >> blendingMode [
	^ blendingMode
]

{ #category : #accessing }
WTSSpatialObject >> blendingMode: anObject [
	blendingMode := anObject
]

{ #category : #testing }
WTSSpatialObject >> canBeRendered [
	^ true
]

{ #category : #rendering }
WTSSpatialObject >> createSceneDependentData [
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
WTSSpatialObject >> currentGpuObjectState [
	gpuObjectStates ifNil: [ self createSceneDependentData ].
	^ gpuObjectStates at: scene engine bufferingFrameIndex
]

{ #category : #rendering }
WTSSpatialObject >> currentObjectStateBinding [
	^ objectStateBindings at: scene engine bufferingFrameIndex.
]

{ #category : #initialization }
WTSSpatialObject >> initialize [
	super initialize.
	blendingMode := WDCBlendingMode replace.
]

{ #category : #rendering }
WTSSpatialObject >> performGpuStateUpdateWithCamera: aCamera [
	objectState transform: renderTransform.
	self currentGpuObjectState value: objectState.
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: scene engine bufferingFrameIndex into: renderableSceneData
	]
]

{ #category : #accessing }
WTSSpatialObject >> renderModificationCountFor: mode submode: submode [
	^ modificationCount + (renderable ifNil: [ 0 ] ifNotNil: [ renderable renderModificationCountFor: mode submode: submode ])
]

{ #category : #rendering }
WTSSpatialObject >> renderOn: stateTracker [
	renderable ifNil: [ ^ self ].
	
	stateTracker
		useShaderResources: self currentObjectStateBinding;
		objectBlendingMode: blendingMode.
		
	renderable renderOn: stateTracker instanceCount: 1 baseInstance: 0 baseVertex: 0
]

{ #category : #rendering }
WTSSpatialObject >> renderOn: commandList mode: renderMode submode: submode [
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: 1 baseInstance: 0 baseVertex: 0
]

{ #category : #accessing }
WTSSpatialObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WTSSpatialObject >> renderable: anObject [
	renderable := anObject.
	self increaseModificationCount.
]

{ #category : #accessing }
WTSSpatialObject >> renderableSceneData [
	^ renderableSceneData
]
