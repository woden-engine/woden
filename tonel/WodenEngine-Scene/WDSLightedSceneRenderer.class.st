Class {
	#name : #WDSLightedSceneRenderer,
	#superclass : #WDSSceneRenderer,
	#instVars : [
		'shadowSceneRenderer'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> maxShadowCastingLightCount [
	^ self class maxShadowCastingLightCount
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> prepareShadowCastingFor: viewports [
	"Sort the lights."
	visibleLightSources sort: [ :a :b |
		a second < b second
	].

	self selectShadowCastingLights.
]

{ #category : #'shadow mapping' }
WDSLightedSceneRenderer >> renderShadowMaps [
	
	| viewports |
	viewports := (1 to: shadowCastingLightCount) collect: [ :i | (shadowCastingLights at: i) viewportForShadowMap: (shadowMapRenderTargets at: i) camera: mainCamera ].
	
	self shadowSceneRenderer
		currentTime: currentTime;
		renderScene: currentScene viewports: viewports intoStateTracker: stateTracker
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
WDSLightedSceneRenderer >> tryToCollectLightSource: lightSource for: camera [
	self flag: 'Check for the light source influence radius and distance to the camera'.

	visibleLightSources add: {lightSource . 0.0}
]

{ #category : #'rendering preparations' }
WDSLightedSceneRenderer >> updateRenderingStatesFor: viewports [
	super updateRenderingStatesFor: viewports.
	self prepareShadowCastingFor: viewports.
	
]
