device
createTexture_device: device description: description initialData: initialData
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_texture* agpuCreateTexture (agpu_device* device , agpu_texture_description* description , agpu_pointer initialData) )
