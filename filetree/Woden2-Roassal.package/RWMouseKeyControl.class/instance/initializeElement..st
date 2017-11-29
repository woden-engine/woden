hooks
initializeElement: aView
	movement := RWForwardMovement new.
	aView camera addBehavior: movement.
	
	aView when: RWKeyDown do: [ :evt |
		self onKeyDown: evt.
	].
	aView when: RWKeyUp do: [ :evt |
		self onKeyUp: evt.
	].
	aView when: RWMouseDrag do: [ :evt |
		evt isLeftButton ifTrue: [ self onMouseDrag: evt ].
	].
	aView when: RWJoyAxis do: [ :evt |
		self onJoyAxis: evt.
	].
