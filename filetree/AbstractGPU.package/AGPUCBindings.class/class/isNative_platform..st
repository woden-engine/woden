platform
isNative_platform: platform
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_bool agpuIsNativePlatform (agpu_platform* platform) )
