event handling
onMouseMoveEvent: anEvent
	| element |
	self updateCameraProjection.
	element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: editor.
	element
		ifNil: [ editor mouseOverNone ]
		ifNotNil: [ element view: self mouseOver: anEvent ]