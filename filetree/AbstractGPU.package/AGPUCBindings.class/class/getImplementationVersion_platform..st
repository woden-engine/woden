platform
getImplementationVersion_platform: platform
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_int agpuGetPlatformImplementationVersion (agpu_platform* platform) )
