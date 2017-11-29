rendering
simulateTime: delta
	timeListeners do: [ :listener | listener simulateTime: delta ].
	self sendTouchEvents.