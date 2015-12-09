pipeline_builder
setDepthState_pipeline_builder: pipeline_builder enabled: enabled writeMask: writeMask function: function
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetDepthState (agpu_pipeline_builder* pipeline_builder , agpu_bool enabled , agpu_bool writeMask , agpu_compare_function function) )
