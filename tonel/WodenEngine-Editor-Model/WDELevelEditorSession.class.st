Class {
	#name : #WDELevelEditorSession,
	#superclass : #Object,
	#instVars : [
		'level',
		'gridSize',
		'selection'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #adding }
WDELevelEditorSession >> addElementsToSelection: elements [
	| newSelectedItems oldSelectedItemSet |
	newSelectedItems := self selection selectedItems asOrderedCollection.
	oldSelectedItemSet := newSelectedItems asSet.
	elements do: [ :each |
		(oldSelectedItemSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].
	self selection: (WDELevelEditorSelection for: newSelectedItems asArray)
]

{ #category : #accessing }
WDELevelEditorSession >> gridSize [
	^ gridSize value
]

{ #category : #accessing }
WDELevelEditorSession >> gridSize: newValue [
	gridSize value: newValue
]

{ #category : #initialization }
WDELevelEditorSession >> initialize [
	super initialize.
	level := nil asValueHolder.
	gridSize := 10.0 asValueHolder.
	selection := WDELevelEditorSelection empty asValueHolder.
]

{ #category : #accessing }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : #accessing }
WDELevelEditorSession >> level: anObject [
	level value: anObject
]

{ #category : #accessing }
WDELevelEditorSession >> selection [
	^ selection value
]

{ #category : #accessing }
WDELevelEditorSession >> selection: newSelection [
	selection value: newSelection
]

{ #category : #adding }
WDELevelEditorSession >> setSelectedElements: elements [
	self selection: (WDELevelEditorSelection for: elements asArray)
]

{ #category : #snapping }
WDELevelEditorSession >> subGridSize [
	^ self gridSize * 0.1
]

{ #category : #adding }
WDELevelEditorSession >> toggleElementsFromSelection: elements [
	| newSelectedItems oldSelectedItemSet oldSelectedItems toggleElementSet |
	newSelectedItems := OrderedCollection new.
	oldSelectedItems := self selection selectedItems.
	oldSelectedItemSet := newSelectedItems asSet.
	toggleElementSet := elements asSet.

	oldSelectedItems do: [ :each |
		(toggleElementSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].

	elements do: [ :each |
		(oldSelectedItemSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].
	self selection: (WDELevelEditorSelection for: newSelectedItems asArray)
]

{ #category : #enumerating }
WDELevelEditorSession >> whenGridSizeChangedDo: aBlock [
	gridSize whenChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenLevelChangedDo: aBlock [
	level whenChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenSelectionChangedDo: aBlock [
	selection whenChangedDo: aBlock
]
