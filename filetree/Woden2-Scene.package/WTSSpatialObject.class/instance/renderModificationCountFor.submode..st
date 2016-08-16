accessing
renderModificationCountFor: mode submode: submode
	^ modificationCount + (renderable ifNil: [ 0 ] ifNotNil: [ renderable renderModificationCountFor: mode submode: submode ])