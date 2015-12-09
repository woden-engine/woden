shader_signature
createShaderResourceBinding_shader_signature: shader_signature element: element
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_resource_binding* agpuCreateShaderResourceBinding (agpu_shader_signature* shader_signature , agpu_uint element) )
