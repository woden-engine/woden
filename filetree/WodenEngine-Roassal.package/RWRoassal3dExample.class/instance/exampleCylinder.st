sources
exampleCylinder

	| v |
	v := RWView new.
	v add: RWCylinder element.
	v  @ RWMouseKeyControl.
	

^	 v