framebuffer
addReference_framebuffer: framebuffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddFramebufferReference (agpu_framebuffer* framebuffer) )
