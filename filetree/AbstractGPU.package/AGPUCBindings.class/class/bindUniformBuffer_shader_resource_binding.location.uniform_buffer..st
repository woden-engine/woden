shader_resource_binding
bindUniformBuffer_shader_resource_binding: shader_resource_binding location: location uniform_buffer: uniform_buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindUniformBuffer (agpu_shader_resource_binding* shader_resource_binding , agpu_int location , agpu_buffer* uniform_buffer) )
