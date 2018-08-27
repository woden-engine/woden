Class {
	#name : #WDGSLevelEditorBoxManipulator,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'boxIndex',
		'direction',
		'node'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> boxIndex [
	^ boxIndex
]

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> boxIndex: anObject [
	boxIndex := anObject
]

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> direction [
	^ direction
]

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> direction: anObject [
	direction := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBoxManipulator >> expand: actualExpansion direction: expandDirection box: oldBox [

	| left right bottom top near far |
	
	left := oldBox min x.
	right := oldBox max x.
	
	bottom := oldBox min y.
	top := oldBox max y.
	
	near := oldBox min z.
	far := oldBox max z.
	
	(expandDirection x closeTo: 0.0) ifFalse: [ 
		expandDirection x > 0.0
			ifTrue: [ right := right + actualExpansion x ]
			ifFalse: [ left := left - actualExpansion x ]
	].

	(expandDirection y closeTo: 0.0) ifFalse: [ 
		expandDirection y > 0.0
			ifTrue: [ top := top + actualExpansion y ]
			ifFalse: [ bottom := bottom - actualExpansion y ]
	].

	(expandDirection z closeTo: 0.0) ifFalse: [ 
		expandDirection z > 0.0
			ifTrue: [ far := far + actualExpansion z ]
			ifFalse: [ near := near - actualExpansion z ]
	].

	^ WMBox3DD 
		nx: (left min: right) ny: (bottom min: top) nz: (near min: far)
		px: (left max: right) py: (bottom max: top) pz: (near max: far)
]

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> node [
	^ node
]

{ #category : #accessing }
WDGSLevelEditorBoxManipulator >> node: anObject [
	node := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBoxManipulator >> view: view dragControllerFor: anEvent [
	| oldBox actualExpansion expandedBox forward isBoxTranslation fullTranslation expandDirection memento pivot transformation |
	oldBox := view editor selectionBox box copy.
	forward := view cameraTransform matrix thirdColumn negated.
	isBoxTranslation := (direction closeTo: forward) or:
		[ (direction closeTo: forward negated) or:
		[ direction closeTo: WMVector3D new] ].
	fullTranslation := WMVector3D new.
	expandDirection := WMVector3D x: direction x sign asFloat y: direction y sign asFloat z: direction z sign asFloat.

	memento := view editor selectionBox transformMemento.
	(isBoxTranslation not and: [ view editor selectionBox rotationMode ]) ifTrue: [
		pivot := oldBox center.
		^ WDGSEDragRotate new
			pivotPoint: (view worldToWindow: pivot);
			onNewRotation: [ :rotation |
				view editor selection restoreTransformMemento: memento.
				view editor selection rotate: rotation axis: forward pivot: pivot.
			]
	].

	^ WDGSEDragTranslate new
		depthPoint: node transform translation;
		onNewTranslation: [ :translation |
			view editor selection restoreTransformMemento: memento.
			isBoxTranslation ifTrue: [
				view editor selection translateBy: (view snapTranslation: translation).
			] ifFalse: [
				actualExpansion := translation * expandDirection.
				expandedBox := view snapBox: (self expand: actualExpansion direction: expandDirection box: oldBox).
				transformation := oldBox computeTransformationInto: expandedBox.
				view editor selection applyTransformation: transformation.
			].
		]
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBoxManipulator >> view: view mouseOver: anEvent [
	view editor selectionBoxMouseOver: boxIndex
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBoxManipulator >> view: view selectSingleOnEditor: editor [
	((view isPerspective and: [ direction closeTo: WMVector3D new ]) or:
	[view isPerspective not and: [ (direction * view xyDragDirection) closeTo: WMVector3D new ] ])
	ifTrue: [
		editor selectionBox toggleManipulationMode
	]
]

{ #category : #testing }
WDGSLevelEditorBoxManipulator >> visibleForView: aView [
	^ aView isPerspective or: [ (aView zBackwardDirection dot: direction) > 0 ]
]
