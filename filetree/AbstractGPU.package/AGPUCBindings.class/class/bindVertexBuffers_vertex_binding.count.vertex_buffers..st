vertex_binding
bindVertexBuffers_vertex_binding: vertex_binding count: count vertex_buffers: vertex_buffers
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindVertexBuffers (agpu_vertex_binding* vertex_binding , agpu_uint count , agpu_buffer** vertex_buffers) )
