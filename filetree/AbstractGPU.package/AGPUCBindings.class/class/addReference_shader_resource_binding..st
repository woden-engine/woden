shader_resource_binding
addReference_shader_resource_binding: shader_resource_binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderResourceBindingReference (agpu_shader_resource_binding* shader_resource_binding) )
