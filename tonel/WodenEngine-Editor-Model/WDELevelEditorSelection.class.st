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
	| duplicatedItems placeableElements |
	selectedItems ifEmpty: [ ^ self ].

	placeableElements := selectedItems select: [ :each | each canBeDuplicatedAndPlacedInLayer ].
	placeableElements ifEmpty: [ ^ self ].
	
	duplicatedItems := placeableElements collect: [ :each |
		| copy |
		copy := each copy setupForNewInstance; yourself.
		each parent addChild: copy.
		copy
	].

	levelSession startPlacingDuplicatedItems: duplicatedItems
]

{ #category : #initialization }
WDELevelEditorSelection >> initialize [
	super initialize.
	selectedItems := #().
]

{ #category : #memento }
WDELevelEditorSelection >> materialStateMemento [
	^ selectedItems collect: [ :each | each materialStateMemento ]
]

{ #category : #accessing }
WDELevelEditorSelection >> propertyPages [
	selectedItems size = 1 ifTrue: [ ^ selectedItems first propertyPages ].
	^ #()
]

{ #category : #memento }
WDELevelEditorSelection >> restoreMaterialStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreMaterialStateMemento: (memento at: index) ]
]

{ #category : #memento }
WDELevelEditorSelection >> restoreTransformStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreTransformStateMemento: (memento at: index) ]
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems [
	^ selectedItems
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems: anObject [
	selectedItems := anObject
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelection >> subtractSelectedItemsInSession: levelSession [
	| affectedElements subtractingItems remainingElements affectedElementSet actuallyAffectedElementsSet newElements originalsWithLayers affectedOriginals |
	selectedItems ifEmpty: [ ^ self ].
	
	subtractingItems := selectedItems select: [ :each | each canBeUsedForSubtraction ].
	subtractingItems ifEmpty: [ ^ self ].

	affectedElements := levelSession level findEntitiesThatIntersectEntities: subtractingItems.
	affectedElements ifEmpty: [ ^ self ].
	
	originalsWithLayers := affectedElements collect: [:each | {each sectorLayer . each} ] as: Array.
	remainingElements := originalsWithLayers.
	affectedElementSet := affectedElements as: IdentitySet.
	actuallyAffectedElementsSet := IdentitySet new.
	subtractingItems do: [ :subtractor |
		| newRemainingElements |
		newRemainingElements := OrderedCollection new.
		remainingElements do: [ :layerWithEach |
			| subtractionResult layer each |
			layer := layerWithEach first. 
			each := layerWithEach second.
			subtractionResult := each subtract: subtractor.
			newRemainingElements addAll: (subtractionResult collect: [:r | {layer . r} ]).
			((affectedElementSet includes: each) and: [ (actuallyAffectedElementsSet includes: each) not ]) ifTrue: [
				(subtractionResult size = 1 and: [ subtractionResult first == each ]) ifFalse: [
					actuallyAffectedElementsSet add: each.
				]
			]
		].
		remainingElements := newRemainingElements
	].

	affectedOriginals := originalsWithLayers select: [ :layerAndElement | (actuallyAffectedElementsSet includes: layerAndElement second) ].
	newElements := remainingElements reject: [ :layerAndElement | (affectedElementSet includes: layerAndElement second) ].

	levelSession
		doWith: [ 
			affectedOriginals do: [ :each | each second removeFromParent ].
			newElements do: [ :each | each first addChild: each second ].
			levelSession selection: self.
		] undoWith: [ 
			newElements do: [ :each | each second removeFromParent ].
			affectedOriginals do: [ :each | each first addChild: each second ].
			levelSession selection: self.
		]

]

{ #category : #memento }
WDELevelEditorSelection >> transformStateMemento [
	^ selectedItems collect: [ :each | each transformStateMemento ]
]
