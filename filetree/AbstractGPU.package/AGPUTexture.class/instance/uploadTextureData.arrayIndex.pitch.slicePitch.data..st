wrappers
uploadTextureData: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch data: data
	| result |
	result := AGPUCBindings uploadTextureData_texture: (self validHandle) level: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch data: data.
	self checkErrorCode: result
