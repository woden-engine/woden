wrappers
readTextureData: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch buffer: buffer
	| result |
	result := AGPUCBindings readTextureData_texture: (self validHandle) level: level arrayIndex: arrayIndex pitch: pitch slicePitch: slicePitch buffer: buffer.
	self checkErrorCode: result
