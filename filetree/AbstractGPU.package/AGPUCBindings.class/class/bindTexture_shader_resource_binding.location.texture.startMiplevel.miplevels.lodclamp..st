shader_resource_binding
bindTexture_shader_resource_binding: shader_resource_binding location: location texture: texture startMiplevel: startMiplevel miplevels: miplevels lodclamp: lodclamp
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuBindTexture (agpu_shader_resource_binding* shader_resource_binding , agpu_int location , agpu_texture* texture , agpu_uint startMiplevel , agpu_int miplevels , agpu_float lodclamp) )
