Class {
	#name : #WDASceneViewStereoScreenDisplayMode,
	#superclass : #WDASceneViewStereoDisplayMode,
	#instVars : [
		'ipd',
		'focalDistance',
		'shaderSignature',
		'sourceRenderTargetsBinding',
		'compositionStateBinding',
		'compositionStateBuffer',
		'compositionState'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'instance creation' }
WDASceneViewStereoScreenDisplayMode >> checkRenderTargets [
	| mainTarget extent extentChanged |
	view window validRenderTarget ifNil: [ ^ self ].
	leftRenderTarget ifNil: [ 
		self createRenderTargets.
	].

	mainTarget := view window resolveRenderTarget.
	extent := mainTarget extent.

	extentChanged := extent ~= leftRenderTarget extent.
	extentChanged ifTrue: [ 
		leftRenderTarget extent: extent.
		leftResolveRenderTarget ~~ leftRenderTarget ifTrue: [ leftResolveRenderTarget extent: extent].
		rightRenderTarget extent: extent.
		rightResolveRenderTarget ~~ rightRenderTarget ifTrue: [ rightResolveRenderTarget extent: extent].
	].

	(sourceRenderTargetsBinding isNil or: [ extentChanged ]) ifTrue: [ 
		sourceRenderTargetsBinding ifNil: [
			sourceRenderTargetsBinding := self shaderSignature newSources
		].
		sourceRenderTargetsBinding
			bind: 0 renderTargetTexture: leftResolveRenderTarget;
			bind: 1 renderTargetTexture: rightResolveRenderTarget.
	]

]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> composeEyesIn: stateTracker [
	| resolveTarget renderPass |
	resolveTarget := view window resolveRenderTarget.

	renderPass := resolveTarget validMainRenderPass.

	stateTracker reset;
		shaderSignature: self shaderSignature;
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;
		blendingAllMode: WDCBlendingMode alphaOver; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: engine resourceCache screenQuadVertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self shaderSignature defaultSamplers;
		dispatchScreenQuadRender;
		endRenderPass
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> computeProjectionMatrices [
	| camera near far fovy fovyRad top ipd2 aspect focalWidth focalDistanceFactor invertedY extent |
	self flag: 'TODO: Support the orthographic projections.'.
	camera := view cameraSceneNode.
	extent := view window drawingSurfaceExtent.
	aspect := extent x asFloat / extent y asFloat.
	invertedY := engine projectionInvertedY.
	
	near := camera nearDistance.
	far := camera farDistance.
	fovy := camera fieldOfView.
	
	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	
	ipd2 := ipd * 0.5.
	focalWidth := aspect * focalDistance * fovyRad tan.
 	focalDistanceFactor := near / focalDistance.
	
	leftEyeFrustum := FrustumF32 new
		reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth - ipd2) negated
		right: focalDistanceFactor * (focalWidth + ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	leftProjectionMatrix := leftEyeFrustum matrix.

	rightEyeFrustum := FrustumF32 new
	 	reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth + ipd2) negated
		right: focalDistanceFactor * (focalWidth - ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	rightProjectionMatrix := rightEyeFrustum matrix.

]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> createCompositionStateBinding [
	compositionState := WDCCompositionState new.
	compositionStateBinding := self shaderSignature newParameters.
	self createCompositionStateBuffer
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> createCompositionStateBuffer [
	compositionStateBuffer := engine createStreamingUniformBuffer: WDCCompositionState instanceSize.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.
]

{ #category : #initialization }
WDASceneViewStereoScreenDisplayMode >> initialize [
	super initialize.
	ipd := 0.065.
	focalDistance := 1.0.
	
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> leftEyeTransform [
	^ ReversibleAffineTransform3dF32 identity
			translateByX: ipd * -0.5
]

{ #category : #'render targets' }
WDASceneViewStereoScreenDisplayMode >> leftRenderTargetRequiredExtent [
	^ view window drawingSurfaceExtent
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> prepareDisplayMode [
	super prepareDisplayMode.
	self
		updateCompositionState;
		uploadCompositionState.
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> renderSceneViewports [
	^ view sceneRenderer renderSceneViewportsThenDo: [ :stateTracker |
		self composeEyesIn: stateTracker
	]
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> rightEyeTransform [
	^ ReversibleAffineTransform3dF32 identity
			translateByX: ipd * 0.5
]

{ #category : #'render targets' }
WDASceneViewStereoScreenDisplayMode >> rightRenderTargetRequiredExtent [
	^ view window drawingSurfaceExtent
]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := WDCCompositionShaderSignature for: engine ]
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> updateCompositionState [
	| extent |
	compositionStateBinding ifNil: [ self createCompositionStateBinding ].
	
	extent := view window drawingSurfaceExtent asFloat32x2.
	compositionState screenExtents: (Float32x4 xy: extent zw: 1.0 / extent)
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> uploadCompositionState [
	compositionState storeBytesIn: compositionStateBuffer validPointer getHandle position: 1.
]
