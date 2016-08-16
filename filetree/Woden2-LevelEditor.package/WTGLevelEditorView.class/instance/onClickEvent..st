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
			nextClickElementIndex := (nextClickElementIndex + 1) % lastClickElements size
		] ifFalse: [ 
			nextClickElementIndex := 0
		].
		lastClickElements := elements.
		
		currentElement := elements at: nextClickElementIndex + 1.
	].

	currentElement := currentElement asNodeModelForLevelEditor: editor.
	currentElement
		ifNotNil: [ currentElement selectSingleOnEditor: editor ]
		ifNil: [ editor selectionBox: WTGLevelEditorSelectionBox empty ]