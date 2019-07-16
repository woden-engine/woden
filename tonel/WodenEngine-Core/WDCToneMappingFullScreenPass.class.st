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
		'toneMappingOperator',
		'sceneLuminanceTexture'
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
WDCToneMappingFullScreenPass >> autoLuminanceFilterComputeShader [
	^ self shaderLibrary getComputeStage: #autoLuminanceFilter
]

{ #category : #'as yet unclassified' }
WDCToneMappingFullScreenPass >> computeAutoExposureWith: stateTracker [
	stateTracker
		useComputeShaderResources: self toneMappingTextureBindings;
		computeShader: self autoLuminanceFilterComputeShader;
		dispatchComputeGroupCount: 1;
		memoryBarrier: AGPU_PIPELINE_STAGE_COMPUTE_SHADER
			dest_stage: AGPU_PIPELINE_STAGE_FRAGMENT_SHADER
			source_accesses: AGPU_ACCESS_SHADER_WRITE dest_accesses: AGPU_ACCESS_SHADER_READ

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
WDCToneMappingFullScreenPass >> sceneHDRColorTexture: anObject [
	sceneHDRColorTexture := anObject.
	self toneMappingTextureBindings
		bind: 2 texture: sceneHDRColorTexture.
]

{ #category : #accessing }
WDCToneMappingFullScreenPass >> sceneLuminanceTexture: anObject [
	sceneLuminanceTexture := anObject.
	self toneMappingTextureBindings
		bind: 3 texture: sceneLuminanceTexture.
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
