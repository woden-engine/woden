shader_resource_binding
bindUniformBufferRange_shader_resource_binding: shader_resource_binding location: location uniform_buffer: uniform_buffer offset: offset size: size
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindUniformBufferRange (agpu_shader_resource_binding* shader_resource_binding , agpu_int location , agpu_buffer* uniform_buffer , agpu_size offset , agpu_size size) )
