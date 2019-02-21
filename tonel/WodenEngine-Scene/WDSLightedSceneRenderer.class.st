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
		'shadowMapDebuggingMesh'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSLightedSceneRenderer class >> maxShadowCastingLightCount [
	^ 4
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer class >> shadowMapExtent [
	^ 512 @ 512
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> debugDrawOnPompeiiCanvas: canvas [
	self drawDebugShadowMapsOnPompeiiCanvas: canvas
]

{ #category : #'debug rendering' }
WDSLightedSceneRenderer >> drawDebugShadowMapsOnPompeiiCanvas: canvas [
	| builder |
	true ifTrue: [ ^ self ].
	shadowCastingLightCount = 0 ifTrue: [ 0 ].
	
	shadowMapDebuggingMesh ifNil: [ 
		builder := canvas driver mesh2DBuilder.
		builder fill
			textureArray: shadowMapBuffer element: 0 rectangle: (0@0 extent: 256@256).
		shadowMapDebuggingMesh := builder mesh.
	].

	canvas draw: shadowMapDebuggingMesh
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> maxShadowCastingLightCount [
	^ self class maxShadowCastingLightCount
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> prepareRenderingForViewports: viewports [
	super prepareRenderingForViewports: viewports.
	self prepareShadowMapRendering
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
		prepareRenderingForViewports: viewports.
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> renderShadowMaps [
	shadowCastingLightCount = 0 ifTrue: [ ^ self ].

	self shadowSceneRenderer
		renderSceneViewportsIntoStateTracker: stateTracker
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
	| lightRenderingStates shadowMapIndex viewportCamera lightRenderingState lightSource |
	renderingViewports do: #sortAndSelectLights.

	shadowCastingLights := Array new: self maxShadowCastingLightCount.
	shadowCastingLightCount := 0.

	renderingViewports do: [ :renderingViewport |
		viewportCamera := renderingViewport camera.
		
		lightRenderingStates := renderingViewport selectedLights collect: [ :lightSourceAndDistance |
			lightSource := lightSourceAndDistance first.
			shadowMapIndex := -1.
			(lightSource isShadowCasting and: [ shadowCastingLightCount + lightSource shadowLayerCount <= shadowCastingLights size ]) ifTrue: [
				shadowMapIndex := shadowCastingLightCount
			].
	
			lightRenderingState := lightSource setupRenderingWithShadowMap: shadowMapIndex mainCamera: viewportCamera engine: engine.
			shadowMapIndex >= 0 ifTrue: [
				lightRenderingState cascades do: [ :cascade |
					shadowCastingLightCount := shadowCastingLightCount + 1.
					shadowCastingLights at: shadowCastingLightCount put: {cascade . viewportCamera }.
				].
			].

			lightRenderingState
		].
	
		renderingViewport lightRenderingStates: lightRenderingStates.
	].

]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> updateGPUStatesForRenderingViewports [
	super updateGPUStatesForRenderingViewports.
	self sortAndPrepareLights
]
