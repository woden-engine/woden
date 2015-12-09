texture
getDescription_texture: texture description: description
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuGetTextureDescription (agpu_texture* texture , agpu_texture_description* description) )
