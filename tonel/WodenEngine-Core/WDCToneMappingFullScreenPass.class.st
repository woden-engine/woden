Class {
	#name : #WDCToneMappingFullScreenPass,
	#superclass : #WDCAbstractFullScreenPass,
	#instVars : [
		'sceneHDRColorTexture',
		'computeSourceBindings',
		'fragmentShader',
		'toneMappingTextureBindings',
		'shaderSignature',
		'shaderLibrary',
		'toneMappingOperator'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCToneMappingFullScreenPass >> applyWithStateTracker: stateTracker [
	stateTracker
		useShaderResources: self toneMappingTextureBindings;
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		dispatchScreenQuadRender.
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> computeSourceBindings [
	^ computeSourceBindings
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> fragmentShader [
	^ self shaderLibrary getFragmentStage: toneMappingOperator
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> sceneHDRColorTexture [
	^ sceneHDRColorTexture
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> sceneHDRColorTexture1: anObject [
	sceneHDRColorTexture := anObject
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> sceneHDRColorTexture: anObject [
	sceneHDRColorTexture := anObject.
	self toneMappingTextureBindings
		bind: 2 texture: sceneHDRColorTexture.
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := (engine resourceCache loadShaderLibrary: 'shaders/rendering/toneMapping.dastrel')]
]

{ #category : #'as yet unclassified' }
WDCToneMappingFullScreenPass >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := WDCSceneRenderingShaderSignature for: engine ]
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> toneMappingOperator [
	^ toneMappingOperator
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> toneMappingOperator: anObject [
	toneMappingOperator := anObject
]

{ #category : #'as yet unclassified' }
WDCToneMappingFullScreenPass >> toneMappingTextureBindings [
	^ toneMappingTextureBindings ifNil: [ toneMappingTextureBindings := self shaderSignature newMaterialState ]
]
