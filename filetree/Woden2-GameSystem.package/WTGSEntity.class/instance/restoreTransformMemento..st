memento
restoreTransformMemento: memento
	memento ifNil: [ ^ self ].
	self spatialDescription restoreTransformMemento: memento