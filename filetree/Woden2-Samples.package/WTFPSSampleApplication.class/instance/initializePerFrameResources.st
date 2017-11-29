initialization
initializePerFrameResources
	| samplerDesc |
	intermediateRenderTarget := WTRenderTarget for: engine.
	intermediateRenderTarget extent: 640@480; hasDepth: true; hasStencil: true.
	intermediateRenderTarget createFramebuffers.
	
	commandAllocators := engine frameBufferingCollect: [ :i | engine createGraphicsDirectCommandListAllocator ].
	commandLists := commandAllocators collect: #createListNow.
	
	compositionRenderPass := engine createBasicRenderPassWithColor: Color black.
	
	compositionShaderSignature := engine pipelineStateCache shaderSignatureNamed: #'Composition'.
	compositionPipelineState := engine pipelineStateNamed: #'composition.passthrough'.
	
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_NEAREST;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		yourself.

	compositionSourceBindings := engine frameBufferingCollect: [ :f | engine createShaderSignature: compositionShaderSignature resourceBinding: 1 ].

	compositionSamplerBindings := engine createShaderSignature: compositionShaderSignature resourceBinding: 2.
	compositionSamplerBindings createSampler: 0 description: samplerDesc.
	
	compositionStateBuffer := engine createStreamingUniformBuffer: WTVRState structureSize.
	compositionStateBinding := engine createShaderSignature: compositionShaderSignature resourceBinding: 0.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.