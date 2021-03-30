Class {
	#name : #WDELevelEditorDuplicatePlacementToolMode,
	#superclass : #WDELevelEditorViewActionMoveToolMode,
	#instVars : [
		'oldSelection',
		'duplicatedElements',
		'transformStateMementos'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> applyPositionToElements [
	| translation |
	currentPosition ifNil: [ ^ self ].
	
	translation := self snapToSubGrid: (self cameraXYDeltaToWorld: currentPosition - startPosition distance: screenDistance).
	duplicatedElements doWithIndex: [ :each :index |
		each
			restoreTransformStateMemento: (transformStateMementos at: index);
			translateBy: translation
	].
]

{ #category : #'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragCancelled [
	duplicatedElements do: [ :each | each removeFromParent ].
	super dragCancelled
]

{ #category : #'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragDelta: delta [
	self applyPositionToElements
]

{ #category : #'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragFinished [
	| parents undoBlock newSelection editorSession |
	self applyPositionToElements.
	
	parents := duplicatedElements collect: [ :each | each parent ].

	newSelection := WDELevelEditorSelection for: duplicatedElements.
	editorSession := self levelEditorSession.
	undoBlock := [
		duplicatedElements do: [ :each | each removeFromParent ].
		editorSession selection: oldSelection.
	].
	undoBlock value.
	editorSession
		doWith: [
			duplicatedElements doWithIndex: [ :each :index |
				(parents at: index) addChild: each
			].
			editorSession selection: newSelection.
		] undoWith: undoBlock.
	
	super dragFinished
]

{ #category : #accessing }
WDELevelEditorDuplicatePlacementToolMode >> duplicatedElements [

	^ duplicatedElements
]

{ #category : #accessing }
WDELevelEditorDuplicatePlacementToolMode >> duplicatedElements: anObject [
	duplicatedElements := anObject.
	transformStateMementos := duplicatedElements collect: [ :each | each transformStateMemento ].
]

{ #category : #'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> modeName [
	^ 'Duplicate Placement'
]

{ #category : #accessing }
WDELevelEditorDuplicatePlacementToolMode >> oldSelection [

	^ oldSelection
]

{ #category : #accessing }
WDELevelEditorDuplicatePlacementToolMode >> oldSelection: anObject [

	oldSelection := anObject
]
