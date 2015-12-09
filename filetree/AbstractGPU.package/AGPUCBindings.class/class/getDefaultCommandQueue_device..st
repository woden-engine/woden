device
getDefaultCommandQueue_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_command_queue* agpuGetDefaultCommandQueue (agpu_device* device) )
