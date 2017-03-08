sources
exampleIncreasingCubeSize

| e v |
v := RWView new.

e := RWCube element.

v add: e.

e when: RWMouseButtonDown do: [ :evt | 
	evt element shape width: 2.
	evt element shape height: 2.
	evt element shape color: Color green.
	
	e changed.
].
^	 v