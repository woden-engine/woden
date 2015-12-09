device
getPreferredShaderLanguage_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_language agpuGetPreferredShaderLanguage (agpu_device* device) )
