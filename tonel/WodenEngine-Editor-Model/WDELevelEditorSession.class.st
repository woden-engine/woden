Class {
	#name : #WDELevelEditorSession,
	#superclass : #Object,
	#instVars : [
		'level',
		'gridSize',
		'selection',
		'activeSectorLayer',
		'levelFileReference'
	],
	#category : #'WodenEngine-Editor-Model-Session'
}

{ #category : #accessing }
WDELevelEditorSession >> activeSectorLayer [
	^ activeSectorLayer value
]

{ #category : #accessing }
WDELevelEditorSession >> activeSectorLayer: newLayer [
	activeSectorLayer value: newLayer
]

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
	levelFileReference := nil asValueHolder.
	activeSectorLayer := nil asValueHolder.
	gridSize := 10.0 asValueHolder.
	selection := WDELevelEditorSelection empty asValueHolder.
]

{ #category : #accessing }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : #accessing }
WDELevelEditorSession >> level: anObject [
	self selection: WDELevelEditorSelection empty.
	level value: anObject.

]

{ #category : #accessing }
WDELevelEditorSession >> levelFileReference [
	^ levelFileReference value
]

{ #category : #accessing }
WDELevelEditorSession >> levelFileReference: aFileReference [
	levelFileReference value: aFileReference
]

{ #category : #serialization }
WDELevelEditorSession >> loadJSONEncodedFrom: aFileReference [
	| decodedLevel |
	decodedLevel := WDELevel loadFromJsonString: aFileReference contents.
	self
		level: decodedLevel;
		levelFileReference: aFileReference
]

{ #category : #serialization }
WDELevelEditorSession >> loadMessagePackEncodedFrom: aFileReference [
	| decodedLevel |
	decodedLevel := WDELevel loadMessagePack: (aFileReference binaryReadStreamDo: [:in | in contents]).
	self
		level: decodedLevel;
		levelFileReference: aFileReference
]

{ #category : #serialization }
WDELevelEditorSession >> openFrom: aFileReference [
	| extension |
	aFileReference exists ifFalse: [ ^ self ].
	extension := aFileReference extension asLowercase.
	extension = 'wlevel' ifTrue: [ ^ self loadJSONEncodedFrom: aFileReference ].
	extension = 'wblevel' ifTrue: [ ^ self loadMessagePackEncodedFrom: aFileReference ].
]

{ #category : #snapping }
WDELevelEditorSession >> round: value quantum: quantum [
	^ (((value / quantum) + 0.5) floor) * quantum
]

{ #category : #snapping }
WDELevelEditorSession >> roundFloor: value quantum: quantum [
	^ ((value / quantum) floor) * quantum
]

{ #category : #serialization }
WDELevelEditorSession >> saveJSONEncodedTo: aFileReference [
	| encodedLevel |
	encodedLevel := self level encodeAsJSONString.
	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: encodedLevel ].
	self levelFileReference: aFileReference
]

{ #category : #serialization }
WDELevelEditorSession >> saveMessagePackEncodedTo: aFileReference [
	| encodedLevel |
	encodedLevel := self level encodeAsMessagePack.
	aFileReference binaryWriteStreamDo: [ :out | out truncate; nextPutAll: encodedLevel ].
	self levelFileReference: aFileReference
]

{ #category : #serialization }
WDELevelEditorSession >> saveTo: aFileReference [
	| extension |
	self level ifNil: [ ^ self ].
	extension := aFileReference extension asLowercase.
	extension = 'wlevel' ifTrue: [ self saveJSONEncodedTo: aFileReference ].
	extension = 'wblevel' ifTrue: [ self saveMessagePackEncodedTo: aFileReference ].
]

{ #category : #accessing }
WDELevelEditorSession >> selection [
	^ selection value
]

{ #category : #accessing }
WDELevelEditorSession >> selection: newSelection [
	selection value: newSelection.
	newSelection selectedItems ifNotEmpty: [ 
		newSelection selectedItems first sectorLayer ifNotNil: [ :sectorLayer |
			self activeSectorLayer: sectorLayer
		]
	]
]

{ #category : #adding }
WDELevelEditorSession >> setSelectedElements: elements [
	self selection: (WDELevelEditorSelection for: elements asArray)
]

{ #category : #snapping }
WDELevelEditorSession >> snapToGrid: vector [
	^ self round: vector quantum: self gridSize
]

{ #category : #snapping }
WDELevelEditorSession >> snapToSubGrid: vector [
	^ self round: vector quantum: self subGridSize
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
