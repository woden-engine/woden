adding
addElement: anElement
	editor ifNotNil: [
		elements ifNotEmpty: [ elements last lastSelected: false ].
		anElement selected: true; lastSelected: true
	].

	elements add: anElement.
