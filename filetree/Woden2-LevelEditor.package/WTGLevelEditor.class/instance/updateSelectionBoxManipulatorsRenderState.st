rendering
updateSelectionBoxManipulatorsRenderState
	| node |
	selectionBoxManipulators doWithIndex: [ :box :index |
		node := selectionBoxManipulatorNodes at: index.
		node visible: box isEmpty not.
		node visible: true.
		
		"node visible ifTrue: [ node transform setForBox: box ]"
	]