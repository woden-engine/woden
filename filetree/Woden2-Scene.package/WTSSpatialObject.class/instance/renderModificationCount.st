accessing
renderModificationCount
	^ renderable ifNil: [ 0 ] ifNotNil: [ renderable modificationCount ]