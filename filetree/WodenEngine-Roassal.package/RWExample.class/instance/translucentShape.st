trees
translucentShape
	"
	self new translucentShape open
	"
	| view translucentShape opaqueShape elements |
	view := RWView new.

	"This requires a black background"
	view blackBackground.

	translucentShape := RWCube blue translucent.
	opaqueShape := RWCube red.

	elements := (translucentShape elementsOn: (1 to: 30)) , (opaqueShape elementsOn: (1 to: 30)).

	RWCubeLayout on: elements.
	view addAll: elements.
	view addInteraction: RWMouseKeyControl.
	^ view