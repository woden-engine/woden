device
getPreferredHighLevelShaderLanguage_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_language agpuGetPreferredHighLevelShaderLanguage (agpu_device* device) )
