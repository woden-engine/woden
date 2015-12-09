device
createPipelineBuilder_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_pipeline_builder* agpuCreatePipelineBuilder (agpu_device* device) )
