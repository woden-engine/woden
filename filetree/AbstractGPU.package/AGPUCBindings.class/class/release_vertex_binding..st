vertex_binding
release_vertex_binding: vertex_binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseVertexBinding (agpu_vertex_binding* vertex_binding) )
