shader
release_shader: shader
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseShader (agpu_shader* shader) )
