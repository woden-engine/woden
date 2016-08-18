adding
removeElement: anElement
	editor ifNotNil: [ anElement selected: false; lastSelected: false. ].
	elements remove: anElement.
	elements ifEmpty: [
		lastElement := nil
	] ifNotEmpty: [
		lastElement == anElement ifTrue: [
			lastElement := elements anyOne.
			lastElement lastSelected: true.
		].
	].
	
	editor ifNotNil: [ editor selectionChanged ].
	