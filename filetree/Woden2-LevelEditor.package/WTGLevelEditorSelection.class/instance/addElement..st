adding
addElement: anElement
	editor ifNotNil: [
		lastElement ifNotNil: [ lastElement lastSelected: false].		
		anElement selected: true; lastSelected: true
	].

	elements add: anElement.
	lastElement := anElement.
	editor ifNotNil: [ editor selectionChanged ].