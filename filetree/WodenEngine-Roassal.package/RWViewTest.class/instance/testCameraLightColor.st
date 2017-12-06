tests
testCameraLightColor
	self assert: (view cameraLightColor closeTo: Color lightGray).
	view cameraLightColor: Color red.
	self assert: (view cameraLightColor closeTo: Color red).
	