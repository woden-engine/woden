rendering
render2DOnSurface: athensSurface canvas: canvas
	trachelCanvas ifNil: [ ^ self ].
	
	"We display the elements that are subject to the camera"
	canvas pathTransform
		translateBy: (athensSurface extent / 2) asFloatPoint;
		    scaleBy: trachelCanvas camera scale asFloat;
		translateBy: trachelCanvas camera position negated asFloatPoint.
	trachelCanvas shapes do: [ :trachelShape |
		trachelShape drawOn: canvas.
	].
	
	"We display the elements that are _NOT_ subject to the camera"
	canvas pathTransform loadIdentity scaleBy: 1.001.
		trachelCanvas fixedShapes do: [ :trachelShape |
		trachelShape drawOn: canvas.
	].