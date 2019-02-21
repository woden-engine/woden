Class {
	#name : #WDASceneViewStereoScreenDisplayMode,
	#superclass : #WDASceneViewScreenDisplayMode,
	#instVars : [
		'ipd',
		'focalDistance',
		'leftRenderTarget',
		'leftResolveRenderTarget',
		'rightResolveRenderTarget',
		'rightRenderTarget',
		'shaderSignature',
		'vertexShader',
		'fragmentShader',
		'sourceRenderTargetsBinding',
		'compositionStateBinding',
		'compositionStateBuffer',
		'compositionState',
		'leftProjectionMatrix',
		'rightProjectionMatrix'
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
WDASceneViewStereoScreenDisplayMode >> constructRenderingCommandLists [
	| resolveTarget |
	self
		checkRenderTargets;
		updateCompositionState;
		uploadCompositionState;
		computeProjectionMatrices;
		updateCameraFrustum.
		
	resolveTarget := view window validResolveRenderTarget.
	^ view sceneRenderer
		useLateLatching: self useLateLatching;
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self leftViewportForCamera: view cameraSceneNode.
			self rightViewportForCamera: view cameraSceneNode.
		}
		composeWith: [ :stateTracker |
			self composeEyesIn: stateTracker
		]
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

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> createRenderTargets [
	| extent sampleCount hasDepth hasStencil |
	extent := view window drawingSurfaceExtent.
	sampleCount := view sampleCount.
	hasDepth := view hasDepth.
	hasStencil := view hasStencil.
	
	leftRenderTarget := WDCRenderTarget for: engine extent: extent.
	leftRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.

	rightRenderTarget := WDCRenderTarget for: engine extent: extent.
	rightRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.
		
	sampleCount > 1 ifTrue: [ 
		leftResolveRenderTarget := WDCRenderTarget for: engine extent: extent.
		leftResolveRenderTarget
			hasDepth: hasDepth;
			hasStencil: hasStencil;
			sampleCount: 1;
			createFramebuffers.

		rightResolveRenderTarget := WDCRenderTarget for: engine extent: extent.
		rightResolveRenderTarget
			hasDepth: hasDepth;
			hasStencil: hasStencil;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		leftResolveRenderTarget := leftRenderTarget.
		rightResolveRenderTarget := rightRenderTarget.
	].

]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> fragmentShader [
	^ fragmentShader ifNil: [ fragmentShader := engine loadFragmentShader: self fragmentShaderFileName ]
]

{ #category : #'viewport composition' }
WDASceneViewStereoScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/vrDistortion.dastrel'
]

{ #category : #initialization }
WDASceneViewStereoScreenDisplayMode >> initialize [
	super initialize.
	ipd := 0.065.
	focalDistance := 1.0.
	
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> leftCameraTransform [
	^ WMReversibleAffineTransformF identity
			translateByX: ipd * -0.5
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> leftViewportForCamera: camera [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		bounds: leftRenderTarget bounds;
		cameraTransformFunction: [ :ct | ct transformTransform: self leftCameraTransform ];
		submode: #full
]

{ #category : #'rendering process stages' }
WDASceneViewStereoScreenDisplayMode >> prepareRendering [
	self
		checkRenderTargets;
		updateCompositionState;
		uploadCompositionState;
		computeProjectionMatrices;
		updateCameraFrustum.
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> rightCameraTransform [
	^ WMReversibleAffineTransformF identity
			translateByX: ipd * 0.5
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoScreenDisplayMode >> rightViewportForCamera: camera [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		bounds: rightRenderTarget bounds;
		cameraTransformFunction: [ :ct | ct transformTransform: self rightCameraTransform ];
		submode: #full
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
