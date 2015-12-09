vertex_layout
addReference_vertex_layout: vertex_layout
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddVertexLayoutReference (agpu_vertex_layout* vertex_layout) )
