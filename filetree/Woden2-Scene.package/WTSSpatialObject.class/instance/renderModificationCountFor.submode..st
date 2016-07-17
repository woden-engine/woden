accessing
renderModificationCountFor: mode submode: submode
	^ renderable ifNil: [ 0 ] ifNotNil: [ renderable renderModificationCountFor: mode submode: submode ]