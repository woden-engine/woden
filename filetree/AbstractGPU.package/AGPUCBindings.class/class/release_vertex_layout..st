vertex_layout
release_vertex_layout: vertex_layout
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseVertexLayout (agpu_vertex_layout* vertex_layout) )
