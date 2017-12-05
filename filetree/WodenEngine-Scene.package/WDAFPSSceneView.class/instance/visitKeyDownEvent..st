visiting
visitKeyDownEvent: anEvent
	anEvent repeat > 0 ifTrue: [ ^ 0 ].
	anEvent symbol = OSK_F11 ifTrue: [ self toggleFullscreen ].

	anEvent symbol = OSK_a ifTrue: [ cameraVelocity x: -1.0 ].
	anEvent symbol = OSK_d ifTrue: [ cameraVelocity x: 1.0 ].
	anEvent symbol = OSK_w ifTrue: [ cameraVelocity z: -1.0 ].
	anEvent symbol = OSK_s ifTrue: [ cameraVelocity z: 1.0 ].
	anEvent symbol = OSK_LCTRL ifTrue: [ cameraVelocity y: -1.0 ].
	anEvent symbol = OSK_SPACE ifTrue: [ cameraVelocity y: 1.0 ].

	anEvent symbol = OSK_UP ifTrue: [ cameraAngularVelocity x: 1.0 ].
	anEvent symbol = OSK_DOWN ifTrue: [ cameraAngularVelocity x: -1.0 ].
	anEvent symbol = OSK_LEFT ifTrue: [ cameraAngularVelocity y: 1.0 ].
	anEvent symbol = OSK_RIGHT ifTrue: [ cameraAngularVelocity y: -1.0 ].
	
	anEvent symbol = OSK_LSHIFT ifTrue: [ cameraSpeed := 3.0 ].
	
	screenDisplayMode vrSensorReader ifNotNil: [ :sensor |
		anEvent symbol = OSK_1 ifTrue: [ sensor recenter ]. 
		anEvent symbol = OSK_2 ifTrue: [ sensor calibrate ].
	].
	
	(anEvent modifiers leftAlt and: [ anEvent symbol = OSK_i ]) ifTrue: [ self inspect ].