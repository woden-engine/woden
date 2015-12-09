shader
addReference_shader: shader
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderReference (agpu_shader* shader) )
