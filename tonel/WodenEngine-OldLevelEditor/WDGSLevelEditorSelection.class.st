Class {
	#name : #WDGSLevelEditorSelection,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'editor',
		'elements',
		'lastElement'
	],
	#category : #'WodenEngine-OldLevelEditor-Model'
}

{ #category : #adding }
WDGSLevelEditorSelection >> addAllElements: aCollection [
	aCollection do: [ :element | self addElement: element ]
]

{ #category : #adding }
WDGSLevelEditorSelection >> addElement: anElement [
	editor ifNotNil: [
		lastElement ifNotNil: [ lastElement lastSelected: false].		
		anElement selected: true; lastSelected: true
	].

	elements add: anElement.
	lastElement := anElement.
	editor ifNotNil: [ editor selectionChanged ].
]

{ #category : #transforming }
WDGSLevelEditorSelection >> applyTransformation: aTransform [
	elements do: [ :element | element applyTransformation: aTransform ]
]

{ #category : #converting }
WDGSLevelEditorSelection >> asBoxSelection [
	^ WDGSLevelEditorSelectionBox empty
		addAllElements: elements;
		lastElement: lastElement;
		yourself
]

{ #category : #converting }
WDGSLevelEditorSelection >> asElementSelection [
	^ self
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSelection >> clearSelectedState [
	elements do: [ :element | element selected: false; lastSelected: false ].

]

{ #category : #accessing }
WDGSLevelEditorSelection >> editor [
	^ editor
]

{ #category : #accessing }
WDGSLevelEditorSelection >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
WDGSLevelEditorSelection >> elements [
	^ elements
]

{ #category : #initialization }
WDGSLevelEditorSelection >> initialize [
	super initialize.

	elements := Set new.
	lastElement := nil.
]

{ #category : #intersection }
WDGSLevelEditorSelection >> intersectsWithBrushProperly: brush [
	elements do: [:element |
		(element intersectsWithBrushProperly: brush) ifTrue: [ ^ true ]
	].
	^ false
]

{ #category : #testing }
WDGSLevelEditorSelection >> isSelectionBox [
	^ false
]

{ #category : #testing }
WDGSLevelEditorSelection >> isSpaceSelection [
	^ false
]

{ #category : #accessing }
WDGSLevelEditorSelection >> lastElement [
	^ lastElement
]

{ #category : #accessing }
WDGSLevelEditorSelection >> lastElement: anObject [
	^ lastElement := anObject
]

{ #category : #adding }
WDGSLevelEditorSelection >> removeElement: anElement [
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
WDGSLevelEditorSelection >> restoreTransformMemento: memento [
	memento do: [ :assoc | assoc key restoreTransformMemento: assoc value ]
]

{ #category : #transforming }
WDGSLevelEditorSelection >> rotate: angle axis: axis pivot: pivot [
	| quaternion transformation |
	quaternion := WMQuaternionD axis: axis asWMVector3D angle: angle.
	transformation := WMReversibleAffineTransformD identity
		translateBy: pivot negated;
		applyOrthonormalMatrix: quaternion asWMMatrix3D;
		translateBy: pivot.
	self applyTransformation: transformation
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSelection >> setSelectedState [
	elements ifEmpty: [ ^ true ].
	elements do: [ :element | element selected: true ].
	lastElement lastSelected: true.
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> textureRotation [
	^ self textureTransformsValueCollect: [:transform | transform rotation]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> textureRotation: newValue [
	self textureTransformsDo: [ :transform | transform rotation: newValue ]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> textureTransformsDo: aBlock [
	elements do: [:element | element textureTransformsDo: aBlock ]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> textureTransformsValueCollect: aBlock [
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
WDGSLevelEditorSelection >> toggleManipulationMode [
]

{ #category : #adding }
WDGSLevelEditorSelection >> toggleSelectedElement: anElement [
	(elements includes: anElement)
		ifTrue: [ self removeElement: anElement ]
		ifFalse: [ self addElement: anElement ]
]

{ #category : #memento }
WDGSLevelEditorSelection >> transformMemento [
	^ elements collect: [:element | element -> element transformMemento ]
]

{ #category : #transforming }
WDGSLevelEditorSelection >> translateBy: translation [
	| transform |
	transform := WMReversibleAffineTransformD identity translateBy: translation.
	self applyTransformation: transform
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> xTextureOffset [
	^ self textureTransformsValueCollect: [:transform | transform offset x]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> xTextureOffset: newValue [
	self textureTransformsDo: [ :transform | transform offset: (transform offset x: newValue) ]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> xTextureScale [
	^ self textureTransformsValueCollect:[:transform | transform scale x]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> xTextureScale: newValue [
	self textureTransformsDo: [ :transform | transform scale: (transform scale x: newValue) ]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> yTextureOffset [
	^ self textureTransformsValueCollect: [:transform | transform offset y]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> yTextureOffset: newValue [
	self textureTransformsDo: [ :transform | transform offset: (transform offset y: newValue) ]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> yTextureScale [
	^ self textureTransformsValueCollect:[:transform | transform scale y]
]

{ #category : #'texture transform' }
WDGSLevelEditorSelection >> yTextureScale: newValue [
	self textureTransformsDo: [ :transform | transform scale: (transform scale y: newValue) ]
]
