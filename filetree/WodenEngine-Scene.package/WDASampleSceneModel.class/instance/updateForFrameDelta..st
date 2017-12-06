rendering process stages
updateForFrameDelta: delta.
	super updateForFrameDelta: delta.
	deltaTimeBlock ifNotNil: [ deltaTimeBlock value: delta ]