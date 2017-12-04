changing
onStateChangeDo: aBlock
	stateChangeListeners := stateChangeListeners
		ifNil: [ { aBlock } ]
		ifNotNil: [ stateChangeListeners , { aBlock } ]
	