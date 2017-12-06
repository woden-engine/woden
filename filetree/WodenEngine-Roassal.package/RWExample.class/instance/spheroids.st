trees
spheroids
	"
	self new spheroids
	"
	| view shape |
	view := RWView new.
	shape := RWUVSphere new .
	shape width: [ :v | (v log + 1) ];
		height: [ :v | (v log + 2)];
		depth: [ :v | (v log + 3) ].

	view addAll: ( shape elementsOn: (1 to: 1000)).

	RWCubeLayout on: view elements.
	view @ RWMouseKeyControl .
	view open.