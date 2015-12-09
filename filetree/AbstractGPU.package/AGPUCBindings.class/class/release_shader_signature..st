shader_signature
release_shader_signature: shader_signature
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseShaderSignature (agpu_shader_signature* shader_signature) )
