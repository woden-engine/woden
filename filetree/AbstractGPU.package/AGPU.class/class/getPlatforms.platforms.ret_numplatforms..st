wrappers
getPlatforms: numplatforms platforms: platforms ret_numplatforms: ret_numplatforms
	| result |
	result := AGPUCBindings getPlatforms_numplatforms: numplatforms platforms: platforms ret_numplatforms: ret_numplatforms.
	self checkErrorCode: result
