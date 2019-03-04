Class {
	#name : #WDASceneViewStereoDisplayMode,
	#superclass : #WDASceneViewScreenDisplayMode,
	#instVars : [
		'leftRenderTarget',
		'leftResolveRenderTarget',
		'rightResolveRenderTarget',
		'rightRenderTarget',
		'leftProjectionMatrix',
		'rightProjectionMatrix'
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
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix;
		inverseProjectionMatrix: leftProjectionMatrix inverted.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		sampleCount: view sampleCount;
		bounds: leftRenderTarget bounds;
		overlayRenderer: view;
		cameraTransformFunction: [ :ct | ct transformTransform: self leftEyeTransform ];
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
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix;
		inverseProjectionMatrix: rightProjectionMatrix inverted.
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		sampleCount: view sampleCount;
		bounds: rightRenderTarget bounds;
		overlayRenderer: view;
		cameraTransformFunction: [ :ct | ct transformTransform: self rightEyeTransform ];
		submode: #full
]
