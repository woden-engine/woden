as yet unclassified
view: view selectSingleOnEditor: editor
	((view isPerspective and: [ direction closeTo: WMVector3D new ]) or:
	[view isPerspective not and: [ (direction * view xyDragDirection) closeTo: WMVector3D new ] ])
	ifTrue: [
		editor selectionBox toggleManipulationMode
	]