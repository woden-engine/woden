adding
addAllElements: aCollection
	aCollection do: [ :element | self addElement: element ]