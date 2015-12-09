pipeline_builder
getBuildingLogLength_pipeline_builder: pipeline_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_size agpuGetPipelineBuildingLogLength (agpu_pipeline_builder* pipeline_builder) )
