device
createVertexLayout_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_vertex_layout* agpuCreateVertexLayout (agpu_device* device) )
