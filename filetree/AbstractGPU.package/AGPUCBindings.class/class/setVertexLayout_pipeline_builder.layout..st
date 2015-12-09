pipeline_builder
setVertexLayout_pipeline_builder: pipeline_builder layout: layout
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetVertexLayout (agpu_pipeline_builder* pipeline_builder , agpu_vertex_layout* layout) )
