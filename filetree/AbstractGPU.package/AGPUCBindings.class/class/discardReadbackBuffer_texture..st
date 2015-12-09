texture
discardReadbackBuffer_texture: texture
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuDiscardTextureReadbackBuffer (agpu_texture* texture) )
