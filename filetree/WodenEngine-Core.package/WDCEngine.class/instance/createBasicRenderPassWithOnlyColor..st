resource building
createBasicRenderPassWithOnlyColor: aColor
	| colorAttachments |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: aColor asAGPUColor4f;
			yourself
	}.
	^ (WDCRenderPass for: self)
		colorAttachments: colorAttachments;
		checkSession;
		yourself