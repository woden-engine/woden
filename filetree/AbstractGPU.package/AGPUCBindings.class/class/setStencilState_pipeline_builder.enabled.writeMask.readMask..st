pipeline_builder
setStencilState_pipeline_builder: pipeline_builder enabled: enabled writeMask: writeMask readMask: readMask
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetStencilState (agpu_pipeline_builder* pipeline_builder , agpu_bool enabled , agpu_int writeMask , agpu_int readMask) )
