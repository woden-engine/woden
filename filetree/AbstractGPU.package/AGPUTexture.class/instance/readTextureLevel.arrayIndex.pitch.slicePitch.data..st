wrappers
readTextureLevel: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch data: data
	| result |
	result := AGPUCBindings readTextureLevel_texture: (self validHandle) level: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch data: data.
	self checkErrorCode: result
