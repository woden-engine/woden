pipeline_state
getUniformLocation_pipeline_state: pipeline_state name: name
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_int agpuGetUniformLocation (agpu_pipeline_state* pipeline_state , agpu_cstring name) )
