Class {
	#name : #WDCAmbientOcclusionComputationFullScreenPass,
	#superclass : #WDCAbstractFullScreenPass,
	#instVars : [
		'depthStencilTexture',
		'destinationRenderTarget',
		'shaderSignature',
		'computeSourceBindings',
		'surfaceNormalTexture',
		'fragmentShader'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCAmbientOcclusionComputationFullScreenPass >> applyWithStateTracker: stateTracker [
	stateTracker
		beginRenderPass: destinationRenderTarget validMainRenderPass renderTarget: destinationRenderTarget;
		useShaderResources: self computeSourceBindings;
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		dispatchScreenQuadRender;
		endRenderPass.
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> computeSourceBindings [
	^ computeSourceBindings ifNil: [computeSourceBindings := self shaderSignature newComputeSources]
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> depthStencilTexture [
	^ depthStencilTexture
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> depthStencilTexture: aTexture [
	depthStencilTexture := aTexture.
	self computeSourceBindings
		bind: 0 texture: aTexture
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> destinationRenderTarget [
	^ destinationRenderTarget
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> destinationRenderTarget: anObject [
	destinationRenderTarget := anObject
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> fragmentShader [
	^ fragmentShader ifNil: [ fragmentShader := (engine resourceCache loadShaderLibrary: 'shaders/lighting/ambientOcclusionFragment.dastrel')
		getFragmentStage: #ssao]
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := WDCAmbientOcclusionShaderSignature for: engine ]
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> surfaceNormalTexture [
	^ surfaceNormalTexture
]

{ #category : #accessing }
WDCAmbientOcclusionComputationFullScreenPass >> surfaceNormalTexture: aTexture [
	surfaceNormalTexture := aTexture.
	self computeSourceBindings
		bind: 1 texture: aTexture
]
