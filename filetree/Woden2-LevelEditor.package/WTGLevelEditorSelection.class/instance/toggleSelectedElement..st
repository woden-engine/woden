adding
toggleSelectedElement: anElement
	(elements includes: anElement)
		ifTrue: [ self removeElement: anElement ]
		ifFalse: [ self addElement: anElement ]