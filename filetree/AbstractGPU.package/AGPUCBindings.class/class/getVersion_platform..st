platform
getVersion_platform: platform
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_int agpuGetPlatformVersion (agpu_platform* platform) )
