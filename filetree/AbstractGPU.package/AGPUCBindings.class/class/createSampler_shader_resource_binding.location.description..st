shader_resource_binding
createSampler_shader_resource_binding: shader_resource_binding location: location description: description
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuCreateSampler (agpu_shader_resource_binding* shader_resource_binding , agpu_int location , agpu_sampler_description* description) )
