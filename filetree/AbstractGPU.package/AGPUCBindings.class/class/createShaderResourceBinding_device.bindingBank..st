device
createShaderResourceBinding_device: device bindingBank: bindingBank
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_resource_binding* agpuCreateShaderResourceBinding (agpu_device* device , agpu_int bindingBank) )
