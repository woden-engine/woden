Class {
	#name : #WDSForwardSceneRendererIntermediateTextures,
	#superclass : #WDSLightedSceneRendererIntermediateTextures,
	#instVars : [
		'sceneRenderTarget',
		'gbufferRenderTarget',
		'gbufferRenderPass',
		'sceneRenderPass'
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
		gbufferRenderPass: gbufferRenderPass;
		sceneRenderTarget: sceneRenderTarget;
		sceneRenderPass: sceneRenderPass
]

{ #category : #'multi eye rendering' }
WDSForwardSceneRendererIntermediateTextures >> createMainRenderTargets [
	super createMainRenderTargets.
	
	gbufferRenderTarget := (WDCRenderTarget for: engine extent: extent)
		colorAttachmentFormats: {AGPU_TEXTURE_FORMAT_R10G10B10A2_UNORM};
		depthStencilFormat: sceneRenderer depthStencilFormat;
		hasDepth: true;
		hasStencil: sceneRenderer isStencilRequired;
		isDepthReaded: true;
		sampleCount: sampleCount;
		createFramebuffersWithColorAttachments: {normalTexture} depthStencilAttachment: depthStencilTexture.
	gbufferRenderPass := gbufferRenderTarget validMainRenderPass.
	gbufferRenderPass setColorClearValue: 0 value: (Color r: 0.5 g: 0.5 b: 1.0) asAGPUColor4f.
	
	sceneRenderTarget := (WDCRenderTarget for: engine extent: extent)
		colorAttachmentFormats: {AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB};
		depthStencilFormat: sceneRenderer depthStencilFormat;
		hasDepth: true;
		hasStencil: sceneRenderer isStencilRequired;
		isDepthReaded: true;
		sampleCount: sampleCount;
		createFramebuffersWithColorAttachments: { sceneColorTexture } depthStencilAttachment: depthStencilTexture.
		
	sceneRenderPass := sceneRenderTarget createRenderPassDescription
		setColorAttachmentBeginAction: AGPU_ATTACHMENT_CLEAR endAction: AGPU_ATTACHMENT_KEEP;
		setDepthStencilBeginAction: AGPU_ATTACHMENT_KEEP endAction: AGPU_ATTACHMENT_KEEP;
		checkSession;
		yourself

]
