event handling
onKeyDownEvent: anEvent
	| keyValue |
	keyValue := anEvent keyValue.
	keyValue = OSK_a ifTrue: [ cameraVelocity x: -1.0 ].
	keyValue = OSK_d ifTrue: [ cameraVelocity x: 1.0 ].
	keyValue = OSK_w ifTrue: [ cameraVelocity z: -1.0 ].
	keyValue = OSK_s ifTrue: [ cameraVelocity z: 1.0 ].
	keyValue = OSK_LCTRL ifTrue: [ cameraVelocity y: -1.0 ].
	keyValue = OSK_SPACE ifTrue: [ cameraVelocity y: 1.0 ].

	keyValue = OSK_UP ifTrue: [ cameraAngularVelocity x: 1.0 ].
	keyValue = OSK_DOWN ifTrue: [ cameraAngularVelocity x: -1.0 ].
	keyValue = OSK_LEFT ifTrue: [ cameraAngularVelocity y: 1.0 ].
	keyValue = OSK_RIGHT ifTrue: [ cameraAngularVelocity y: -1.0 ].
	
	keyValue = OSK_LSHIFT ifTrue: [ cameraSpeed := 3.0 ].
	
	((anEvent buttons anyMask: 2r01000000) and: [ keyValue = OSK_i ]) ifTrue: [ self inspect ].