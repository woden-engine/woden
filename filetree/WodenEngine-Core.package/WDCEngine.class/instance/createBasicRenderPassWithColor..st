resource building
createBasicRenderPassWithColor: aColor
	| colorAttachments depthStencilAttachment |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: aColor asAGPUColor4f;
			yourself
	}.
		
	depthStencilAttachment := AGPURenderpassDepthStencilDescription new
		format: self preferredDepthStencilFormat;
		begin_action: AGPU_ATTACHMENT_CLEAR;
		end_action: AGPU_ATTACHMENT_KEEP;
		clear_value: (AGPUDepthStencilValue new depth: 0.0; stencil: 0; yourself);
		yourself.
		
	^ (WDCRenderPass for: self)
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		checkSession;
		yourself