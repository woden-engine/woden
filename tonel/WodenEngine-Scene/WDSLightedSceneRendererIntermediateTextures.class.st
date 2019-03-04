Class {
	#name : #WDSLightedSceneRendererIntermediateTextures,
	#superclass : #WDSSceneRendererIntermediateTextures,
	#instVars : [
		'ambientOcclusionTexture',
		'ambientOcclusionComputeShaderBindings',
		'ambientOcclusionBlurIntermediateTexture'
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
	ssaoWidth := extent x.
	ssaoHeight := extent y.
	ambientOcclusionTexture := engine createStorageImageWithExtent: ssaoWidth@ssaoHeight format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	ambientOcclusionBlurIntermediateTexture := engine createStorageImageWithExtent: ssaoWidth@ssaoHeight format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	
	ambientOcclusionComputeShaderBindings := (WDCAmbientOcclusionShaderSignature for: engine)
		newComputeBuffers
			bind: 1 storageImage: ambientOcclusionTexture;
			yourself.
			
	
]
