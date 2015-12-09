shader
bindAttributeLocation_shader: shader name: name location: location
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindAttributeLocation (agpu_shader* shader , agpu_cstring name , agpu_int location) )
