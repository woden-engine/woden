as yet unclassified
visitKeyDownEvent: anEvent
	anEvent symbol = OSK_ESCAPE ifTrue: [ self close ].
	anEvent symbol = OSK_F1 ifTrue: [ self releaseMouse ].
	anEvent symbol = OSK_F2 ifTrue: [ self captureMouse ].