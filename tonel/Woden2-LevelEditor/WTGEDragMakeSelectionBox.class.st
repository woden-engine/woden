Class {
	#name : #WTGEDragMakeSelectionBox,
	#superclass : #WTGEDragTool,
	#instVars : [
		'xdirection',
		'ydirection',
		'startPoint',
		'endPoint',
		'zdirection',
		'nearPosition',
		'farPosition'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGEDragMakeSelectionBox >> onDragEvent: event [
	| depth |
	depth := view depthAtCameraDistance: 3.0.
	endPoint := (view windowGlobalToWorld: event position depth: depth).
	self updateSelectionBox.
]

{ #category : #'as yet unclassified' }
WTGEDragMakeSelectionBox >> onDragStartEvent: event [
	| depth selectionBox |
	depth := view depthAtCameraDistance: 3.0.
	startPoint := (view windowGlobalToWorld: event position depth: depth).
	
	xdirection := view xDragDirection.
	ydirection := view yDragDirection.
	zdirection := view zDragDirection.
	selectionBox := view editor selectionBox.
	selectionBox isEmpty ifTrue: [
		nearPosition := -1.0.
		farPosition := 1.0.
	] ifFalse: [
		nearPosition := zdirection dot: (selectionBox box support: zdirection negated).
		farPosition := zdirection dot: (selectionBox box support: zdirection).
	].
	
	view editor selection: WTGLevelEditorSelectionBox empty.
]

{ #category : #'as yet unclassified' }
WTGEDragMakeSelectionBox >> updateSelectionBox [
	| leftPosition rightPosition bottomPosition topPosition near far min max box |
	leftPosition := xdirection dot: startPoint.
	rightPosition := xdirection dot: endPoint.
	bottomPosition := ydirection dot: startPoint.
	topPosition := ydirection dot: endPoint.
	near := nearPosition.
	far := farPosition.
	
	min := (xdirection * leftPosition) + (ydirection * bottomPosition) + (zdirection * near).
	max := (xdirection * rightPosition) + (ydirection * topPosition) + (zdirection * far).
	box := WMBox3DD empty
		insertPoint: min;
		insertPoint: max;
		yourself.
	self editor selectionBox box: (view snapBox: box).
]
