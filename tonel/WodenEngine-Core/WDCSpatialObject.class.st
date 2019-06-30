Class {
	#name : #WDCSpatialObject,
	#superclass : #WDCAbstractGPUSpatialObject,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #accessing }
WDCSpatialObject >> createEngineDependantData [
	| shaderSignature |
	gpuObjectStates ifNotNil: [ ^ self ].
	self assert: engine isNotNil.
	
	gpuObjectStates := engine resourceCache genericObjectStatePool allocate: engine frameBufferingCount.
	shaderSignature := WDCSceneRenderingShaderSignature for: engine. 
	objectStateBindings := gpuObjectStates collect: [ :stateBufferElement |
		shaderSignature newObjectState
			bind: 0 uniformBufferElement: stateBufferElement;
			bind: 1 storageBufferElement: engine resourceCache neutralGenericObjectInstanceState;
			yourself.
	].

]

{ #category : #rendering }
WDCSpatialObject >> renderRenderable: renderable with: stateTracker [
	stateTracker
		useShaderResources: self currentObjectStateBinding.
		
	renderable
		renderOn: stateTracker instanceCount: 1 baseInstance: 0 baseVertex: 0
]

{ #category : #'as yet unclassified' }
WDCSpatialObject >> updateCommonGpuStateForFrame: frameIndex [
	self currentGpuObjectState value: state
]
