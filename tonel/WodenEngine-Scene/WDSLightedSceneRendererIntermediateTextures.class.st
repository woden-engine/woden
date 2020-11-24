Class {
	#name : #WDSLightedSceneRendererIntermediateTextures,
	#superclass : #WDSSceneRendererIntermediateTextures,
	#instVars : [
		'ambientOcclusionTexture',
		'ambientOcclusionBlurIntermediateTexture',
		'depthStencilTexture',
		'normalTexture',
		'ambientOcclusionHorizontalBlurArguments',
		'ambientOcclusionVerticalBlurArguments',
		'ambientOcclusionRenderTarget',
		'ambientOcclusionIntermediateRenderTarget',
		'ambientOcclusionComputationArguments',
		'hdrToneMappingFullscreenPass',
		'sceneHDRColorTexture',
		'sceneHDRRenderPass',
		'sceneHDRRenderTarget',
		'sceneLDRColorTexture',
		'sceneLDRRenderPass',
		'sceneLDRRenderTarget',
		'sceneLuminanceComputationTextures',
		'sceneLuminanceComputationPasses',
		'sceneHDRColorResolveTexture'
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

	renderingViewport sceneLuminanceComputationPasses: sceneLuminanceComputationPasses.

	renderingViewport
		sceneHDRRenderTarget: sceneHDRRenderTarget;
		sceneHDRColorTexture: sceneHDRColorTexture;
		sceneHDRColorResolveTexture: sceneHDRColorResolveTexture;
		sceneHDRRenderPass: sceneHDRRenderPass;
		sceneLDRRenderTarget: sceneLDRRenderTarget;
		sceneLDRRenderPass: sceneLDRRenderPass;
		hdrToneMappingFullscreenPass: hdrToneMappingFullscreenPass.
]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createMainRenderTargets [
	depthStencilTexture := engine createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: sceneRenderer depthStencilFormat;
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			usage_modes: AGPU_TEXTURE_USAGE_DEPTH_ATTACHMENT | AGPU_TEXTURE_USAGE_SAMPLED;
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: sampleCount;
			yourself).
	normalTexture := engine createRenderTargetColorTextureWithExtent: extent sampleCount: sampleCount format: AGPU_TEXTURE_FORMAT_R10G10B10A2_UNORM.
	
	sceneHDRColorTexture := engine createRenderTargetColorTextureWithExtent: extent sampleCount: sampleCount format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT.
	sceneHDRColorResolveTexture := sampleCount = 1
		ifTrue: [sceneHDRColorTexture]
		ifFalse: [engine createRenderTargetColorTextureWithExtent: extent sampleCount: 1 format: AGPU_TEXTURE_FORMAT_R16G16B16A16_FLOAT].

	sceneLDRColorTexture := engine createRenderTargetColorTextureWithExtent: extent sampleCount: sampleCount format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.

	sceneHDRRenderTarget := WDCRenderTarget for: engine colorAttachments: { sceneHDRColorTexture } depthStencilAttachment: depthStencilTexture.
	sceneHDRRenderPass := sceneHDRRenderTarget createRenderPassDescription
		setColorAttachmentBeginAction: AGPU_ATTACHMENT_CLEAR endAction: AGPU_ATTACHMENT_KEEP;
		setDepthStencilBeginAction: AGPU_ATTACHMENT_KEEP endAction: AGPU_ATTACHMENT_KEEP;
		checkSession;
		yourself.

	sceneLDRRenderTarget := WDCRenderTarget for: engine colorAttachments: { sceneLDRColorTexture } depthStencilAttachment: depthStencilTexture.
	sceneLDRRenderPass := sceneLDRRenderTarget createRenderPassDescription
		setColorAttachmentBeginAction: AGPU_ATTACHMENT_CLEAR endAction: AGPU_ATTACHMENT_KEEP;
		setDepthStencilBeginAction: AGPU_ATTACHMENT_KEEP endAction: AGPU_ATTACHMENT_KEEP;
		checkSession;
		yourself.

	hdrToneMappingFullscreenPass := (WDCToneMappingFullScreenPass for: engine)
		sceneHDRColorTexture: sceneHDRColorResolveTexture;
		yourself.

]

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createRenderTargets [
	self
		createMainRenderTargets;
		createSSAORenderTargets;
		createSceneLuminanceRenderTargets
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
		sampleCount: sampleCount;
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

{ #category : #'multi eye rendering' }
WDSLightedSceneRendererIntermediateTextures >> createSceneLuminanceRenderTargets [
	| logLuminaceShader downsampleShader |
	sceneLuminanceComputationTextures := #(256 128 64 32 16 8 4 2 1) collect: [ :size |
		engine createRenderTargetColorTextureWithExtent: size@size sampleCount: 1 format: AGPU_TEXTURE_FORMAT_R16_FLOAT.
	].

	logLuminaceShader := engine resourceCache loadFragmentShader: 'shaders/composition/log-luminance.dastrel'.
	downsampleShader := engine resourceCache loadFragmentShader: 'shaders/composition/downsample.dastrel'.
	sceneLuminanceComputationPasses := sceneLuminanceComputationTextures collectWithIndex: [ :targetTexture :index |
		engine newCompositionFullScreenPass
			sourceTexture: 	(index = 1
					ifTrue: [sceneHDRColorResolveTexture]
					ifFalse: [sceneLuminanceComputationTextures at: index - 1]);
			destinationTexture: targetTexture;
			fragmentShader: (index = 1
					ifTrue: [logLuminaceShader]
					ifFalse: [downsampleShader]);
			yourself.
	].

	hdrToneMappingFullscreenPass sceneLuminanceTexture: sceneLuminanceComputationTextures last
		

]
