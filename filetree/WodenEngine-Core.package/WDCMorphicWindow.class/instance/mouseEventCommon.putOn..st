event handling
mouseEventCommon: anEvent putOn: osEvent
	osEvent buttons
			button1: anEvent redButtonPressed;
			button2: anEvent yellowButtonPressed;
			button3: anEvent blueButtonPressed.
	self modifiers: anEvent putOn: osEvent.
	self mousePosition: anEvent putOn: osEvent.