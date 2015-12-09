platform
getName_platform: platform
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_cstring agpuGetPlatformName (agpu_platform* platform) )
