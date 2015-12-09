device
createFence_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_fence* agpuCreateFence (agpu_device* device) )
