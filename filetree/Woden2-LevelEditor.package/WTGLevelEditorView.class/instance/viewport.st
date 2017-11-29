accessing
viewport
	^ WTSViewport new
		bounds: self innerBoundsInSpace;
		camera: camera;
		submode: renderMode;
		filter: [ :object | object model isNil or: [ object model visibleForView: self ] ];
		yourself