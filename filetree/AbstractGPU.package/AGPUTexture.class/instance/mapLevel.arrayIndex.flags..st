wrappers
mapLevel: level arrayIndex: arrayIndex flags: flags
	| result |
	result := AGPUCBindings mapLevel_texture: (self validHandle) level: level arrayIndex: arrayIndex flags: flags.
	^ result
