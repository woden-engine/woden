shader
setShaderSource_shader: shader language: language sourceText: sourceText sourceTextLength: sourceTextLength
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetShaderSource (agpu_shader* shader , agpu_shader_language language , agpu_string sourceText , agpu_string_length sourceTextLength) )
