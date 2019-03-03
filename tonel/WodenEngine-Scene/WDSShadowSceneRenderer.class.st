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
	^ WDCStateTrackerDepthOnlyRenderMode uniqueInstance
]

{ #category : #rendering }
WDSShadowSceneRenderer >> renderViewport: renderingViewport index: viewportIndex [
	| renderTarget resolveTarget renderPass viewport light |
	self setupStateTracker.
	
	viewport := renderingViewport viewport.
	renderTarget := renderingViewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	light := viewport camera light.
	stateTracker depthBiasConstant: light shadowMapDepthBiasConstant negated slope: light shadowMapDepthBiasSlope negated.
	
	
	"Begin rendering into the viewport"
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self setupRenderingViewportStates: renderingViewport.
	
	"Render the viewport objects"
	self renderViewportVisibleObjects: renderingViewport.
	
	"End rendering into the viewport"
	stateTracker endRenderPass.
]

{ #category : #abstract }
WDSShadowSceneRenderer >> sceneRendererViewportClass [
	^ WDSShadowSceneRendererViewport
]

{ #category : #accessing }
WDSShadowSceneRenderer >> shaderSignatureClass [
	^ WDCForwardRenderingShaderSignature
]

{ #category : #accessing }
WDSShadowSceneRenderer >> stateTracker [
	^ stateTracker
]
