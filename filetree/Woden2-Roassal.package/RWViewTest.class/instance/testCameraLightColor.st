tests
testCameraLightColor
	self assert: (view cameraLightColor closeTo: WDColor lightGray).
	view cameraLightColor: WDColor red.
	self assert: (view cameraLightColor closeTo: WDColor red).
	