accessing
color
	^ self isSpaceSelection ifTrue: [ SpaceSelectionColor ] ifFalse: [ ElementSelectionColor ]