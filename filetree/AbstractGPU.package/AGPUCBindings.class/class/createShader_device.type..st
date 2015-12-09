device
createShader_device: device type: type
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader* agpuCreateShader (agpu_device* device , agpu_shader_type type) )
