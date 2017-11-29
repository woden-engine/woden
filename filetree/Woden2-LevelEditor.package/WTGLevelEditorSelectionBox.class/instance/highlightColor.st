accessing
highlightColor
	^ self isSpaceSelection ifTrue: [ SpaceSelectionHighlightColor ] ifFalse: [ ElementSelectionHighlightColor ]