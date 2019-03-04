Class {
	#name : #WDSLightedSceneRenderer,
	#superclass : #WDSSceneRenderer,
	#instVars : [
		'shadowCastingLights',
		'shadowCastingLightCount',
		'shadowMapBuffer',
		'shadowMapRenderTargets',
		'shadowSceneRenderer',
		'usedLights',
		'debugRenderMesh',
		'debugRenderShadowMapViewport',
		'intermediateRenderTarget',
		'ambientOcclusionComputeShader',
		'debugRenderTargetIndex',
		'activeDebugRenderingViewport',
		'ambientOcclusionMSComputeShader'
	],
	#classVars : [
		'RenderTargetDebugDrawingMethod',
		'RenderTargetIndex_AmbientOcclusion',
		'RenderTargetIndex_Count',
		'RenderTargetIndex_DepthBuffer',
		'RenderTargetIndex_None',
		'RenderTargetIndex_ShadowMap'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'class initialization' }
WDSLightedSceneRenderer class >> initialize [
	RenderTargetIndex_None := 0.
	RenderTargetIndex_ShadowMap := 1.
	RenderTargetIndex_AmbientOcclusion := 2.
	RenderTargetIndex_DepthBuffer := 3.
	RenderTargetIndex_Count := 3.
	
	RenderTargetDebugDrawingMethod := Dictionary newFromPairs: {
		RenderTargetIndex_ShadowMap . #debugDrawShadowMapsOnBabylonCanvas:.
		RenderTargetIndex_DepthBuffer . #debugDrawDepthBufferOnBabylonCanvas:.
		RenderTargetIndex_AmbientOcclusion . #debugDrawAmbientOcclusionOnBabylonCanvas:.
	}
]

{ #category : #accessing }
WDSLightedSceneRenderer class >> maxShadowCastingLightCount [
	^ 4
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer class >> shadowMapExtent [
	^ 512 @ 512
]

{ #category : #'ambient occlusion' }
WDSLightedSceneRenderer >> ambientOcclusionComputeShader [
	^ ambientOcclusionComputeShader ifNil: [ambientOcclusionComputeShader := engine loadComputeShader: 'shaders/lighting/ambientOcclusionCompute.dastrel']
]

{ #category : #'ambient occlusion' }
WDSLightedSceneRenderer >> ambientOcclusionMSComputeShader [
	^ ambientOcclusionMSComputeShader ifNil: [ambientOcclusionMSComputeShader := engine loadComputeShader: 'shaders/lighting/ambientOcclusionMSCompute.dastrel']
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> applyDebugRenderShadowMapViewport [
	| shadowLight cameraState gpuCameraState |
	(debugRenderShadowMapViewport between: 1 and: shadowCastingLightCount) ifFalse: [ ^ self ].

	shadowLight := (shadowCastingLights at: debugRenderShadowMapViewport) first.

	cameraState := renderingViewports first viewport cameraState copy.
	cameraState
		transform: shadowLight renderTransform;
		projectionMatrix: shadowLight shadowProjectionMatrix.
			
	gpuCameraState := currentCameraStates first slotValueAt: 0.
	gpuCameraState atomicSetValue: cameraState.
]

{ #category : #'ambient occlusion' }
WDSLightedSceneRenderer >> computeScreenSpaceAmbientOcclusionFor: renderingViewport [
	| description width height aoShaderShaderSignature |
	description := renderingViewport ambientOcclusionTexture description.
	width := description width.
	height := description height.
	aoShaderShaderSignature := WDCAmbientOcclusionShaderSignature for: engine.
	
	stateTracker
		shaderSignature: aoShaderShaderSignature;
		computeShader: (renderingViewport sampleCount <= 1
			ifTrue: [self ambientOcclusionComputeShader]
			ifFalse: [self ambientOcclusionMSComputeShader]);
		useComputeShaderResources: aoShaderShaderSignature defaultSamplers;
		useComputeShaderResources: renderingViewport cameraStateShaderBindings;
		useComputeShaderResources: renderingViewport ambientOcclusionComputeShaderBindings;
		dispatchComputeGlobalGridX: width y: height.
	"stateTracker
		computeShader: (renderingViewport sampleCount <= 1
			ifTrue: [self ambientOcclusionComputeShader]
			ifFalse: [self ambientOcclusionMSComputeShader])
			arguments: renderingViewport ambientOcclusionComputeShaderArguments;
		dispatchComputeGlobalGridX: width y: height."
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugDrawAmbientOcclusionOnBabylonCanvas: canvas [
	| builder description |
	
	builder := canvas driver mesh2DBuilder.
	description := activeDebugRenderingViewport ambientOcclusionTexture description.
	builder fill
		grayTexture: activeDebugRenderingViewport ambientOcclusionTexture rectangle: (0@0 extent: 
	description width @ description height).
	
	^ builder mesh

]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugDrawDepthBufferOnBabylonCanvas: canvas [
	^ nil
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugDrawOnBabylonCanvas: canvas [
	self
		drawDebugRenderTargetOnBabylonCanvas: canvas
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugDrawShadowMapsOnBabylonCanvas: canvas [
	| builder column row |
	shadowCastingLightCount = 0 ifTrue: [ ^  nil ].
	
	builder := canvas driver mesh2DBuilder.
	0 to: shadowCastingLightCount - 1 do: [ :i |
		column := i % 2.
		row := i // 2.
			
		builder fill
			grayTextureArray: shadowMapBuffer element: i rectangle: ((column*256)@(row*256) extent: 256@256).
	].

	^ builder mesh

]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugNextRenderTarget [
	debugRenderTargetIndex := (debugRenderTargetIndex + 1) % RenderTargetIndex_Count.
	debugRenderMesh := nil.
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugRenderNextShadowMapViewport [
	shadowCastingLightCount ifNotNil: [ 
		debugRenderShadowMapViewport := (debugRenderShadowMapViewport + 1) % (shadowCastingLightCount + 1)
	]

]

{ #category : #rendering }
WDSLightedSceneRenderer >> depthOnlyRenderMode [
	^ WDCStateTrackerDepthOnlyRenderMode uniqueInstance
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> drawDebugRenderTargetOnBabylonCanvas: canvas [
	| selector |
	selector := RenderTargetDebugDrawingMethod at: debugRenderTargetIndex ifAbsent: [ ^ nil ].
	debugRenderMesh := self perform: selector with: canvas.
	debugRenderMesh ifNotNil: [ canvas draw: debugRenderMesh ]
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> endPreparingRendering [
	super endPreparingRendering.
	self prepareShadowMapRendering
]

{ #category : #initialization }
WDSLightedSceneRenderer >> initialize [
	super initialize.
	debugRenderTargetIndex := RenderTargetIndex_None.
	debugRenderShadowMapViewport := 0.
]

{ #category : #testing }
WDSLightedSceneRenderer >> isStencilRequired [
	^ false
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> maxShadowCastingLightCount [
	^ self class maxShadowCastingLightCount
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> prepareLightSource: lightSource forViewportCamera: viewportCamera [
	| shadowMapIndex lightRenderingState |
	shadowMapIndex := -1.
	(lightSource isShadowCasting and:
	 [ shadowCastingLightCount + lightSource shadowLayerCount <= shadowCastingLights size ]) ifTrue: [
		shadowMapIndex := shadowCastingLightCount
	].

	lightRenderingState := lightSource setupRenderingWithShadowMap: shadowMapIndex mainCamera: viewportCamera engine: engine.
	shadowMapIndex >= 0 ifTrue: [
		lightRenderingState cascades do: [ :cascade | 
			shadowCastingLightCount := shadowCastingLightCount + 1.
			shadowCastingLights at: shadowCastingLightCount put: {cascade. viewportCamera}
		]
	].

	^ lightRenderingState
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> prepareShadowMapRendering [
	
	| viewports shadowCastingLightAndViewer |
	shadowCastingLightCount = 0 ifTrue: [ ^ self ].
	
	viewports := (1 to: shadowCastingLightCount) collect: [ :i |
		shadowCastingLightAndViewer := shadowCastingLights at: i.
		shadowCastingLightAndViewer first viewportForShadowMap: (shadowMapRenderTargets at: i) camera: shadowCastingLightAndViewer second
	].
	
	self shadowSceneRenderer
		currentTime: currentTime;
		beginPreparingRendering;
		prepareRenderingForViewports: viewports;
		endPreparingRendering.
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> renderShadowMaps [
	shadowCastingLightCount = 0 ifTrue: [ ^ self ].

	self shadowSceneRenderer
		renderSceneViewportsIntoStateTracker: stateTracker
]

{ #category : #rendering }
WDSLightedSceneRenderer >> renderViewport: renderingViewport index: viewportIndex [
	| renderTarget resolveTarget renderPass viewport continueRenderPass |
	activeDebugRenderingViewport := renderingViewport.
	viewport := renderingViewport viewport.
	renderTarget := renderingViewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	continueRenderPass := renderTarget validMainContinueRenderPass.
	renderPass setColorClearValue: 0 value: renderingViewport scene backgroundColor asAGPUColor4f.
	
	"First pass: depth only rendering."
	self setupStateTrackerForRenderMode: self depthOnlyRenderMode.
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self
		setupRenderingViewportStates: renderingViewport;
		renderViewportVisibleObjects: renderingViewport.
	stateTracker endRenderPass.
	self computeScreenSpaceAmbientOcclusionFor: renderingViewport.

	"Second pass: rendering of the remaining objects."	
	self setupStateTracker.
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
WDSLightedSceneRenderer >> renderViewports: viewports composeWith: aBlock [
	shadowCastingLightCount ~= 0 ifTrue: [ self renderShadowMaps ].
	
	^ super renderViewports: viewports composeWith: aBlock
]

{ #category : #abstract }
WDSLightedSceneRenderer >> sceneRendererViewportClass [
	^ WDSLightedSceneRendererViewport
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowMapBuffer [
	| shadowMapExtent description shadowMapFormat view subresourceRange |
	shadowMapBuffer ifNotNil: [ ^ shadowMapBuffer ].
	shadowMapExtent := self shadowMapExtent.
	
	shadowMapFormat := engine preferredDepthFormat.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: shadowMapFormat;
		width: shadowMapExtent x;
		height: shadowMapExtent y;
		depthOrArraySize: self maxShadowCastingLightCount;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_DEPTH |AGPU_TEXTURE_FLAG_RENDER_TARGET;
		yourself.
		
	shadowMapBuffer := (WDCTexture for: engine)
			description: description;
			checkSession;
			yourself.

	view := AGPUTextureViewDescription new.
	shadowMapBuffer validHandle getFullViewDescription: view.
	
	subresourceRange := view subresource_range.
	subresourceRange layer_count: 1.
	
	shadowMapRenderTargets := (1 to: self maxShadowCastingLightCount) collect: [ :i |
		subresourceRange base_arraylayer: i - 1.
		(WDCRenderTarget for: engine extent: shadowMapExtent)
			colorAttachmentFormats: #();
			depthStencilFormat: shadowMapFormat;
			hasDepth: true;
			createFramebuffersWithColorAttachments: #() views: #() depthStencilAttachment: shadowMapBuffer view: view;
			yourself
	].
	
	^ shadowMapBuffer
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowMapExtent [
	^ self class shadowMapExtent
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowRenderModeName [
	^ #shadow
]

{ #category : #accessing }
WDSLightedSceneRenderer >> shadowSceneRenderer [
	^ shadowSceneRenderer ifNil: [shadowSceneRenderer := WDSShadowSceneRenderer for: engine].

]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> sortAndPrepareLights [
	| lightRenderingStates viewportCamera lightSource recyclatedStates |
	renderingViewports do: #sortAndSelectLights.
	shadowCastingLights := Array new: self maxShadowCastingLightCount.
	shadowCastingLightCount := 0.
	perCameraRenderingViewports do: [ :perCameraViewports | 
		"This camera represents the head."
		viewportCamera := perCameraViewports camera.
		recyclatedStates := IdentityDictionary new.
		
		"These viewports represent the different eyes of the camera."
		perCameraViewports renderingViewports do: [ :renderingViewport | 
			lightRenderingStates := renderingViewport selectedLights collect: [ :lightSourceAndDistance | 
				lightSource := lightSourceAndDistance first.
				recyclatedStates at: lightSource ifAbsentPut: [
					self prepareLightSource: lightSource forViewportCamera: viewportCamera
				]
			].
			
			renderingViewport lightRenderingStates: lightRenderingStates
		]
	]
]

{ #category : #rendering }
WDSLightedSceneRenderer >> submitCurrentCameraStates [
	super submitCurrentCameraStates.
	self applyDebugRenderShadowMapViewport

]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> updateGPUStatesForRenderingViewports [
	super updateGPUStatesForRenderingViewports.
	self sortAndPrepareLights
]
