Class {
	#name : #WDELevelEditorSelection,
	#superclass : #Object,
	#instVars : [
		'selectedItems'
	],
	#category : #'WodenEngine-Editor-Model-Session'
}

{ #category : #requirements }
WDELevelEditorSelection class >> empty [
	^ self new
]

{ #category : #'instance creation' }
WDELevelEditorSelection class >> for: selectedItems [
	^ self new selectedItems: selectedItems
]

{ #category : #actions }
WDELevelEditorSelection >> deleteSelectedItemsInSession: levelSession [
	| oldParents |
	oldParents := selectedItems collect: [ :each | each parent ].
	self assert: (oldParents allSatisfy: [ :each | each isNotNil ]).
	levelSession
		doWith: [
			levelSession selection: self class empty.
			selectedItems do: [ :each | each removeFromParent ]
		]
		undoWith: [
			selectedItems doWithIndex: [:removedItem :parentIndex |
				| oldParent |
				oldParent := oldParents at: parentIndex.
				oldParent addChild: removedItem
			].
			levelSession selection: self
		]
]

{ #category : #actions }
WDELevelEditorSelection >> duplicateSelectedItemsInSession: levelSession [
	self inform: 'TODO: duplicateSelectedItemsInSession:'
]

{ #category : #initialization }
WDELevelEditorSelection >> initialize [
	super initialize.
	selectedItems := #().
]

{ #category : #accessing }
WDELevelEditorSelection >> propertyPages [
	selectedItems size = 1 ifTrue: [ ^ selectedItems first propertyPages ].
	^ #()
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems [
	^ selectedItems
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems: anObject [
	selectedItems := anObject
]
