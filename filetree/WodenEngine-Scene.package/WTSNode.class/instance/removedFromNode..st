adding
removedFromNode: oldParentNode
	scene ifNotNil: [ self removedFromScene: scene ].
	parent := nil.