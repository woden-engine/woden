Class {
	#name : #WDASceneViewStereoDisplayMode,
	#superclass : #WDASceneViewScreenDisplayMode,
	#instVars : [
		'leftRenderTarget',
		'leftResolveRenderTarget',
		'rightResolveRenderTarget',
		'rightRenderTarget',
		'leftProjectionMatrix',
		'rightProjectionMatrix',
		'leftEyeFrustum',
		'rightEyeFrustum',
		'fragmentShader'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'render targets' }
WDASceneViewStereoDisplayMode >> checkRenderTargets [
	| leftRequiredExtent leftExtentChanged rightRequiredExtent rightExtentChanged |
	(leftRenderTarget isNil or: [ rightRenderTarget isNil ]) ifTrue: [ 
		self
			createRenderTargets;
			renderTargetExtentChanged
	] ifFalse: [ 
		leftRequiredExtent := self leftRenderTargetRequiredExtent.
		leftExtentChanged := leftRequiredExtent ~= leftRenderTarget extent.
	
		rightRequiredExtent := self rightRenderTargetRequiredExtent.
		rightExtentChanged := rightRequiredExtent ~= rightRenderTarget extent.
	
		(leftExtentChanged or: [ rightExtentChanged ]) ifTrue: [ 
			self renderTargetExtentChanged
		].
	]
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> computeProjectionMatrices [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> createRenderTargets [
	| leftExtent rightExtent sampleCount hasDepth hasStencil |
	leftExtent := self leftRenderTargetRequiredExtent.
	rightExtent := self rightRenderTargetRequiredExtent.
	
	sampleCount := view sampleCount.
	hasDepth := view hasDepth.
	hasStencil := view hasStencil.
	
	leftRenderTarget := WDCRenderTarget for: engine extent: leftExtent.
	leftRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.

	rightRenderTarget := WDCRenderTarget for: engine extent: rightExtent.
	rightRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.
		
	sampleCount > 1 ifTrue: [ 
		leftResolveRenderTarget := WDCRenderTarget for: engine extent: leftExtent.
		leftResolveRenderTarget
			hasDepth: hasDepth;
			hasStencil: hasStencil;
			sampleCount: 1;
			createFramebuffers.

		rightResolveRenderTarget := WDCRenderTarget for: engine extent: rightExtent.
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
WDASceneViewStereoDisplayMode >> fragmentShader [
	^ fragmentShader ifNil: [ fragmentShader := (engine loadShaderLibrary: 'shaders/composition/stereo.dastrel')
			getFragmentStage: self fragmentShaderName ]
]

{ #category : #'viewport composition' }
WDASceneViewStereoDisplayMode >> fragmentShaderName [
	^ #leftEye
]

{ #category : #testing }
WDASceneViewStereoDisplayMode >> isMultiEyeView [
	^ true
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> leftEyeCameraTransformFunction [
	^ [ :ct | ct transformTransform: self leftEyeTransform ]
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> leftEyeTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #'render targets' }
WDASceneViewStereoDisplayMode >> leftRenderTargetRequiredExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> leftViewportForCamera: camera [
	| cameraState |
	cameraState := WDCCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix;
		inverseProjectionMatrix: leftProjectionMatrix inverted.
	camera storeGlobalStatesForGPUIn: cameraState.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		sampleCount: view sampleCount;
		bounds: leftRenderTarget bounds;
		overlayRenderer: view;
		cameraTransformFunction: self leftEyeCameraTransformFunction;
		submode: #full
]

{ #category : #'rendering process stages' }
WDASceneViewStereoDisplayMode >> prepareDisplayMode [
	self
		checkRenderTargets;
		computeProjectionMatrices;
		updateCameraFrustum
]

{ #category : #'rendering process stages' }
WDASceneViewStereoDisplayMode >> prepareSceneRenderer [
	view sceneRenderer
		useLateLatching: self useLateLatching;
		currentTime: view model currentTime;
		beginPreparingRendering;
		prepareRenderingForCamera: view cameraSceneNode withViewports: {
			self leftViewportForCamera: view cameraSceneNode.
			self rightViewportForCamera: view cameraSceneNode.
		};
		endPreparingRendering 
]

{ #category : #'render targets' }
WDASceneViewStereoDisplayMode >> renderTargetExtentChanged [
	"Here goes settings that depend on the render target size."
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> rightEyeCameraTransformFunction [
	^ [ :ct | ct transformTransform: self rightEyeTransform ]
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> rightEyeTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #'render targets' }
WDASceneViewStereoDisplayMode >> rightRenderTargetRequiredExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDASceneViewStereoDisplayMode >> rightViewportForCamera: camera [
	| cameraState |
	cameraState := WDCCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix;
		inverseProjectionMatrix: rightProjectionMatrix inverted.
	camera storeGlobalStatesForGPUIn: cameraState.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		sampleCount: view sampleCount;
		bounds: rightRenderTarget bounds;
		overlayRenderer: view;
		cameraTransformFunction: self rightEyeCameraTransformFunction;
		submode: #full
]

{ #category : #'rendering process stages' }
WDASceneViewStereoDisplayMode >> updateCameraFrustum [
	| localLeftEyeFrustum localRightEyeFrustum left_leftBottomNear right_leftBottomNear left bottom near left_rightTopNear right_rightTopNear right top far combinedFrustum invertedY camera |
	localLeftEyeFrustum := leftEyeFrustum transformedWith: self leftEyeTransform.
	localRightEyeFrustum := rightEyeFrustum transformedWith: self rightEyeTransform.
	
	left_leftBottomNear := localLeftEyeFrustum leftBottomNear.
	right_leftBottomNear := localRightEyeFrustum leftBottomNear.
	
	left := left_leftBottomNear x min: right_leftBottomNear x.
	bottom := left_leftBottomNear y min: right_leftBottomNear y.

	left_rightTopNear := localLeftEyeFrustum rightTopNear.
	right_rightTopNear := localRightEyeFrustum rightTopNear.

	right := left_rightTopNear x max: right_rightTopNear x.
	top := left_rightTopNear y max: right_rightTopNear y.

	camera := view cameraSceneNode.
	near := camera nearDistance.
	far := camera farDistance.
	
	invertedY := engine projectionInvertedY.
	combinedFrustum := WMFrustumF new
		reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY.
	"Transcript show: left; space; show: right; space; show: bottom; space; show: top; space; show: near; space; show: far; cr."
	camera setExplicitFrustum: combinedFrustum invertedY: invertedY.
]
