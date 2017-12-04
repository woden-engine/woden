accessing
stateTracker
	^ stateTracker ifNil: [ stateTracker := WDCStateTracker for: engine ].