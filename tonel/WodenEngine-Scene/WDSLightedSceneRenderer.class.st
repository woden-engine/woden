Class {
	#name : #WDSLightedSceneRenderer,
	#superclass : #WDSSceneRenderer,
	#instVars : [
		'visibleLightSources',
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

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> collectVisibleObjectsFor: camera [
	visibleLightSources removeAll.
	^ super collectVisibleObjectsFor: camera

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

{ #category : #initialization }
WDSLightedSceneRenderer >> initializeWithEngine: aWDCEngine [
	super initializeWithEngine: aWDCEngine.
	visibleLightSources := OrderedCollection new
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> maxShadowCastingLightCount [
	^ self class maxShadowCastingLightCount
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> renderShadowMaps [
	
	| viewports |
	viewports := (1 to: shadowCastingLightCount) collect: [ :i | (shadowCastingLights at: i) viewportForShadowMap: (shadowMapRenderTargets at: i) camera: mainCamera ].
	
	self shadowSceneRenderer
		currentTime: currentTime;
		renderScene: currentScene viewports: viewports intoStateTracker: stateTracker
]

{ #category : #rendering }
WDSLightedSceneRenderer >> renderViewports: viewports composeWith: aBlock [
	shadowCastingLightCount ~= 0 ifTrue: [ self renderShadowMaps ].
	
	^ super renderViewports: viewports composeWith: aBlock
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> selectLights [
	| numberOfLights lightSource shadowMapIndex lightRenderingState |
	numberOfLights := visibleLightSources size min: 16.
	shadowCastingLights := Array new: self maxShadowCastingLightCount.
	shadowCastingLightCount := 0.

	usedLights := (1 to: numberOfLights) collect: [ :lightIndex |
		lightSource := (visibleLightSources at: lightIndex) first.
		shadowMapIndex := -1.
		(lightSource isShadowCasting and: [ shadowCastingLightCount + lightSource shadowLayerCount <= shadowCastingLights size ]) ifTrue: [
			shadowMapIndex := shadowCastingLightCount
		].
	
		lightRenderingState := lightSource setupRenderingWithShadowMap: shadowMapIndex mainCamera: mainCamera engine: engine.
		shadowMapIndex >= 0 ifTrue: [
			lightRenderingState cascades do: [ :cascade |
				shadowCastingLightCount := shadowCastingLightCount + 1.
				shadowCastingLights at: shadowCastingLightCount put: cascade.
			].
		].

		lightRenderingState
	].

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
WDSLightedSceneRenderer >> sortAndPrepareLightsFor: viewports [
	self
		sortVisibleLights;
		selectLights.
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> sortVisibleLights [
	visibleLightSources sort: [ :a :b |
		a second < b second
	].

]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> tryToCollectLightSource: lightSource for: camera [
	self flag: 'Check for the light source influence radius and distance to the camera'.

	visibleLightSources add: {lightSource . 0.0}
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> updateRenderingStatesFor: viewports [
	super updateRenderingStatesFor: viewports.
	self
		sortAndPrepareLightsFor: viewports
]
