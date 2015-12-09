texture
readTextureLevel_texture: texture level: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch data: data
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReadTextureData (agpu_texture* texture , agpu_int level , agpu_int arrayIndex , agpu_int pitch , agpu_int slicePitch , agpu_pointer data) )
