changing
stateChanged
	stateChangeListeners ifNotNil: [ stateChangeListeners do: [ :handler | handler value: self ] ].