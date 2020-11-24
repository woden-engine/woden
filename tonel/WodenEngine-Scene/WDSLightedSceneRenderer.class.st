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
		'debugRenderTargetIndex',
		'activeDebugRenderingViewport'
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
	^ 2048 @ 2048
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> applyDebugRenderShadowMapViewport [
	| shadowLight cameraState gpuCameraState |
	(debugRenderShadowMapViewport between: 1 and: shadowCastingLightCount) ifFalse: [ ^ self ].

	shadowLight := (shadowCastingLights at: debugRenderShadowMapViewport) first.

	cameraState := renderingViewports first viewport cameraState copy.
	cameraState
		transform: shadowLight globalTransform;
		projectionMatrix: shadowLight shadowProjectionMatrix.
			
	self halt.
	gpuCameraState := renderingViewports first cameraStateShaderBindings slotValueAt: 0.
	gpuCameraState atomicSetValue: cameraState.
]

{ #category : #rendering }
WDSLightedSceneRenderer >> computeSceneAutoExposureFor: renderingViewport [
	stateTracker reset.
	renderingViewport sceneLuminanceComputationPasses do: [ :pass |
		stateTracker applyFullScreenPass: pass
	].

	stateTracker 
		shaderSignature: self shaderSignature;
		useComputeShaderResources: self shaderSignature defaultSamplers;
		useComputeShaderResources: renderingViewport cameraLayersStates foregroundLayerState shaderBindings.
	renderingViewport hdrToneMappingFullscreenPass computeAutoExposureWith: stateTracker.

]

{ #category : #'ambient occlusion' }
WDSLightedSceneRenderer >> computeScreenSpaceAmbientOcclusionFor: renderingViewport [
	| aoShaderShaderSignature |
	aoShaderShaderSignature := WDCAmbientOcclusionShaderSignature for: engine.
	
	stateTracker 
		"Ambient occlusion main compuation."
		shaderSignature: aoShaderShaderSignature;
		useShaderResources: aoShaderShaderSignature defaultSamplers;
		useShaderResources: renderingViewport cameraLayersStates normalLayerState shaderBindings;
		applyFullScreenPass: renderingViewport ambientOcclusionComputationArguments;
		
		"Horizontal blur pass"
		applyFullScreenPass: renderingViewport ambientOcclusionHorizontalBlurArguments;
		
		"Vertical blur pass"
		applyFullScreenPass: renderingViewport ambientOcclusionVerticalBlurArguments.

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

{ #category : #testing }
WDSLightedSceneRenderer >> depthStencilFormat [
	^ self isStencilRequired
		ifTrue: [ engine preferredDepthStencilFormat ]
		ifFalse: [ engine preferredDepthFormat ]
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

{ #category : #rendering }
WDSLightedSceneRenderer >> gbufferRenderMode [
	^ WDCStateTrackerDepthNormalRenderMode uniqueInstance
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
WDSLightedSceneRenderer >> prepareLightSource: renderingLightSource forViewportCamera: viewportCamera [
	| shadowMapIndex lightRenderingState lightSource |
	shadowMapIndex := -1.
	lightSource := renderingLightSource lightSource.
	(engine shadowMappingEnabled and:
	 [lightSource isShadowCasting and:
	 [ shadowCastingLightCount + lightSource shadowLayerCount <= shadowCastingLights size ]]) ifTrue: [
		shadowMapIndex := shadowCastingLightCount
	].

	lightRenderingState := renderingLightSource setupRenderingWithShadowMap: shadowMapIndex mainCamera: viewportCamera engine: engine.
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
	self shadowMapRenderTargets ifNil: [ ^ self ].
	
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
	| resolveTarget viewport camera|
	activeDebugRenderingViewport := renderingViewport.
	viewport := renderingViewport viewport.
	resolveTarget := viewport resolveRenderTarget.
	camera := viewport camera.

	"Render the overlay render targets"
	viewport overlayRenderer ifNotNil: [ 
		viewport overlayRenderer renderViewport: viewport overlayRenderTargetWith: stateTracker 
	].

	"First pass: g-buffer rendering. Normal and depth-only rendering."
	self setupStateTrackerForRenderMode: self gbufferRenderMode.
	stateTracker
		beginRenderPass: renderingViewport validGBufferRenderPass renderTarget: renderingViewport gbufferRenderTarget bounds: viewport bounds.
	self
		setupRenderingViewportStates: renderingViewport;
		renderViewportVisibleObjects: renderingViewport.
	stateTracker endRenderPass.
	
	engine ssaoEnabled ifTrue: [ 
		self computeScreenSpaceAmbientOcclusionFor: renderingViewport.
	].

	"Second pass: main scene HDR rendering"
	self setupStateTracker.
	
	camera isLdrToneMapping ifTrue: [ 
		stateTracker
			beginRenderPass: renderingViewport validSceneLDRRenderPass renderTarget: renderingViewport sceneLDRRenderTarget bounds: viewport bounds.
	] ifFalse: [ 
		stateTracker
			beginRenderPass: renderingViewport validSceneHDRRenderPass renderTarget: renderingViewport sceneHDRRenderTarget bounds: viewport bounds.
	].

	self
		setupRenderingViewportStates: renderingViewport;
		renderViewportVisibleObjects: renderingViewport.

	camera isLdrToneMapping ifFalse: [ 
		stateTracker
			endRenderPass.
		renderingViewport sceneHDRColorTexture ~~ renderingViewport sceneHDRColorResolveTexture ifTrue: [
			stateTracker
				resolveTexture: renderingViewport sceneHDRColorTexture into: renderingViewport sceneHDRColorResolveTexture aspect: AGPU_TEXTURE_ASPECT_COLOR
		].

		renderingViewport hdrToneMappingFullscreenPass
			toneMappingOperator: camera toneMappingOperatorShaderName.

		"Compute the scene auto exposure parameters."
		camera hasAutoExposure ifTrue: [
			self computeSceneAutoExposureFor: renderingViewport.
		].
		
		"Third Pass: HDR -> LDR tone mapping. And LDR overlay rendering."
		stateTracker
			beginRenderPass: renderingViewport validSceneLDRRenderPass renderTarget: renderingViewport sceneLDRRenderTarget bounds: viewport bounds;
			shaderSignature: self shaderSignature;
			useShaderResources: self shaderSignature defaultSamplers;
			useShaderResources: renderingViewport globalLightingStateShaderBindings;
			useShaderResources: renderingViewport cameraLayersStates foregroundLayerState shaderBindings;
			depthEnabled: false;
			depthWriteMask: false;
			applyFullScreenPass: renderingViewport hdrToneMappingFullscreenPass.
	].

	self renderViewportOverlays: renderingViewport.
	
	"End rendering into the viewport"
	stateTracker endRenderPass.
		
	"Resolve the target"
	renderingViewport sceneLDRRenderTarget ~~ resolveTarget ifTrue: [
		stateTracker resolveRenderTarget: renderingViewport sceneLDRRenderTarget into: resolveTarget
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

{ #category : #initialization }
WDSLightedSceneRenderer >> sessionChanged [
	super sessionChanged.
	shadowMapRenderTargets := nil.
	shadowSceneRenderer ifNotNil: [ shadowSceneRenderer sessionChanged ].
]

{ #category : #accessing }
WDSLightedSceneRenderer >> shaderSignatureClass [
	^ WDCSceneRenderingShaderSignature
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowMapBuffer [
	| shadowMapExtent description shadowMapFormat |
	shadowMapBuffer ifNotNil: [ ^ shadowMapBuffer ].
	shadowMapExtent := self shadowMapExtent.
	
	shadowMapFormat := engine preferredDepthFormat.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: shadowMapFormat;
		width: shadowMapExtent x;
		height: shadowMapExtent y;
		depth: 1;
		layers: self maxShadowCastingLightCount;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_TEXTURE_USAGE_SAMPLED | AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT;
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		yourself.
		
	shadowMapBuffer := (WDCTexture for: engine)
			description: description;
			checkSession;
			yourself.

	^ shadowMapBuffer
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowMapExtent [
	^ self class shadowMapExtent
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> shadowMapRenderTargets [
	| shadowMapExtent shadowMapFormat |
	shadowMapRenderTargets ifNotNil: [ ^ shadowMapRenderTargets ].
	shadowMapExtent := self shadowMapExtent.
	shadowMapFormat := engine preferredDepthFormat.

	shadowMapRenderTargets := (1 to: self maxShadowCastingLightCount) collect: [ :i |
		(WDCRenderTarget for: engine extent: shadowMapExtent)
			colorAttachmentFormats: #();
			depthStencilFormat: shadowMapFormat;
			hasDepth: true;
			createFramebuffersWithColorAttachments: #() views: #() depthStencilAttachment: self shadowMapBuffer view: (self shadowMapBuffer createViewForSingleLayer: i - 1);
			yourself
	].
	
	^ shadowMapRenderTargets
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
