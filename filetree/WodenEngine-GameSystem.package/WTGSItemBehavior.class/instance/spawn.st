map events
spawn
	| mesh |
	mesh := self setMeshNamed: self modelName.
	self setBoundingBox: mesh boundingBox.
	
	self subscribeToTouchEvents.