Class {
	#name : #WDCCompositionFullScreenPass,
	#superclass : #WDCAbstractFullScreenPass,
	#instVars : [
		'shaderSignature',
		'sourceBindings',
		'destinationTexture',
		'destinationRenderTarget',
		'fragmentShader',
		'parametersBindings'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> applyWithStateTracker: stateTracker [
	stateTracker
		beginRenderPass: destinationRenderTarget validMainRenderPass renderTarget: destinationRenderTarget;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		useShaderResources: self sourceBindings;
		useShaderResources: parametersBindings;
		vertexShader: self vertexShader;
		fragmentShader: fragmentShader;
		dispatchScreenQuadRender;
		endRenderPass

]

{ #category : #accessing }
WDCCompositionFullScreenPass >> destinationRenderTarget: aRenderTarget [
	destinationRenderTarget := aRenderTarget
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> destinationTexture [
	^ destinationTexture
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> destinationTexture: anObject [
	destinationTexture := anObject.
	destinationRenderTarget := WDCRenderTarget for: engine colorAttachments: { destinationTexture }
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> fragmentShader [
	^ fragmentShader
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> fragmentShader: anObject [
	fragmentShader := anObject
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> parametersBindings [
	^ parametersBindings ifNil: [parametersBindings := self shaderSignature newParameters]
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> parametersUniformBuffer: uniformBuffer [
	self parametersBindings
		bind: 0 uniformBuffer: uniformBuffer
]

{ #category : #accessing }
WDCCompositionFullScreenPass >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := WDCCompositionShaderSignature for: engine ]
]

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> sourceBindings [
	^ sourceBindings ifNil: [ sourceBindings := self shaderSignature newSources ]
]

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> sourceDataStorageBuffer: aSourceBuffer [
	self sourceBindings
		bind: 5 storageBuffer: aSourceBuffer
]

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> sourceTexture: aSourceTexture [
	self sourceBindings
		bind: 0 texture: aSourceTexture
]
