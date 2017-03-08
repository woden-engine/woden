sources
exampleRedLight

	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWPointLight new color: Color red).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.

^	 v