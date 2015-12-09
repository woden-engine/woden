command_list
beginFrame_command_list: command_list framebuffer: framebuffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBeginFrame (agpu_command_list* command_list , agpu_framebuffer* framebuffer) )
