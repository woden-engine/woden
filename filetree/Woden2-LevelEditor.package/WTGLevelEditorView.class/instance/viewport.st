as yet unclassified
viewport
	^ WTSViewport new
		bounds: self boundsInSpace;
		camera: camera;
		submode: renderMode;
		filter: [ :object | object model isNil or: [ object model == self ] ];
		yourself