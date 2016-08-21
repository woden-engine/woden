as yet unclassified
onKeyUp: anEvent
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ linearVelocity x < 0 ifTrue: [ linearVelocity x: 0.0 ] ].
	symbol = OSK_d ifTrue: [ linearVelocity x > 0 ifTrue: [ linearVelocity x: 0.0 ] ].
	symbol = OSK_w ifTrue: [ linearVelocity z < 0 ifTrue: [ linearVelocity z: 0.0 ] ].
	symbol = OSK_s ifTrue: [ linearVelocity z > 0 ifTrue: [ linearVelocity z: 0.0 ] ].

	symbol = OSK_UP ifTrue: [ angularVelocity x > 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x < 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y > 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y < 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	
	symbol = OSK_LCTRL ifTrue: [ linearVelocity y < 0 ifTrue: [ linearVelocity y: 0.0 ] ].
	symbol = OSK_SPACE ifTrue: [ linearVelocity y > 0 ifTrue: [ linearVelocity y: 0.0 ] ].
	symbol = OSK_LSHIFT ifTrue: [ speed := 1.0 ].
	
	linearVelocity := linearVelocity normalized * speed.