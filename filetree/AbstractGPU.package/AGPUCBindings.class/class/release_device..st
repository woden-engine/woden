device
release_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseDevice (agpu_device* device) )
