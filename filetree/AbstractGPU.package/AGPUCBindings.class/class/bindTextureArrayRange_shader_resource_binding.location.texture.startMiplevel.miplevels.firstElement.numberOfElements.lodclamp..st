shader_resource_binding
bindTextureArrayRange_shader_resource_binding: shader_resource_binding location: location texture: texture startMiplevel: startMiplevel miplevels: miplevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodclamp
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindTextureArrayRange (agpu_shader_resource_binding* shader_resource_binding , agpu_int location , agpu_texture* texture , agpu_uint startMiplevel , agpu_int miplevels , agpu_int firstElement , agpu_int numberOfElements , agpu_float lodclamp) )
