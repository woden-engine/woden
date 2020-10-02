Class {
	#name : #WDASceneViewWithBabylon,
	#superclass : #WDASceneView,
	#instVars : [
		'hasRenderedOverlayTargets',
		'babylonOverlay',
		'babylonOverlaySpatialObject'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #rendering }
WDASceneViewWithBabylon >> babylonDefaultFont [
	^ babylonOverlay defaultFont
]

{ #category : #accessing }
WDASceneViewWithBabylon >> babylonOverlaySpatialObject [
	babylonOverlaySpatialObject ifNil: [
		babylonOverlaySpatialObject := WDCSpatialObject new engine: engine
	].
	^ babylonOverlaySpatialObject
]

{ #category : #rendering }
WDASceneViewWithBabylon >> constructRenderingCommandLists [
	hasRenderedOverlayTargets := false.
	^ super constructRenderingCommandLists
]

{ #category : #'drawing 2d' }
WDASceneViewWithBabylon >> drawFrameRateOn: canvas [
	| deltaTime builder mesh |
	deltaTime := engine frameBufferingDriver currentFrameCPUDeltaTime.
	
	builder := canvas driver mesh2DBuilder.
	builder text
		color: Color green;
		font: self babylonDefaultFont;
			position: (0 @ self babylonDefaultFont getPreciseAscent);
			draw: ('CPU Frame Rate {1} ms / {2} FPS' format: {
				(deltaTime*1000.0) printShowingDecimalPlaces: 3 .
				1.0 / (deltaTime max: 0.01) printShowingDecimalPlaces: 3.
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3});
			newline;
			draw: ('CPU Consumption {1} ms' format: {
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3});
			newline;
			draw: ('Rendered object count {1}' format: {engine frameRenderingMetrics renderedObjectCount asString}).
				
	mesh := builder mesh.
	
	canvas draw: mesh.
]

{ #category : #rendering }
WDASceneViewWithBabylon >> drawOnBabylonCanvas: canvas [
]

{ #category : #rendering }
WDASceneViewWithBabylon >> drawOnScaledBabylonCanvas: canvas [
	WDCEngine displayFrameRate ifTrue: [ 
		self drawFrameRateOn: canvas
	].

]

{ #category : #rendering }
WDASceneViewWithBabylon >> renderViewport: viewport overlayRenderTargetWith: stateTracker [
	hasRenderedOverlayTargets ifTrue: [ ^ self ].

	self validBabylonSurface withStateTracker: stateTracker drawDuring: [ :canvas |
		canvas clear.
		
		canvas transform restoreAfter: [
			babylonOverlay applyLogicalHeightTransformTo: canvas.
			self drawOnScaledBabylonCanvas: canvas.
			sceneRenderer ifNotNil: [ sceneRenderer debugDrawOnBabylonCanvas: canvas ]
		].
		self drawOnBabylonCanvas: canvas.
	].
	hasRenderedOverlayTargets := true.

	self isMultiEyeView ifTrue: [ 
		| extent aspectRatio overlayHeight overlayDistance |
		extent := self drawingSurfaceExtent.
		aspectRatio := extent x asFloat / extent y asFloat.
		overlayHeight := 0.1.
		overlayDistance := 0.2.
		self babylonOverlaySpatialObject
			transform: (ReversibleAffineTransform3dF32 identity
				scaleByX: aspectRatio * overlayHeight y: overlayHeight z: 1.0;
				translateByZ: overlayDistance negated)
	] ifFalse: [
		self babylonOverlaySpatialObject
			transform: (ReversibleAffineTransform3dF32 identity)
	].

	babylonOverlaySpatialObject
			updateCommonGpuStateForFrame: engine frameBufferingDriver frameIndex

]

{ #category : #rendering }
WDASceneViewWithBabylon >> renderViewport: viewport overlayWith: stateTracker [
	babylonOverlay ifNil: [ ^ self ].
	self isMultiEyeView ifFalse: [ 
		stateTracker useShaderResources: engine resourceCache screenQuadCameraStateBinding.
	].
	self babylonOverlaySpatialObject renderRenderable: babylonOverlay with: stateTracker
]

{ #category : #'as yet unclassified' }
WDASceneViewWithBabylon >> validBabylonOverlay [
	babylonOverlay ifNil: [ babylonOverlay := WDCBabylonOverlay for: engine ].
	babylonOverlay drawingSurfaceExtent: self drawingSurfaceExtent.
	^ babylonOverlay 
]

{ #category : #'as yet unclassified' }
WDASceneViewWithBabylon >> validBabylonSurface [
	^ self validBabylonOverlay
		drawingSurfaceExtent: self drawingSurfaceExtent;
		validSurface
]
