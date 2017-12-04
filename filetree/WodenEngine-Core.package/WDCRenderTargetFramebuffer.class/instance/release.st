dependencies
release
	handle ifNotNil: [ handle release. handle := nil. ].
	colorAttachments ifNotNil: [ colorAttachments do: #release. colorAttachments ].
	depthStencilAttachment ifNotNil: [ depthStencilAttachment release . depthStencilAttachment ].
	
