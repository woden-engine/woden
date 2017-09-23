resource building
buildHandle
	| colorAttachmentBuffer colorAttachmentSize depthStencilAttachmentBuffer description |
	colorAttachmentBuffer := nil.
	depthStencilAttachmentBuffer := nil.
	colorAttachments ifNotEmpty: [
		colorAttachmentSize := AGPURenderpassColorAttachmentDescription structureSize.
		colorAttachmentBuffer := ExternalAddress allocate: colorAttachmentSize * colorAttachments size.
	].

	[
		"Copy the color attachments to the buffer"
		1 to: colorAttachments size do: [ :i |
			LibC memCopy: (colorAttachments at: i) getHandle to: colorAttachmentBuffer + ((i - 1) * colorAttachmentSize) size: colorAttachmentSize
		].
	
		depthStencilAttachment ifNotNil: [
			depthStencilAttachmentBuffer := ExternalAddress allocate: AGPURenderpassDepthStencilDescription structureSize.
			LibC memCopy: depthStencilAttachment getHandle to: depthStencilAttachmentBuffer size: AGPURenderpassDepthStencilDescription structureSize.
		].
		
		description :=
			AGPURenderpassDescription new
			color_attachment_count: colorAttachments size;
			color_attachments: (AGPURenderpassColorAttachmentDescription fromHandle: colorAttachmentBuffer);
			yourself.
		depthStencilAttachment ifNotNil: [ 
			description depth_stencil_attachment: (AGPURenderpassDepthStencilDescription fromHandle: depthStencilAttachmentBuffer).
		].
		handle := engine device createRenderPass: description.
	] ensure: [
		colorAttachmentBuffer ifNotNil: [ colorAttachmentBuffer free ].
		depthStencilAttachmentBuffer ifNotNil: [ depthStencilAttachmentBuffer free ]
	].