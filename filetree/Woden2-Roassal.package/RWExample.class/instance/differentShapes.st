trees
differentShapes
	"
	self new differentShapes
	"
	| view  |
	view := RWView new.
	view addAll: ( RWCylinder elementsOn: (1 to: 4)).
	view addAll: ( RWCube elementsOn: (1 to: 4)).
	view addAll: ( RWUVSphere elementsOn: (1 to: 4)).
	view addAll: ( RWPyramid elementsOn: (1 to: 4)).

	RWXZGridLayout on: view elements.
	view @ RWMouseKeyControl .
	view open.