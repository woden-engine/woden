platform
hasRealMultithreading_platform: platform
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_bool agpuPlatformHasRealMultithreading (agpu_platform* platform) )
