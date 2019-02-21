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
		'currentCameraStates',
		'useLateLatching',
		'currentCameraViewports',
		'directCommandLists',
		'renderingViewports'
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
WDSSceneRenderer >> debugDrawOnPompeiiCanvas: canvas [
]

{ #category : #initialization }
WDSSceneRenderer >> ensureCameraStatesFor: requiredNumberOfCameras [
	| pool currentNumberOfCameras missingNumberOfCameras |
	cameraStates ifNil: [ 
		cameraStates := (1 to: self cameraStateFramebufferingCount) collect: [ :f | #() ].
	].
	
	currentNumberOfCameras := cameraStates first size.
	missingNumberOfCameras := requiredNumberOfCameras - currentNumberOfCameras.
	
	pool := engine resourceCache streamingUniformBufferPoolFor: WTCameraState.
	
	cameraStates := cameraStates collect: [ :oldFrameStates |
		oldFrameStates , ((pool allocate: missingNumberOfCameras) collect: [ :bufferElement |
			self shaderSignature newCameraState
				bind: 0 uniformBufferElement: bufferElement;
				yourself
		])
	].
]

{ #category : #initialization }
WDSSceneRenderer >> initializeWithEngine: aWDCEngine [
	engine := aWDCEngine.
	currentTime := 0.0.
	
	useLateLatching := false.
	directCommandLists := WDCPerFrameSimpleCommandList for: engine

]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> prepareRenderingForViewports: viewports [
	renderingViewports := viewports collect: [ :viewport |
		self prepareSceneRenderingViewportFor: viewport
	].

	self updateGPUStatesForRenderingViewports.
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
	^ self renderSceneViewportsComposeWith: nil
]

{ #category : #rendering }
WDSSceneRenderer >> renderSceneViewportsComposeWith: aBlock [
	| currentSimpleList |
	(renderingViewports isEmpty and: [aBlock isNil]) ifTrue: [ ^ nil ].

	currentSimpleList := directCommandLists currentList.
	currentSimpleList validCommandAllocator reset.

	^ self stateTracker commandList: currentSimpleList validCommandList rebuildWith: [
		self renderViewports: renderingViewports composeWith: aBlock.
	].

]

{ #category : #rendering }
WDSSceneRenderer >> renderSceneViewportsIntoStateTracker: aStateTracker. [
	renderingViewports ifEmpty: [ ^ nil ].

	stateTracker := aStateTracker.

	self setupStateTracker.
	renderingViewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].
]

{ #category : #rendering }
WDSSceneRenderer >> renderViewport: renderingViewport index: viewportIndex [
	| renderTarget resolveTarget renderPass viewport |
	self setupStateTracker.
	
	viewport := renderingViewport viewport.
	renderTarget := viewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	renderPass setColorClearValue: 0 value: renderingViewport scene backgroundColor asAGPUColor4f.
	
	"Begin rendering into the viewport"
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self setupViewportRendering: viewport index: viewportIndex.
	
	"Render the viewport objects"
	renderingViewport visibleObjects do: [ :object |
		object renderOn: stateTracker
	].

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
WDSSceneRenderer >> renderViewports: viewports composeWith: aBlock [	
	viewports doWithIndex: [ :viewport :index | self renderViewport: viewport index: index ].
	aBlock ifNotNil: [ aBlock cull: stateTracker ]
]

{ #category : #abstract }
WDSSceneRenderer >> sceneRendererViewportClass [
	self subclassResponsibility
]

{ #category : #rendering }
WDSSceneRenderer >> setupStateTracker [
	stateTracker
		reset;
		mode: self renderMode;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		objectCullMode: AGPU_CULL_MODE_BACK;
		objectDepthEnabled: true;
		objectDepthWriteMask: true;
		objectDepthFunction: AGPU_GREATER_EQUAL;

		blendingAllMode: WDCBlendingMode replace.

]

{ #category : #rendering }
WDSSceneRenderer >> setupViewportRendering: viewport index: viewportIndex [
	stateTracker 
		mode: self renderMode;
		submode: viewport submode;
		editorViewType: viewport editorViewType.
	stateTracker
		useShaderResources: (currentCameraStates at: viewportIndex)
]

{ #category : #accessing }
WDSSceneRenderer >> shaderSignature [
	^ shaderSignature ifNil: [ shaderSignature := self shaderSignatureClass for: engine ]
]

{ #category : #accessing }
WDSSceneRenderer >> shaderSignatureClass [
	self subclassResponsibility
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> sortObjects: objectList perViewports: viewports [
	| viewport forwardDirection translucentSortedPriority |
	translucentSortedPriority := WDSGNode renderPriorityTranslucentSorted.
	
	objectList doWithIndex: [ :objects :index |
		viewport := viewports at: index.
		forwardDirection := viewport camera renderTransform matrix thirdColumn negated.
		objects sort: [ :a :b |
			a renderPriority = b renderPriority ifFalse: [
				a renderPriority < b renderPriority
			] ifTrue: [
				a renderPriority >= translucentSortedPriority ifTrue: [ 
					(forwardDirection dot: a renderTransform translation) > (forwardDirection dot: b renderTransform translation)
				] ifFalse: [ false ]
			]
		]
	].

]

{ #category : #accessing }
WDSSceneRenderer >> stateTracker [
	^ stateTracker ifNil: [ stateTracker := WDCObjectStateTracker for: engine ].
]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> submitCurrentCameraStates [
	| cameraState gpuCameraState viewport |
	renderingViewports doWithIndex: [ :renderingViewport :index |
		viewport := renderingViewport viewport.
		cameraState := viewport cameraState.
		cameraState
			transform: viewport cameraTransform;
			currentTime: currentTime.
				
		gpuCameraState := (currentCameraStates at: index) slotValueAt: 0.
		gpuCameraState atomicSetValue: cameraState.
	].

]

{ #category : #'rendering preparations' }
WDSSceneRenderer >> updateFrameCameraStates [
	self ensureCameraStatesFor: renderingViewports size.
	currentCameraStates := useLateLatching
		ifTrue: [ cameraStates first ]
		ifFalse: [ cameraStates at: engine bufferingFrameIndex ].
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
