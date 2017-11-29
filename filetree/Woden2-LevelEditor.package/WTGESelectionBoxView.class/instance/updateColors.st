rendering
updateColors
	| selectionBox |
	selectionBox := editor selectionBox.
	node color: selectionBox color.
	manipulatorNodes doWithIndex: [ :box :index |
		box color: (index = mouseOverIndex ifTrue: [ selectionBox highlightColor ] ifFalse: [ selectionBox color ])  
	]