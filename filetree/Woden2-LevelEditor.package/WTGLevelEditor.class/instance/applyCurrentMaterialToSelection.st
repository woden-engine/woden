actions
applyCurrentMaterialToSelection
	self flag: 'Add a memento or something for undo/redo'.
	selectionBox elements do: [ :element | element material: currentMaterialName ]