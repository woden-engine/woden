pipeline_builder
setPrimitiveType_pipeline_builder: pipeline_builder type: type
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetPrimitiveType (agpu_pipeline_builder* pipeline_builder , agpu_primitive_type type) )
