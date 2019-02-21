Class {
	#name : #WDSShadowSceneRenderer,
	#superclass : #WDSSceneRenderer,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'rendering preparations' }
WDSShadowSceneRenderer >> collectVisibleObject: node [
	node isOpaqueShadowCaster ifFalse: [ ^ self ].
	^ super collectVisibleObject: node
]

{ #category : #rendering }
WDSShadowSceneRenderer >> renderMode [
	^ WDCStateTrackerShadowRenderMode uniqueInstance
]

{ #category : #rendering }
WDSShadowSceneRenderer >> renderViewport: renderingViewport index: viewportIndex [
	| renderTarget resolveTarget renderPass viewport |
	self setupStateTracker.
	
	viewport := renderingViewport viewport.
	renderTarget := viewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	
	"Begin rendering into the viewport"
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self setupViewportRendering: viewport index: viewportIndex.
	
	"Render the viewport objects"
	renderingViewport visibleObjects do: [ :object |
		object renderOn: stateTracker
	].
	
	"End rendering into the viewport"
	stateTracker endRenderPass.
]

{ #category : #abstract }
WDSShadowSceneRenderer >> sceneRendererViewportClass [
	^ WDSShadowSceneRendererViewport
]

{ #category : #rendering }
WDSShadowSceneRenderer >> setupStateTracker [
	stateTracker
		reset;
		mode: self renderMode;
		shaderSignature: self shaderSignature;
		useShaderResources: self shaderSignature defaultSamplers;
		
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		objectCullMode: AGPU_CULL_MODE_BACK;
		objectDepthEnabled: true;
		objectDepthWriteMask: true;
		objectDepthFunction: AGPU_GREATER_EQUAL
]

{ #category : #accessing }
WDSShadowSceneRenderer >> shaderSignatureClass [
	^ WDCForwardRenderingShaderSignature
]

{ #category : #accessing }
WDSShadowSceneRenderer >> stateTracker [
	^ stateTracker
]
