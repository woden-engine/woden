Class {
	#name : #WTGLevelEditorSelection,
	#superclass : #WTGLevelEditorElementModel,
	#instVars : [
		'editor',
		'elements',
		'lastElement'
	],
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #adding }
WTGLevelEditorSelection >> addAllElements: aCollection [
	aCollection do: [ :element | self addElement: element ]
]

{ #category : #adding }
WTGLevelEditorSelection >> addElement: anElement [
	editor ifNotNil: [
		lastElement ifNotNil: [ lastElement lastSelected: false].		
		anElement selected: true; lastSelected: true
	].

	elements add: anElement.
	lastElement := anElement.
	editor ifNotNil: [ editor selectionChanged ].
]

{ #category : #transforming }
WTGLevelEditorSelection >> applyTransformation: aTransform [
	elements do: [ :element | element applyTransformation: aTransform ]
]

{ #category : #converting }
WTGLevelEditorSelection >> asBoxSelection [
	^ WTGLevelEditorSelectionBox empty
		addAllElements: elements;
		lastElement: lastElement;
		yourself
]

{ #category : #converting }
WTGLevelEditorSelection >> asElementSelection [
	^ self
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelection >> clearSelectedState [
	elements do: [ :element | element selected: false; lastSelected: false ].

]

{ #category : #accessing }
WTGLevelEditorSelection >> editor [
	^ editor
]

{ #category : #accessing }
WTGLevelEditorSelection >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
WTGLevelEditorSelection >> elements [
	^ elements
]

{ #category : #initialization }
WTGLevelEditorSelection >> initialize [
	super initialize.

	elements := Set new.
	lastElement := nil.
]

{ #category : #intersection }
WTGLevelEditorSelection >> intersectsWithBrushProperly: brush [
	elements do: [:element |
		(element intersectsWithBrushProperly: brush) ifTrue: [ ^ true ]
	].
	^ false
]

{ #category : #testing }
WTGLevelEditorSelection >> isSelectionBox [
	^ false
]

{ #category : #testing }
WTGLevelEditorSelection >> isSpaceSelection [
	^ false
]

{ #category : #accessing }
WTGLevelEditorSelection >> lastElement [
	^ lastElement
]

{ #category : #accessing }
WTGLevelEditorSelection >> lastElement: anObject [
	^ lastElement := anObject
]

{ #category : #adding }
WTGLevelEditorSelection >> removeElement: anElement [
	editor ifNotNil: [ anElement selected: false; lastSelected: false. ].
	elements remove: anElement.
	elements ifEmpty: [
		lastElement := nil
	] ifNotEmpty: [
		lastElement == anElement ifTrue: [
			lastElement := elements anyOne.
			lastElement lastSelected: true.
		].
	].
	
	editor ifNotNil: [ editor selectionChanged ].
	
]

{ #category : #memento }
WTGLevelEditorSelection >> restoreTransformMemento: memento [
	memento do: [ :assoc | assoc key restoreTransformMemento: assoc value ]
]

{ #category : #transforming }
WTGLevelEditorSelection >> rotate: angle axis: axis pivot: pivot [
	| quaternion transformation |
	quaternion := WMQuaternionD axis: axis asWMVector3D angle: angle.
	transformation := WMReversibleAffineTransformD identity
		translateBy: pivot negated;
		applyOrthonormalMatrix: quaternion asWMMatrix3D;
		translateBy: pivot.
	self applyTransformation: transformation
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelection >> setSelectedState [
	elements ifEmpty: [ ^ true ].
	elements do: [ :element | element selected: true ].
	lastElement lastSelected: true.
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> textureRotation [
	^ self textureTransformsValueCollect: [:transform | transform rotation]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> textureRotation: newValue [
	self textureTransformsDo: [ :transform | transform rotation: newValue ]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> textureTransformsDo: aBlock [
	elements do: [:element | element textureTransformsDo: aBlock ]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> textureTransformsValueCollect: aBlock [
	| result newResult |
	result := nil.
	self textureTransformsDo: [ :transform |
		newResult := aBlock value: transform.
		(result isNotNil and: [ result ~= newResult ]) ifTrue: [ ^ nil ].
		result := newResult.
	].
	^ result
]

{ #category : #'as yet unclassified' }
WTGLevelEditorSelection >> toggleManipulationMode [
]

{ #category : #adding }
WTGLevelEditorSelection >> toggleSelectedElement: anElement [
	(elements includes: anElement)
		ifTrue: [ self removeElement: anElement ]
		ifFalse: [ self addElement: anElement ]
]

{ #category : #memento }
WTGLevelEditorSelection >> transformMemento [
	^ elements collect: [:element | element -> element transformMemento ]
]

{ #category : #transforming }
WTGLevelEditorSelection >> translateBy: translation [
	| transform |
	transform := WMReversibleAffineTransformD identity translateBy: translation.
	self applyTransformation: transform
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> xTextureOffset [
	^ self textureTransformsValueCollect: [:transform | transform offset x]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> xTextureOffset: newValue [
	self textureTransformsDo: [ :transform | transform offset: (transform offset x: newValue) ]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> xTextureScale [
	^ self textureTransformsValueCollect:[:transform | transform scale x]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> xTextureScale: newValue [
	self textureTransformsDo: [ :transform | transform scale: (transform scale x: newValue) ]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> yTextureOffset [
	^ self textureTransformsValueCollect: [:transform | transform offset y]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> yTextureOffset: newValue [
	self textureTransformsDo: [ :transform | transform offset: (transform offset y: newValue) ]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> yTextureScale [
	^ self textureTransformsValueCollect:[:transform | transform scale y]
]

{ #category : #'texture transform' }
WTGLevelEditorSelection >> yTextureScale: newValue [
	self textureTransformsDo: [ :transform | transform scale: (transform scale y: newValue) ]
]
