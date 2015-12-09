wrappers
multiDrawElementsIndirect: offset drawcount: drawcount
	| result |
	result := AGPUCBindings multiDrawElementsIndirect_command_list: (self validHandle) offset: offset drawcount: drawcount.
	self checkErrorCode: result
