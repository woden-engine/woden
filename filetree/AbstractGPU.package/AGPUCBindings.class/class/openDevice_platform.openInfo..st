platform
openDevice_platform: platform openInfo: openInfo
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_device* agpuOpenDevice (agpu_platform* platform , agpu_device_open_info* openInfo) )
