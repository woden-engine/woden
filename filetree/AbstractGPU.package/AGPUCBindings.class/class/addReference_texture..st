texture
addReference_texture: texture
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddTextureReference (agpu_texture* texture) )
