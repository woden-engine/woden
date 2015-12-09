shader
getCompilationLog_shader: shader buffer_size: buffer_size buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuGetShaderCompilationLog (agpu_shader* shader , agpu_size buffer_size , agpu_string_buffer buffer) )
