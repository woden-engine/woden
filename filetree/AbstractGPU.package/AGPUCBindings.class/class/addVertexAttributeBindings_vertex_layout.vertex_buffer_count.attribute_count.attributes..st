vertex_layout
addVertexAttributeBindings_vertex_layout: vertex_layout vertex_buffer_count: vertex_buffer_count attribute_count: attribute_count attributes: attributes
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddVertexAttributeBindings (agpu_vertex_layout* vertex_layout , agpu_uint vertex_buffer_count , agpu_size attribute_count , agpu_vertex_attrib_description* attributes) )
