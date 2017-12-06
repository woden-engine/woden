trees
translucentAlphaOverShape
	"
	self new translucentAlphaOverShape open
	"
	| view translucentShape opaqueShape elements |
	view := RWView new.

	translucentShape := 
		RWCube new
			color: (Color blue alpha: 0.8);
			alphaOverTranslucent.
	opaqueShape := RWCube red.

	elements := (translucentShape elementsOn: (1 to: 30)) , (opaqueShape elementsOn: (1 to: 30)).

	RWCubeLayout on: elements.
	view addAll: elements.
	view addInteraction: RWMouseKeyControl.
	^ view