Class {
	#name : #WDSLightedSceneRendererIntermediateTextures,
	#superclass : #WDSSceneRendererIntermediateTextures,
	#instVars : [
		'ambientOcclusionTexture',
		'ambientOcclusionComputeShaderBindings'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSLightedSceneRendererIntermediateTextures >> ambientOcclusionComputeShaderBindings [
	^ ambientOcclusionComputeShaderBindings
]

{ #category : #accessing }
WDSLightedSceneRendererIntermediateTextures >> ambientOcclusionComputeShaderBindings: anObject [
	ambientOcclusionComputeShaderBindings := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererIntermediateTextures >> ambientOcclusionTexture [
	^ ambientOcclusionTexture
]

{ #category : #accessing }
WDSLightedSceneRendererIntermediateTextures >> ambientOcclusionTexture: anObject [
	ambientOcclusionTexture := anObject
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> applyToRenderingViewport: renderingViewport [
	super applyToRenderingViewport: renderingViewport.
	renderingViewport
		ambientOcclusionTexture: ambientOcclusionTexture;
		ambientOcclusionComputeShaderBindings: ambientOcclusionComputeShaderBindings
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createRenderTargets [
	| ssaoWidth ssaoHeight |
	ssaoWidth := extent x //2 alignedTo: 4.
	ssaoHeight := extent y //2 alignedTo: 4.
	Transcript show: 'createRenderTargets '; show: ssaoWidth; space; show: ssaoHeight; cr.
	ambientOcclusionTexture := engine createStorageImageWithExtent: ssaoWidth@ssaoHeight format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	
	ambientOcclusionComputeShaderBindings := (WDCAmbientOcclusionShaderSignature for: engine)
		newComputeBuffers
			bind: 1 storageImage: ambientOcclusionTexture;
			yourself
]
