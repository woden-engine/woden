event handling
onKeyUp: event
	| symbol velocity angularVelocity |
	symbol := event symbol.

	velocity := movement velocity.
	angularVelocity := movement angularVelocity.
	
	symbol == OSK_w ifTrue: [ velocity z < 0.0 ifTrue: [ velocity z: 0.0 ] . velocity z: 0.0 ].
	symbol == OSK_s ifTrue: [ velocity z > 0.0 ifTrue: [ velocity z: 0.0 ] . velocity z: 0.0 ].
	symbol == OSK_a ifTrue: [ velocity x < 0.0 ifTrue: [ velocity x: 0.0 ] . velocity x: 0.0 ].
	symbol == OSK_d ifTrue: [ velocity x > 0.0 ifTrue: [ velocity x: 0.0 ] . velocity x: 0.0 ].
	symbol == OSK_SPACE ifTrue: [ velocity y > 0.0 ifTrue: [ velocity y: 0.0 ] . velocity y: 0.0 ].
	symbol = OSK_LCTRL ifTrue: [ velocity y < 0.0 ifTrue: [ velocity y: 0.0 ] . velocity y: 0.0 ].
	
	symbol = OSK_LEFT ifTrue: [ angularVelocity y < 0.0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y > 0.0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_UP ifTrue: [ angularVelocity x < 0.0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x > 0.0 ifTrue: [ angularVelocity x: 0.0 ] ].
	
	"Use the same magnitude for the velocity."
	velocity length2 > 0.001 ifTrue: [ velocity := velocity normalized * self class velocityMagnitude ].
	
	"Update the velocity and the angular velocity."
	movement velocity: velocity;
		angularVelocity: angularVelocity