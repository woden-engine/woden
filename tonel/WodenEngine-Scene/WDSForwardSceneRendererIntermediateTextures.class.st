Class {
	#name : #WDSForwardSceneRendererIntermediateTextures,
	#superclass : #WDSLightedSceneRendererIntermediateTextures,
	#instVars : [
		'gbufferRenderTarget',
		'gbufferRenderPass'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'as yet unclassified' }
WDSForwardSceneRendererIntermediateTextures >> applyToRenderingViewport: renderingViewport [
	super applyToRenderingViewport: renderingViewport.
	renderingViewport
		gbufferRenderTarget: gbufferRenderTarget;
		gbufferRenderPass: gbufferRenderPass
]

{ #category : #'multi eye rendering' }
WDSForwardSceneRendererIntermediateTextures >> createMainRenderTargets [
	super createMainRenderTargets.
	
	gbufferRenderTarget := WDCRenderTarget for: engine colorAttachments: { normalTexture } depthStencilAttachment: depthStencilTexture.

	gbufferRenderPass := gbufferRenderTarget validMainRenderPass.
	gbufferRenderPass setColorClearValue: 0 value: (Color r: 0.5 g: 0.5 b: 1.0) asAGPUColor4f.
	
]
