sources
exampleCircle

	| v  |
	v := RWView new.
	1 to: 10 do: [ :i |
		v add: RWCube element.
	].

	RWCircleLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	
^ v