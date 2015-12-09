shader_signature
addReference_shader_signature: shader_signature
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderSignature (agpu_shader_signature* shader_signature) )
