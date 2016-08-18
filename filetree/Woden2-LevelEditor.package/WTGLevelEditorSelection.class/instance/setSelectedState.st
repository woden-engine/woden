as yet unclassified
setSelectedState
	elements ifEmpty: [ ^ true ].
	elements do: [ :element | element selected: true ].
	lastElement lastSelected: true.