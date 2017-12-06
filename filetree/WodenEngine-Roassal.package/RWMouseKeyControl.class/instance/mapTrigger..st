event handling
mapTrigger: value
	| newValue |
	newValue := value / 32768.0.
	newValue < 0.2 ifTrue: [ ^ 0.0 ].
	^ newValue