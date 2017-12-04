event handling
modifiers: anEvent putOn: osEvent
	osEvent modifiers
		leftCtrl: anEvent controlKeyPressed;
		leftAlt: anEvent altKeyPressed;
		leftCmd: anEvent commandKeyPressed;
		leftShift: anEvent shiftPressed.
