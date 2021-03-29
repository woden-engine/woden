Class {
	#name : #WDELevelEditorSession,
	#superclass : #Object,
	#instVars : [
		'level',
		'gridSize',
		'selection',
		'activeSectorLayer',
		'levelFileReference',
		'activeLevelElementTemplate',
		'undoOperationHistory',
		'redoOperationHistory',
		'statusMessage',
		'activeToolModeOrEditionModeName',
		'gameSettings'
	],
	#category : #'WodenEngine-Editor-Model-Session'
}

{ #category : #accessing }
WDELevelEditorSession >> activeLevelElementTemplate [
	^ activeLevelElementTemplate value
]

{ #category : #accessing }
WDELevelEditorSession >> activeLevelElementTemplate: aTemplate [
	activeLevelElementTemplate value: aTemplate
]

{ #category : #accessing }
WDELevelEditorSession >> activeSectorLayer [
	^ activeSectorLayer value
]

{ #category : #accessing }
WDELevelEditorSession >> activeSectorLayer: newLayer [
	activeSectorLayer value: newLayer
]

{ #category : #accessing }
WDELevelEditorSession >> activeToolModeOrEditionModeName [
	^ activeToolModeOrEditionModeName ifNil: [ activeToolModeOrEditionModeName := '' ]
]

{ #category : #accessing }
WDELevelEditorSession >> activeToolModeOrEditionModeName: anObject [
	activeToolModeOrEditionModeName := anObject.
	self updateStatusMessage
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

{ #category : #actions }
WDELevelEditorSession >> deleteSelectedItems [
	self selection deleteSelectedItemsInSession: self
]

{ #category : #'undo-redo' }
WDELevelEditorSession >> doWith: doBlock undoWith: undoBlock [
	| operation |
	operation := WDELevelEditorOperation doWith: doBlock undoWith: undoBlock.
	operation doIt.
	undoOperationHistory add: operation.
	redoOperationHistory removeAll.
]

{ #category : #actions }
WDELevelEditorSession >> duplicateSelectedItems [
	self selection duplicateSelectedItemsInSession: self
]

{ #category : #accessing }
WDELevelEditorSession >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevelEditorSession >> gameSettings: anObject [

	gameSettings := anObject
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
	gameSettings := WDEGameSettings default.
	level := nil asValueHolder.
	levelFileReference := nil asValueHolder.
	activeSectorLayer := nil asValueHolder.
	activeLevelElementTemplate := nil asValueHolder.
	statusMessage := '' asValueHolder.
	gridSize := 10.0 asValueHolder.
	selection := WDELevelEditorSelection empty asValueHolder.
	undoOperationHistory := OrderedCollection new.
	redoOperationHistory := OrderedCollection new.
]

{ #category : #accessing }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : #accessing }
WDELevelEditorSession >> level: anObject [
	self selection: WDELevelEditorSelection empty.
	undoOperationHistory removeAll.
	redoOperationHistory removeAll.
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
	extension = 'wtlevel' ifTrue: [ ^ self loadJSONEncodedFrom: aFileReference ].
	extension = 'wlevel' ifTrue: [ ^ self loadMessagePackEncodedFrom: aFileReference ].
]

{ #category : #'play testing' }
WDELevelEditorSession >> playLevel [
	^ gameSettings playLevelInSession: self
]

{ #category : #'undo-redo' }
WDELevelEditorSession >> redo [
	| operation |
	redoOperationHistory ifEmpty: [ ^ self ].
	operation := redoOperationHistory first.
	redoOperationHistory removeFirst.
	operation doIt.
	undoOperationHistory addLast: operation.
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
	extension = 'wtlevel' ifTrue: [ self saveJSONEncodedTo: aFileReference ].
	extension = 'wlevel' ifTrue: [ self saveMessagePackEncodedTo: aFileReference ].
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

{ #category : #accessing }
WDELevelEditorSession >> statusMessage [
	^ statusMessage value
]

{ #category : #accessing }
WDELevelEditorSession >> statusMessage: newMessage [
	statusMessage value: newMessage
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

{ #category : #palettes }
WDELevelEditorSession >> topLevelElementTemplateCategories [
	^ WDELevelElementTemplateProvider allTopLevelPaletteCategories
]

{ #category : #palettes }
WDELevelEditorSession >> topLevelLightSourcePaletteCategories [
	^ WDELightSourcePaletteProvider allTopLevelPaletteCategories
]

{ #category : #palettes }
WDELevelEditorSession >> topMaterialPaletteCategories [
	^ WDEMaterialPaletteProvider allTopLevelPaletteCategories , gameSettings topMaterialPaletteCategories
]

{ #category : #'undo-redo' }
WDELevelEditorSession >> undo [
	| operation |
	undoOperationHistory ifEmpty: [ ^ self ].
	operation := undoOperationHistory last.
	undoOperationHistory removeLast.
	operation undoIt.
	redoOperationHistory addFirst: operation.
]

{ #category : #accessing }
WDELevelEditorSession >> updateStatusMessage [
	self statusMessage: self activeToolModeOrEditionModeName
]

{ #category : #enumerating }
WDELevelEditorSession >> whenActiveLevelElementTemplateDo: aBlock [
	activeLevelElementTemplate whenChangedDo: aBlock
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
WDELevelEditorSession >> whenLevelChangedDoNow: aBlock [
	self whenLevelChangedDo: aBlock.
	aBlock cull: self level
]

{ #category : #enumerating }
WDELevelEditorSession >> whenSelectionChangedDo: aBlock [
	selection whenChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenStatusMessageChangedDo: aBlock [
	statusMessage whenChangedDo: aBlock
]
