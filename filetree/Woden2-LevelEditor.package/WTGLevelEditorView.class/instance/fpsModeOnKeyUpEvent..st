event handling
fpsModeOnKeyUpEvent: anEvent
	| keyValue |
	keyValue := anEvent keyValue.
	keyValue = OSK_a ifTrue: [ cameraVelocity x < 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	keyValue = OSK_d ifTrue: [ cameraVelocity x > 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	keyValue = OSK_w ifTrue: [ cameraVelocity z < 0 ifTrue: [ cameraVelocity z: 0.0 ] ].
	keyValue = OSK_s ifTrue: [ cameraVelocity z > 0 ifTrue: [ cameraVelocity z: 0.0 ] ].

	keyValue = OSK_UP ifTrue: [ cameraAngularVelocity x > 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	keyValue = OSK_DOWN ifTrue: [ cameraAngularVelocity x < 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	keyValue = OSK_LEFT ifTrue: [ cameraAngularVelocity y > 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	keyValue = OSK_RIGHT ifTrue: [ cameraAngularVelocity y < 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	
	keyValue = OSK_LCTRL ifTrue: [ cameraVelocity y < 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	keyValue = OSK_SPACE ifTrue: [ cameraVelocity y > 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	keyValue = OSK_LSHIFT ifTrue: [ cameraSpeed := 1.0 ].