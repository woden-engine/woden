vertex_binding
addReference_vertex_binding: vertex_binding
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddVertexBindingReference (agpu_vertex_binding* vertex_binding) )
