framebuffer
release_framebuffer: framebuffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseFramebuffer (agpu_framebuffer* framebuffer) )
