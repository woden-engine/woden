texture
discardUploadBuffer_texture: texture
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuDiscardTextureUploadBuffer (agpu_texture* texture) )
