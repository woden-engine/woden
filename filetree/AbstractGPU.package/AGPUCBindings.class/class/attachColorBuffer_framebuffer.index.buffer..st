framebuffer
attachColorBuffer_framebuffer: framebuffer index: index buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAttachColorBuffer (agpu_framebuffer* framebuffer , agpu_int index , agpu_texture* buffer) )
