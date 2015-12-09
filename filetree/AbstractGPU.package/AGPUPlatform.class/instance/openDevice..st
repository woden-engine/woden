wrappers
openDevice: openInfo
	| result |
	result := AGPUCBindings openDevice_platform: (self validHandle) openInfo: openInfo.
	^ AGPUDevice forHandle: result
