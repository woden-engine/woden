Class {
	#name : #WDSSceneRenderer,
	#superclass : #Object,
	#instVars : [
		'stateTracker',
		'engine',
		'shaderSignature',
		'cameraStates',
		'mainCamera',
		'currentTime',
		'useLateLatching',
		'currentCameraViewports',
		'directCommandLists',
		'renderingViewports',
		'intermediateRenderTargets',
		'perCameraRenderingViewports'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'instance creation' }
WDSSceneRenderer class >> for: aWDCEngine [
	^ self new initializeWithEngine: aWDCEngine
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> beginPreparingRendering [
	renderingViewports removeAll.
	perCameraRenderingViewports removeAll.
]

{ #category : #initialization }
WDSSceneRenderer >> cameraStateFramebufferingCount [
	^ useLateLatching ifTrue: [ 1 ] ifFalse: [ engine frameBufferingCount ]
]

{ #category : #accessing }
WDSSceneRenderer >> currentTime [
	^ currentTime
]

{ #category : #accessing }
WDSSceneRenderer >> currentTime: anObject [
	currentTime := anObject
]

{ #category : #debugging }
WDSSceneRenderer >> debugDrawOnBabylonCanvas: canvas [
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> endPreparingRendering [
	self setupRenderingViewportsIntermediateRenderTargets.
	self updateGPUStatesForRenderingViewports.
]

{ #category : #initialization }
WDSSceneRenderer >> ensureCameraStatesFor: requiredNumberOfCameras [
	| currentNumberOfCameras missingNumberOfCameras postProcessingStates postProcessingStatePool |
	cameraStates ifNil: [ 
		cameraStates := (1 to: self cameraStateFramebufferingCount) collect: [ :f | #() ].
	].
	
	currentNumberOfCameras := cameraStates first size.
	missingNumberOfCameras := requiredNumberOfCameras - currentNumberOfCameras.
	
	missingNumberOfCameras > 0 ifTrue: [
		postProcessingStatePool := engine resourceCache streamingStorageBufferPoolFor: WTCameraPostProcessingState.
		postProcessingStates := (1 to: missingNumberOfCameras) collect: [ :i |
			postProcessingStatePool allocate.
		].
	
		cameraStates := cameraStates collect: [ :oldFrameStates |
			oldFrameStates , ((1 to: missingNumberOfCameras) collect: [ :i |
				(WDSSceneRendererCameraLayersStates for: engine)
					postProcessingState: (postProcessingStates at: i);
					yourself
			])
		].
	].


]

{ #category : #initialization }
WDSSceneRenderer >> initializeWithEngine: aWDCEngine [
	engine := aWDCEngine.
	currentTime := 0.0.
	
	useLateLatching := false.
	directCommandLists := WDCPerFrameSimpleCommandList for: engine.
	perCameraRenderingViewports := OrderedCollection new.
	renderingViewports := OrderedCollection new.
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> intermediateRenderTargetsClass [
	^ nil
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> prepareRenderingForCamera: camera withViewports: viewports [
	| perCameraViewports |
	perCameraViewports := WDSSceneRendererPerCameraRenderingViewports new
		camera: camera;
		renderingViewports: (viewports collect: [ :viewport |
		self prepareSceneRenderingViewportFor: viewport
	]).

	perCameraRenderingViewports add: perCameraViewports.
	renderingViewports addAll: perCameraViewports renderingViewports.

]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> prepareRenderingForViewports: viewports [
	viewports do: [ :viewport | self prepareRenderingForCamera: viewport camera withViewports: {viewport} ]

]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> prepareSceneRenderingViewportFor: viewport [
	| sceneRenderingViewport |
	sceneRenderingViewport := self sceneRendererViewportClass new
		viewport: viewport;
		yourself.

	sceneRenderingViewport scene collectVisibleObjectsAndLightIntoViewport: sceneRenderingViewport.
	sceneRenderingViewport sortVisibleObjects.

	^ sceneRenderingViewport
]

{ #category : #accessing }
WDSSceneRenderer >> renderMode [
	^ self subclassResponsibility
]

{ #category : #rendering }
WDSSceneRenderer >> renderSceneViewports [
	^ self renderSceneViewportsThenDo: nil
]

{ #category : #rendering }
WDSSceneRenderer >> renderSceneViewportsIntoStateTracker: aStateTracker. [
	renderingViewports ifEmpty: [ ^ nil ].

	stateTracker := aStateTracker.

	self setupStateTracker.
	renderingViewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].
]

{ #category : #rendering }
WDSSceneRenderer >> renderSceneViewportsThenDo: aBlock [
	| currentSimpleList |
	(renderingViewports isEmpty and: [aBlock isNil]) ifTrue: [ ^ nil ].

	currentSimpleList := directCommandLists currentList.
	currentSimpleList validCommandAllocator reset.

	^ self stateTracker commandList: currentSimpleList validCommandList rebuildWith: [
		self renderViewports: renderingViewports composeWith: aBlock.
	].

]

{ #category : #rendering }
WDSSceneRenderer >> renderViewport: renderingViewport index: viewportIndex [
	| renderTarget resolveTarget renderPass viewport |
	self setupStateTracker.
	
	viewport := renderingViewport viewport.
	renderTarget := renderingViewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	renderPass setColorClearValue: 0 value: renderingViewport scene backgroundColor asWMVector4F asAGPUColor4f.
	
	"Begin rendering into the viewport"
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self
		setupRenderingViewportStates: renderingViewport;
		renderViewportVisibleObjects: renderingViewport.
	
	"Render the overlays"
	viewport overlayRenderer ifNotNil: [ 
		viewport overlayRenderer renderViewport: viewport overlayWith: stateTracker 
	].
	
	"End rendering into the viewport"
	stateTracker endRenderPass.
	
	"Resolve the target"
	renderTarget ~~ resolveTarget ifTrue: [
		stateTracker resolveRenderTarget: renderTarget into: resolveTarget
	]

]

{ #category : #rendering }
WDSSceneRenderer >> renderViewportLayer: viewportLayer visibleObjectsWithCameraLayerState: layerCameraState [
	| count |
	count := 0.
	stateTracker useShaderResources: layerCameraState shaderBindings.
	viewportLayer visibleObjects do: [ :object |
		object renderOn: stateTracker.
		count := count + 1.
	].
	^ count
]

{ #category : #rendering }
WDSSceneRenderer >> renderViewportVisibleObjects: renderingViewport [	
	| count cameraLayersStates |
	count := 0.
	cameraLayersStates := renderingViewport cameraLayersStates.
	count := self renderViewportLayer: renderingViewport backgroundLayer visibleObjectsWithCameraLayerState: cameraLayersStates backgroundLayerState.
	count := count + (self renderViewportLayer: renderingViewport normalLayer visibleObjectsWithCameraLayerState: cameraLayersStates 	normalLayerState).
	count := count + (self renderViewportLayer: renderingViewport foregroundLayer visibleObjectsWithCameraLayerState: cameraLayersStates foregroundLayerState).
	engine frameRenderingMetrics renderedObjectCount: engine frameRenderingMetrics renderedObjectCount + count.
]

{ #category : #rendering }
WDSSceneRenderer >> renderViewports: viewports composeWith: aBlock [	
	viewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].
	aBlock ifNotNil: [ aBlock cull: stateTracker ]
]

{ #category : #abstract }
WDSSceneRenderer >> sceneRendererViewportClass [
	self subclassResponsibility
]

{ #category : #rendering }
WDSSceneRenderer >> setupRenderingViewportStates: renderingViewport [
	stateTracker
		submode: renderingViewport submode;
		editorViewType: renderingViewport editorViewType.
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> setupRenderingViewportsIntermediateRenderTargets [
	| targetsClass requiredExtent requiredSampleCount signature |
	targetsClass := self intermediateRenderTargetsClass.
	targetsClass ifNil: [ ^ self ].
	
	intermediateRenderTargets ifNil: [ intermediateRenderTargets := Dictionary new. ].
	
	intermediateRenderTargets valuesDo: [ :value | value usedInThisFrame: false ].

	renderingViewports do: [ :renderingViewport |
		requiredExtent := renderingViewport extent.
		requiredSampleCount := renderingViewport sampleCount.
		signature := {requiredExtent . requiredSampleCount}.
		
		(intermediateRenderTargets at: signature ifAbsentPut: [
			targetsClass new
				signature: signature;
				engine: engine;
				sceneRenderer: self;
				createRenderTargets;
				yourself
		]) applyToRenderingViewport: renderingViewport
	].

	intermediateRenderTargets value reject: #usedInThisFrame thenDo: [ :obsolete |
		intermediateRenderTargets removeKey: obsolete signature.
	].

]

{ #category : #rendering }
WDSSceneRenderer >> setupStateTracker [
	^ self setupStateTrackerForRenderMode: self renderMode
]

{ #category : #rendering }
WDSSceneRenderer >> setupStateTrackerForRenderMode: renderMode [
	stateTracker
		reset;
		mode: renderMode;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		sceneCullMode: AGPU_CULL_MODE_BACK;
		sceneDepthEnabled: true;
		sceneDepthWriteMask: true;
		sceneDepthFunction: AGPU_GREATER_EQUAL;

		blendingAllMode: WDCBlendingMode replace.

]

{ #category : #accessing }
WDSSceneRenderer >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := self shaderSignatureClass for: engine ]
]

{ #category : #accessing }
WDSSceneRenderer >> shaderSignatureClass [
	self subclassResponsibility
]

{ #category : #accessing }
WDSSceneRenderer >> stateTracker [
	^ stateTracker ifNil: [ stateTracker := WDCObjectStateTracker for: engine ].
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> submitCurrentCameraStates [
	| currentCameraStates |
	currentCameraStates := useLateLatching
		ifTrue: [ cameraStates first ]
		ifFalse: [ cameraStates at: engine bufferingFrameIndex ].

	renderingViewports doWithIndex: [ :renderingViewport :index |
		(currentCameraStates at: index)
			updateForRenderingViewport: renderingViewport currentTime: currentTime
	].

]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> updateFrameCameraStates [
	self ensureCameraStatesFor: renderingViewports size.
	self submitCurrentCameraStates
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> updateGPUStatesForRenderingViewports [
	self updateFrameCameraStates
]

{ #category : #accessing }
WDSSceneRenderer >> useLateLatching [
	^ useLateLatching
]

{ #category : #accessing }
WDSSceneRenderer >> useLateLatching: anObject [
	useLateLatching := anObject
]
