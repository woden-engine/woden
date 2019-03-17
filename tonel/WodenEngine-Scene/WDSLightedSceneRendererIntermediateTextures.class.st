Class {
	#name : #WDSLightedSceneRendererIntermediateTextures,
	#superclass : #WDSSceneRendererIntermediateTextures,
	#instVars : [
		'ambientOcclusionTexture',
		'ambientOcclusionBlurIntermediateTexture',
		'depthStencilTexture',
		'sceneColorTexture',
		'normalTexture',
		'ambientOcclusionHorizontalBlurArguments',
		'ambientOcclusionVerticalBlurArguments',
		'ambientOcclusionRenderTarget',
		'ambientOcclusionIntermediateRenderTarget',
		'ambientOcclusionComputationArguments'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

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
			ambientOcclusionComputationArguments: ambientOcclusionComputationArguments;
			ambientOcclusionHorizontalBlurArguments: ambientOcclusionHorizontalBlurArguments;
			ambientOcclusionVerticalBlurArguments: ambientOcclusionVerticalBlurArguments
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
	normalTexture := engine createRenderTargetColorTextureWithExtent: extent sampleCount: sampleCount format: AGPU_TEXTURE_FORMAT_R10G10B10A2_UNORM.
						
	sceneColorTexture := engine createRenderTargetColorTextureWithExtent: extent sampleCount: sampleCount format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.

]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createRenderTargets [
	self
		createMainRenderTargets;
		createSSAORenderTargets
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createSSAORenderTargets [
	| ssaoWidth ssaoHeight ssaoExtent blurLibrary |
	ssaoWidth := extent x.
	ssaoHeight := extent y.
	ssaoExtent := ssaoWidth@ssaoHeight.

	ambientOcclusionBlurIntermediateTexture := engine createRenderTargetColorTextureWithExtent: ssaoExtent format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	ambientOcclusionTexture := engine createRenderTargetColorTextureWithExtent: ssaoExtent format: AGPU_TEXTURE_FORMAT_R8_UNORM.
	
	ambientOcclusionRenderTarget := WDCRenderTarget for: engine colorAttachments: { ambientOcclusionTexture }.
	ambientOcclusionIntermediateRenderTarget := WDCRenderTarget for: engine colorAttachments: { ambientOcclusionBlurIntermediateTexture }.
	
	ambientOcclusionComputationArguments := (WDCAmbientOcclusionComputationFullScreenPass for: engine)
		depthStencilTexture: depthStencilTexture;
		surfaceNormalTexture: normalTexture;
		destinationRenderTarget: ambientOcclusionRenderTarget;
		yourself.
	
	blurLibrary := engine resourceCache loadShaderLibrary: 'shaders/composition/blur.dastrel'.
	ambientOcclusionHorizontalBlurArguments := engine newCompositionFullScreenPass
		sourceTexture: 	ambientOcclusionTexture;
		destinationTexture: ambientOcclusionBlurIntermediateTexture;
		fragmentShader: (blurLibrary getFragmentStage: #horizontal5);
		yourself.

	ambientOcclusionVerticalBlurArguments := engine newCompositionFullScreenPass
		sourceTexture: 	ambientOcclusionBlurIntermediateTexture;
		destinationRenderTarget: ambientOcclusionRenderTarget;
		fragmentShader: (blurLibrary getFragmentStage: #vertical5);
		yourself.

]
