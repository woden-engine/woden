as yet unclassified
example03
	"
	self new example01
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: (0.0 to: 3.14 by: 0.1).
	d x: #sin.
	d y: #cos.
	d z: #yourself.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view
