Class {
	#name : #WDASceneViewStereoScreenDisplayMode,
	#superclass : #WDASceneViewStereoDisplayMode,
	#instVars : [
		'ipd',
		'focalDistance',
		'shaderSignature',
		'vertexShader',
		'fragmentShader',
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
	leftRenderTarget ifNil: [ 
		self createRenderTargets.
	].

	mainTarget := view window validResolveRenderTarget.
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
			sourceRenderTargetsBinding := self shaderSignature newSource
		].
		sourceRenderTargetsBinding
			bind: 0 renderTarget: leftResolveRenderTarget startMiplevel: 0 miplevels: -1 lodclamp: 100000.0;
			bind: 1 renderTarget: rightResolveRenderTarget startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	]

]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> composeEyesIn: stateTracker [
	| resolveTarget renderPass |
	resolveTarget := view window validResolveRenderTarget.

	renderPass := resolveTarget validMainRenderPass.

	stateTracker reset;
		shaderSignature: self shaderSignature;
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;
		blendingAllMode: WDCBlendingMode alphaOver; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self shaderSignature defaultSamplers;
		primitiveType: AGPU_TRIANGLE_STRIP;
		drawArrays: 4 instance_count: 1 first_vertex: 0 base_instance: 0;
		
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
	
	leftProjectionMatrix := WMMatrix4F
		reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth - ipd2) negated
		right: focalDistanceFactor * (focalWidth + ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	rightProjectionMatrix := WMMatrix4F
	 	reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth + ipd2) negated
		right: focalDistanceFactor * (focalWidth - ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.

]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> createCompositionStateBinding [
	compositionState := WTCompositionState new.
	compositionStateBinding := self shaderSignature newParameters.
	self createCompositionStateBuffer
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> createCompositionStateBuffer [
	compositionStateBuffer := engine createStreamingUniformBuffer: WTCompositionState structureSize.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.
]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> fragmentShader [
	^ fragmentShader ifNil: [ fragmentShader := engine loadFragmentShader: self fragmentShaderFileName ]
]

{ #category : #initialization }
WDASceneViewStereoScreenDisplayMode >> initialize [
	super initialize.
	ipd := 0.065.
	focalDistance := 1.0.
	
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> leftEyeTransform [
	^ WMReversibleAffineTransformF identity
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
	^ WMReversibleAffineTransformF identity
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
	
	extent := view window drawingSurfaceExtent.
	compositionState screenExtents: (WMVector4F x: extent x asFloat y: extent y asFloat z: extent x reciprocalFloatQuiet w: extent y reciprocalFloatQuiet)
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> uploadCompositionState [
	compositionState storeBytesIn: compositionStateBuffer validPointer getHandle position: 1.
]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> vertexShader [
	^ vertexShader ifNil: [ vertexShader := engine loadVertexShader: self vertexShaderFileName ]
]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> vertexShaderFileName [
	^ 'shaders/composition/passthroughVertex.dastrel'
]
