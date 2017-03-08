as yet unclassified
allClasses
	" 
	self new allClasses
	"
	| view els elementClass |
	view := RWView new.
	els := RWCube elementsOn: Object withAllSubclasses.
	els do: [ :el |
		el when: RWMouseButtonDown do: [ :ev |
			elementClass := ev element model.
			self inform: 'Class ' , elementClass name.
			elementClass inspect.
			ev element  shape color: Color darkGray.
			ev element changed.
		]
	].
	view addAll: els.
	RWCubeLayout on: view elements.
	view @ RWMouseKeyControl.
	view open