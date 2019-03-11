Class {
	#name : #WDSLightedSceneRendererIntermediateTextures,
	#superclass : #WDSSceneRendererIntermediateTextures,
	#instVars : [
		'ambientOcclusionTexture',
		'ambientOcclusionComputeShaderBindings',
		'ambientOcclusionBlurIntermediateTexture',
		'depthStencilTexture',
		'sceneColorTexture',
		'normalTexture'
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
	engine ssaoEnabled ifTrue: [ 
		renderingViewport
			ambientOcclusionTexture: ambientOcclusionTexture;
			ambientOcclusionComputeShaderBindings: ambientOcclusionComputeShaderBindings
	] ifFalse: [ 
		renderingViewport
			ambientOcclusionTexture: engine resourceCache whiteTexture
	].

]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createMainRenderTargets [
	depthStencilTexture := engine createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depthOrArraySize: 1;
			miplevels: 1;
			format: sceneRenderer depthStencilFormat;
			flags: AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_RENDER_TARGET;
			sample_count: sampleCount;
			yourself).
	normalTexture := engine createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depthOrArraySize: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_R10G10B10A2_UNORM;
			flags: AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_RENDER_TARGET;
			sample_count: sampleCount;
			yourself).
						
	sceneColorTexture := engine createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depthOrArraySize: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			flags: AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_RENDER_TARGET;
			sample_count: sampleCount;
			yourself).
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createRenderTargets [
	self
		createMainRenderTargets;
		createSSAORenderTargets
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createSSAORenderTargets [
	| ssaoWidth ssaoHeight |
	ssaoWidth := extent x.
	ssaoHeight := extent y.
	ambientOcclusionTexture := engine createStorageImageWithExtent: ssaoWidth@ssaoHeight format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	ambientOcclusionBlurIntermediateTexture := engine createStorageImageWithExtent: ssaoWidth@ssaoHeight format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	
	ambientOcclusionComputeShaderBindings := (WDCAmbientOcclusionShaderSignature for: engine)
		newComputeBuffers
			bind: 0 texture: depthStencilTexture;
			bind: 1 texture: normalTexture;
			bind: 2 storageImage: ambientOcclusionTexture;
			yourself.
]
