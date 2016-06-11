as yet unclassified
visitKeyUpEvent: anEvent
	anEvent symbol = OSK_a ifTrue: [ cameraVelocity x < 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	anEvent symbol = OSK_d ifTrue: [ cameraVelocity x > 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	anEvent symbol = OSK_w ifTrue: [ cameraVelocity z < 0 ifTrue: [ cameraVelocity z: 0.0 ] ].
	anEvent symbol = OSK_s ifTrue: [ cameraVelocity z > 0 ifTrue: [ cameraVelocity z: 0.0 ] ].
	anEvent symbol = OSK_LCTRL ifTrue: [ cameraVelocity y < 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	anEvent symbol = OSK_SPACE ifTrue: [ cameraVelocity y > 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	anEvent symbol = OSK_LSHIFT ifTrue: [ cameraSpeed := 1.0 ].