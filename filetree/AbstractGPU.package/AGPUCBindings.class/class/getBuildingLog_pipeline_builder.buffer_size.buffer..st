pipeline_builder
getBuildingLog_pipeline_builder: pipeline_builder buffer_size: buffer_size buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuGetPipelineBuildingLog (agpu_pipeline_builder* pipeline_builder , agpu_size buffer_size , agpu_string_buffer buffer) )
