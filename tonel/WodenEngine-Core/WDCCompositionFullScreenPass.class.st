Class {
	#name : #WDCCompositionFullScreenPass,
	#superclass : #WDCAbstractFullScreenPass,
	#instVars : [
		'shaderSignature',
		'sourceBindings',
		'destinationTexture',
		'destinationRenderTarget',
		'fragmentShader'
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
WDCCompositionFullScreenPass >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := WDCCompositionShaderSignature for: engine ]
]

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> sourceBindings [
	^ sourceBindings ifNil: [ sourceBindings := self shaderSignature newSources ]
]

{ #category : #'as yet unclassified' }
WDCCompositionFullScreenPass >> sourceTexture: aSourceTexture [
	self sourceBindings
		bind: 0 texture: aSourceTexture
]
