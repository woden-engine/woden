actions
applyCurrentMaterialToSelection
	self flag: 'Add a memento or something for undo/redo'.
	selection elements do: [ :element | element material: currentMaterialName ]