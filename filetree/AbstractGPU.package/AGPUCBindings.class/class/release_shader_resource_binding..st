shader_resource_binding
release_shader_resource_binding: shader_resource_binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseShaderResourceBinding (agpu_shader_resource_binding* shader_resource_binding) )
