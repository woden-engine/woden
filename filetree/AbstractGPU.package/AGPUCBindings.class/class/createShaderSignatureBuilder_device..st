device
createShaderSignatureBuilder_device: device
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_signature_builder* agpuCreateShaderSignatureBuilder (agpu_device* device) )
