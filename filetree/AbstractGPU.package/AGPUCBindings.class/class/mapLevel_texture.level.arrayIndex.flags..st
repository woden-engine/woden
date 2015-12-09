texture
mapLevel_texture: texture level: level arrayIndex: arrayIndex flags: flags
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_pointer agpuMapTextureLevel (agpu_texture* texture , agpu_int level , agpu_int arrayIndex , agpu_mapping_access flags) )
