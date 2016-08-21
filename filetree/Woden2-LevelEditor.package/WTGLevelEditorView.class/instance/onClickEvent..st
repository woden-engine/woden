event handling
onClickEvent: anEvent
	| elements currentElement |
	anEvent position = lastDragEndPosition ifTrue: [ 
		lastDragEndPosition := nil.
		^ self
	].

	elements := (self findElementsAtGlobalCoord: anEvent position) collect: #value.
	
	elements ifNotEmpty: [
		lastClickElements = elements ifTrue: [
			(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [ 
				nextClickElementIndex := (nextClickElementIndex + 1) % lastClickElements size
			].
		] ifFalse: [ 
			nextClickElementIndex := 0
		].

		lastClickElements := elements.		
		currentElement := elements at: nextClickElementIndex + 1.
	].

	currentElement := currentElement asNodeModelForLevelEditor: editor.
	currentElement ifNotNil: [
		(anEvent modifiers isCtrl and: [ anEvent modifiers isShift not ]) ifTrue: [
			currentElement view: self selectToggleOnEditor: editor
		].
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift ]) ifTrue: [
			currentElement view: self selectAddOnEditor: editor
		].
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [
			currentElement view: self selectSingleOnEditor: editor
		]
	] ifNil: [
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [ 
			editor clearSelection
		]
	]