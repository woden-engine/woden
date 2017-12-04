render pass creation
createRenderPassWithColors: initialColors depth: initialDepth stencil: initialStencil
	| color passColorAttachments passDepthStencilAttachment |
	passColorAttachments := self colorAttachmentFormats collectWithIndex: [ :format :index |
		color := initialColors at: index.
		color ifNil: [ 
			AGPURenderpassColorAttachmentDescription new
				format: format;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself
		] ifNotNil: [ 
			AGPURenderpassColorAttachmentDescription new
				format: format;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: color asAGPUColor4f;
				yourself
		].
	].

	passDepthStencilAttachment := nil.
	(hasDepth or: [ hasStencil ]) ifTrue: [
		initialDepth ifNil: [ 
			passDepthStencilAttachment := AGPURenderpassDepthStencilDescription new
				format: self depthStencilFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_KEEP;
				end_action: AGPU_ATTACHMENT_KEEP;
				yourself.
		] ifNotNil: [ 
			passDepthStencilAttachment := AGPURenderpassDepthStencilDescription new
				format: self depthStencilFormat;
				sample_count: sampleCount;
				begin_action: AGPU_ATTACHMENT_CLEAR;
				end_action: AGPU_ATTACHMENT_KEEP;
				clear_value: (AGPUDepthStencilValue new depth: initialDepth; stencil: initialStencil; yourself);
				yourself.
		]
	].

	^ (WDCRenderPass for: engine)
		colorAttachments: passColorAttachments;
		depthStencilAttachment: passDepthStencilAttachment;
		checkSession;
		yourself