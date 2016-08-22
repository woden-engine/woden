event handling
onKeyUp: anEvent
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ velocityDirection x < 0 ifTrue: [ velocityDirection x: 0.0 ] ].
	symbol = OSK_d ifTrue: [ velocityDirection x > 0 ifTrue: [ velocityDirection x: 0.0 ] ].
	symbol = OSK_w ifTrue: [ velocityDirection z < 0 ifTrue: [ velocityDirection z: 0.0 ] ].
	symbol = OSK_s ifTrue: [ velocityDirection z > 0 ifTrue: [ velocityDirection z: 0.0 ] ].

	symbol = OSK_UP ifTrue: [ angularVelocity x > 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x < 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y > 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y < 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	
	symbol = OSK_LCTRL ifTrue: [ velocityDirection y < 0 ifTrue: [ velocityDirection y: 0.0 ] ].
	symbol = OSK_SPACE ifTrue: [ velocityDirection y > 0 ifTrue: [ velocityDirection y: 0.0 ] ].
	symbol = OSK_LSHIFT ifTrue: [ speed := 1.0 ].