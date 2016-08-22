as yet unclassified
visitKeyDownEvent: anEvent
	anEvent symbol = OSK_ESCAPE ifTrue: [ self close ]