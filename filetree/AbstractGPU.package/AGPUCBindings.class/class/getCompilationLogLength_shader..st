shader
getCompilationLogLength_shader: shader
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_size agpuGetShaderCompilationLogLength (agpu_shader* shader) )
