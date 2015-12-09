device
createVertexBinding_device: device layout: layout
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_vertex_binding* agpuCreateVertexBinding (agpu_device* device , agpu_vertex_layout* layout) )
