as yet unclassified
example02
	"
	self new example02
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: RTShape withAllSubclasses.
	d x: #numberOfVariables.
	d y: #numberOfMethods.
	d z: #numberOfLinesOfCode.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view
