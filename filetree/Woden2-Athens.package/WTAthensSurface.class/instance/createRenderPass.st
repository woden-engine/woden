initialization
createRenderPass
	| colorAttachments depthStencilAttachment |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: colorBufferFormat;
			begin_action: AGPU_ATTACHMENT_KEEP;
			end_action: AGPU_ATTACHMENT_KEEP;
			yourself
	}.
	
	depthStencilAttachment := AGPURenderpassDepthStencilDescription new
		format: engine preferredDepthStencilFormat;
		begin_action: AGPU_ATTACHMENT_CLEAR;
		end_action: AGPU_ATTACHMENT_KEEP;
		clear_value: (AGPUDepthStencilValue new depth: 0.0; stencil: 0; yourself);
		yourself.
			
	renderPass := (WTRenderPass for: engine)
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		validHandle