adding
addedToNode: newParentNode
	newParentNode scene ifNotNil: [ self addedToScene: newParentNode scene ].