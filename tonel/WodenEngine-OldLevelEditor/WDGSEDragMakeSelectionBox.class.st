Class {
	#name : #WDGSEDragMakeSelectionBox,
	#superclass : #WDGSEDragTool,
	#instVars : [
		'xdirection',
		'ydirection',
		'startPoint',
		'endPoint',
		'zdirection',
		'nearPosition',
		'farPosition'
	],
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #events }
WDGSEDragMakeSelectionBox >> onDragEvent: event [
	| depth |
	depth := view depthAtCameraDistance: 3.0.
	endPoint := (view windowGlobalToWorld: event position depth: depth).
	self updateSelectionBox.
]

{ #category : #events }
WDGSEDragMakeSelectionBox >> onDragStartEvent: event [
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

	Transcript show: startPoint; show: nearPosition; space; show: farPosition; cr.
	
	view editor selection: WDGSLevelEditorSelectionBox empty.
]

{ #category : #'as yet unclassified' }
WDGSEDragMakeSelectionBox >> updateSelectionBox [
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
