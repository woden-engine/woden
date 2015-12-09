shader
compileShader_shader: shader options: options
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuCompileShader (agpu_shader* shader , agpu_cstring options) )
