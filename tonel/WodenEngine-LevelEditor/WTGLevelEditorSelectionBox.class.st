Class {
	#name : #WTGLevelEditorSelectionBox,
	#superclass : #WTGLevelEditorSelection,
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
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #construction }
WTGLevelEditorSelectionBox class >> box: abox [
	^ self new box: abox
	
]

{ #category : #construction }
WTGLevelEditorSelectionBox class >> empty [
	^ self new box: WMBox3DD empty
]

{ #category : #'class initialization' }
WTGLevelEditorSelectionBox class >> initialize [
	super initialize.
	
	SpaceSelectionColor := Color veryLightGray.
	SpaceSelectionHighlightColor := Color white.
	
	ElementSelectionColor := Color orange.
	ElementSelectionHighlightColor := Color orange muchLighter.
]

{ #category : #adding }
WTGLevelEditorSelectionBox >> addElement: anElement [
	super addElement: anElement.
	box ifNil: [ box := anElement boundingBox copy ]
		ifNotNil: [ box insertBox: anElement boundingBox ].

	editor ifNotNil: [
		elements size = 1 ifTrue: [ editor selectionBoxViewsDo: #updateColors ].
		editor selectionBoxViewsDo: #updateNodes
	]
]

{ #category : #transforming }
WTGLevelEditorSelectionBox >> applyTransformation: aTransform [
	super applyTransformation: aTransform.
	self box: (box transformedWith: aTransform)
]

{ #category : #converting }
WTGLevelEditorSelectionBox >> asBoxSelection [
	^ self
]

{ #category : #converting }
WTGLevelEditorSelectionBox >> asElementSelection [
	^ WTGLevelEditorSelection new
		addAllElements: elements;
		lastElement: lastElement;
		yourself
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> box [
	^ box
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> box: anObject [
	box := anObject.
	editor ifNotNil: [
		editor selectionBoxViewsDo: #updateNodes
	]
]

{ #category : #adding }
WTGLevelEditorSelectionBox >> buildBoxFromBoundingBoxes [
	box := WMBox3DD empty.
	elements do: [ :element | box insertBox: element boundingBox ].
	editor ifNotNil: [ editor selectionBoxViewsDo: #updateNodes ]
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> color [
	^ self isSpaceSelection ifTrue: [ SpaceSelectionColor ] ifFalse: [ ElementSelectionColor ]
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> highlightColor [
	^ self isSpaceSelection ifTrue: [ SpaceSelectionHighlightColor ] ifFalse: [ ElementSelectionHighlightColor ]
]

{ #category : #testing }
WTGLevelEditorSelectionBox >> includes: element [
	^ elements includes: element
]

{ #category : #initialization }
WTGLevelEditorSelectionBox >> initialize [
	super initialize.
	rotationMode := false
]

{ #category : #requirements }
WTGLevelEditorSelectionBox >> isEmpty [
	^ box isEmpty
]

{ #category : #testing }
WTGLevelEditorSelectionBox >> isPointSelection [
	^ elements isNotEmpty and: [ elements size = 1 and: [ elements anyOne isPointSelected ] ]
]

{ #category : #testing }
WTGLevelEditorSelectionBox >> isSelectionBox [
	^ true
]

{ #category : #requirements }
WTGLevelEditorSelectionBox >> isSpaceSelection [
	^ elements isEmpty
]

{ #category : #copying }
WTGLevelEditorSelectionBox >> postCopy [
	elements := elements copy.
	box := box copy.
]

{ #category : #adding }
WTGLevelEditorSelectionBox >> removeElement: anElement [
	super removeElement: anElement.
	elements size = 0 ifTrue: [ editor ifNotNil: [ editor selectionBoxViewsDo: #updateColors ] ].
	self buildBoxFromBoundingBoxes.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelectionBox >> restoreTransformMemento: memento [
	super restoreTransformMemento: memento first.
	self box: memento second
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> rotationMode [
	^ rotationMode
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelectionBox >> toggleManipulationMode [
	rotationMode := rotationMode not.
	editor selectionBoxViewsDo: #updateNodes.
]

{ #category : #accessing }
WTGLevelEditorSelectionBox >> transformIntoBox: aBox [
	| transformation |
	elements ifNotEmpty: [ 
		transformation := box computeTransformationInto: aBox.
		elements do: [:el | el applyTransformation: transformation ]
	].

	self box: aBox.
	
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelectionBox >> transformMemento [
	^ { super transformMemento . box copy }
]
