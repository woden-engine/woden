texture
release_texture: texture
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseTexture (agpu_texture* texture) )
