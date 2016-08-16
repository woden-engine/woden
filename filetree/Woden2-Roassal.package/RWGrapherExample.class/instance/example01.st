as yet unclassified
example01
	"
	self new example01
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: #(#(10 0 0) #(0 10 0) #(0 0 10) #(0 0 0)).
	d x: #first.
	d y: #second.
	d z: #third.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view
