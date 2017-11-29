event handling
onKeyDown: anEvent
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ velocityDirection x: -1.0 ].
	symbol = OSK_d ifTrue: [ velocityDirection x: 1.0 ].
	symbol = OSK_w ifTrue: [ velocityDirection z: -1.0 ].
	symbol = OSK_s ifTrue: [ velocityDirection z: 1.0 ].
	symbol = OSK_LCTRL ifTrue: [ velocityDirection y: -1.0 ].
	symbol = OSK_SPACE ifTrue: [ velocityDirection y: 1.0 ].

	symbol = OSK_UP ifTrue: [ angularVelocity x: 1.0 ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x: -1.0 ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y: 1.0 ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y: -1.0 ].
	
	symbol = OSK_LSHIFT ifTrue: [ speed := 3.0 ].
	
	(anEvent modifiers leftAlt and: [ symbol = OSK_i ]) ifTrue: [ self inspect ].