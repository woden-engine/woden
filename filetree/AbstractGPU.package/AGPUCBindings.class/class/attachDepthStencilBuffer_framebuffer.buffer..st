framebuffer
attachDepthStencilBuffer_framebuffer: framebuffer buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAttachDepthStencilBuffer (agpu_framebuffer* framebuffer , agpu_texture* buffer) )
