as yet unclassified
onKeyDown: anEvent
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ linearVelocity x: -1.0 ].
	symbol = OSK_d ifTrue: [ linearVelocity x: 1.0 ].
	symbol = OSK_w ifTrue: [ linearVelocity z: -1.0 ].
	symbol = OSK_s ifTrue: [ linearVelocity z: 1.0 ].
	symbol = OSK_LCTRL ifTrue: [ linearVelocity y: -1.0 ].
	symbol = OSK_SPACE ifTrue: [ linearVelocity y: 1.0 ].

	symbol = OSK_UP ifTrue: [ angularVelocity x: 1.0 ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x: -1.0 ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y: 1.0 ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y: -1.0 ].
	
	symbol = OSK_LSHIFT ifTrue: [ speed := 3.0 ].
	linearVelocity := linearVelocity normalized * speed.
	
	(anEvent modifiers leftAlt and: [ symbol = OSK_i ]) ifTrue: [ self inspect ].