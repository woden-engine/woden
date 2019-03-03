Class {
	#name : #WDSForwardSceneRendererIntermediateTextures,
	#superclass : #WDSLightedSceneRendererIntermediateTextures,
	#instVars : [
		'sceneRenderTarget'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'as yet unclassified' }
WDSForwardSceneRendererIntermediateTextures >> applyToRenderingViewport: renderingViewport [
	super applyToRenderingViewport: renderingViewport.
	renderingViewport renderTarget: sceneRenderTarget
]

{ #category : #'multi eye rendering' }
WDSForwardSceneRendererIntermediateTextures >> createRenderTargets [
	super createRenderTargets.
	
	sceneRenderTarget := WDCRenderTarget for: engine extent: extent.
	sceneRenderTarget
		hasDepth: true;
		hasStencil: sceneRenderer isStencilRequired;
		isDepthReaded: true;
		sampleCount: sampleCount;
		createFramebuffers.
		
	ambientOcclusionComputeShaderBindings
		bind: 0 texture: sceneRenderTarget currentFramebuffer depthStencilAttachment
]
