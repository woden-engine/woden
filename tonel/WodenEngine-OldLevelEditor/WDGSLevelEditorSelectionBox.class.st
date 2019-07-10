Class {
	#name : #WDGSLevelEditorSelectionBox,
	#superclass : #WDGSLevelEditorSelection,
	#instVars : [
		'box',
		'rotationMode'
	],
	#classVars : [
		'ElementSelectionColor',
		'ElementSelectionHighlightColor',
		'SpaceSelectionColor',
		'SpaceSelectionHighlightColor'
	],
	#category : #'WodenEngine-OldLevelEditor-Model'
}

{ #category : #construction }
WDGSLevelEditorSelectionBox class >> box: abox [
	^ self new box: abox
	
]

{ #category : #construction }
WDGSLevelEditorSelectionBox class >> empty [
	^ self new box: WMBox3DD empty
]

{ #category : #'class initialization' }
WDGSLevelEditorSelectionBox class >> initialize [
	super initialize.
	
	SpaceSelectionColor := Color veryLightGray.
	SpaceSelectionHighlightColor := Color white.
	
	ElementSelectionColor := Color orange.
	ElementSelectionHighlightColor := Color orange muchLighter.
]

{ #category : #adding }
WDGSLevelEditorSelectionBox >> addElement: anElement [
	super addElement: anElement.
	box ifNil: [ box := anElement boundingBox copy ]
		ifNotNil: [ box insertBox: anElement boundingBox ].

	editor ifNotNil: [
		elements size = 1 ifTrue: [ editor selectionBoxViewsDo: #updateColors ].
		editor selectionBoxViewsDo: #updateNodes
	]
]

{ #category : #transforming }
WDGSLevelEditorSelectionBox >> applyTransformation: aTransform [
	super applyTransformation: aTransform.
	self box: (box transformedWith: aTransform)
]

{ #category : #converting }
WDGSLevelEditorSelectionBox >> asBoxSelection [
	^ self
]

{ #category : #converting }
WDGSLevelEditorSelectionBox >> asElementSelection [
	^ WDGSLevelEditorSelection new
		addAllElements: elements;
		lastElement: lastElement;
		yourself
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> box [
	^ box
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> box: anObject [
	box := anObject.
	editor ifNotNil: [
		editor selectionBoxViewsDo: #updateNodes
	]
]

{ #category : #adding }
WDGSLevelEditorSelectionBox >> buildBoxFromBoundingBoxes [
	box := WMBox3DD empty.
	elements do: [ :element | box insertBox: element boundingBox ].
	editor ifNotNil: [ editor selectionBoxViewsDo: #updateNodes ]
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> color [
	^ self isSpaceSelection ifTrue: [ SpaceSelectionColor ] ifFalse: [ ElementSelectionColor ]
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> highlightColor [
	^ self isSpaceSelection ifTrue: [ SpaceSelectionHighlightColor ] ifFalse: [ ElementSelectionHighlightColor ]
]

{ #category : #testing }
WDGSLevelEditorSelectionBox >> includes: element [
	^ elements includes: element
]

{ #category : #initialization }
WDGSLevelEditorSelectionBox >> initialize [
	super initialize.
	rotationMode := false
]

{ #category : #requirements }
WDGSLevelEditorSelectionBox >> isEmpty [
	^ box isEmpty
]

{ #category : #testing }
WDGSLevelEditorSelectionBox >> isPointSelection [
	^ elements isNotEmpty and: [ elements size = 1 and: [ elements anyOne isPointSelected ] ]
]

{ #category : #testing }
WDGSLevelEditorSelectionBox >> isSelectionBox [
	^ true
]

{ #category : #requirements }
WDGSLevelEditorSelectionBox >> isSpaceSelection [
	^ elements isEmpty
]

{ #category : #copying }
WDGSLevelEditorSelectionBox >> postCopy [
	elements := elements copy.
	box := box copy.
]

{ #category : #adding }
WDGSLevelEditorSelectionBox >> removeElement: anElement [
	super removeElement: anElement.
	elements size = 0 ifTrue: [ editor ifNotNil: [ editor selectionBoxViewsDo: #updateColors ] ].
	self buildBoxFromBoundingBoxes.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSelectionBox >> restoreTransformMemento: memento [
	super restoreTransformMemento: memento first.
	self box: memento second
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> rotationMode [
	^ rotationMode
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSelectionBox >> toggleManipulationMode [
	rotationMode := rotationMode not.
	editor selectionBoxViewsDo: #updateNodes.
]

{ #category : #accessing }
WDGSLevelEditorSelectionBox >> transformIntoBox: aBox [
	| transformation |
	elements ifNotEmpty: [ 
		transformation := box computeTransformationInto: aBox.
		elements do: [:el | el applyTransformation: transformation ]
	].

	self box: aBox.
	
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSelectionBox >> transformMemento [
	^ { super transformMemento . box copy }
]
