initialization
createRenderPassWithColor: aColor
	| colorAttachment depthStencilAttachment renderpassDescription |
	colorAttachment := nil.
	depthStencilAttachment := nil.
	
	[
		colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
		colorAttachment
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: aColor asAGPUColor4f.
		
		depthStencilAttachment := AGPURenderpassDepthStencilDescription externalNew.
		depthStencilAttachment
			format: AGPU_TEXTURE_FORMAT_D24_UNORM_S8_UINT;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: (AGPUDepthStencilValue new depth: 1.0; stencil: 0; yourself).
		
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment;
			depth_stencil_attachment: depthStencilAttachment.
		^ engine device createRenderPass: renderpassDescription.
	] ensure: [
		colorAttachment ifNotNil: [ colorAttachment free ].
		depthStencilAttachment ifNotNil: [ depthStencilAttachment free ].
	]