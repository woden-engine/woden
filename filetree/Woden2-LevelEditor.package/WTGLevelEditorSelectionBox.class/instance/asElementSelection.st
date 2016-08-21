converting
asElementSelection
	^ WTGLevelEditorSelection new
		addAllElements: elements;
		lastElement: lastElement;
		yourself