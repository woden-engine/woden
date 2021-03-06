Class {
	#name : #WDELevelEditor3DManipulator,
	#superclass : #Object,
	#instVars : [
		'model',
		'boundingBox',
		'sceneNode',
		'parent',
		'children',
		'highlighted'
	],
	#category : #'WodenEngine-Editor-UI-Manipulators'
}

{ #category : #'instance creation' }
WDELevelEditor3DManipulator class >> for: aModel [
	^ self new model: aModel; yourself
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> activateAction [
	"This activates and action associated with this manipulator"
]

{ #category : #removing }
WDELevelEditor3DManipulator >> addToScene: aScene [
	sceneNode := self createSceneNode.
	sceneNode ifNotNil: [ aScene add: sceneNode ].
	children do: [ :each | each addToScene: aScene ].
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> applyHighlightingEffect [
]

{ #category : #'element manipulation' }
WDELevelEditor3DManipulator >> applyTransform: transformation [
]

{ #category : #'element manipulation' }
WDELevelEditor3DManipulator >> applyTransformForTranslationDelta: translationDelta [
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> children: newChildren [
	sceneNode ifNotNil: [
		children do: [ :each | each removeFromScene ].
	].
	children := newChildren.
	children do: [ :each | each parent: self ].
	sceneNode ifNotNil: [
		children do: [ :each | each addToScene: sceneNode scene ]
	]
]

{ #category : #removing }
WDELevelEditor3DManipulator >> createSceneNode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> currentDragToolClass [
	^ nil
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> engine [
	^ model engine
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> highlighted [
	^ highlighted
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> highlighted: anObject [
	highlighted := anObject.
	self applyHighlightingEffect.
]

{ #category : #initialization }
WDELevelEditor3DManipulator >> initialize [
	super initialize.
	highlighted := false.
	boundingBox := BoxF32 empty.
	children := #().
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> level [
	^ model level
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> levelEditorSession [
	^ model levelEditorSession
]

{ #category : #memento }
WDELevelEditor3DManipulator >> mementoForDragging [
	^ nil
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> model [
	^ model
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> model: anObject [
	model := anObject
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> parent [
	^ parent
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> parent: anObject [
	parent := anObject
]

{ #category : #'ray casting' }
WDELevelEditor3DManipulator >> rayCast: ray [
	| bestResult distance |
	self visible ifFalse: [ ^ nil ].
	bestResult := nil.
	children do: [ :each |
		(each rayCast: ray) ifNotNil: [:childResult |
			(bestResult isNil or: [childResult < bestResult]) ifTrue: [
				bestResult := childResult
			]
		]
	].
	bestResult value ifNotNil: [ ^ bestResult ].
	boundingBox isEmpty ifTrue: [ ^ nil ].

	distance := boundingBox intersectionWithRay: ray.
	distance ifNil: [ ^ nil ].
	^ distance -> self.
]

{ #category : #removing }
WDELevelEditor3DManipulator >> removeFromScene [
	children do: [ :each | each removeFromScene ].
	sceneNode ifNotNil: [
		sceneNode removeFromScene.
		sceneNode := nil
	]
]

{ #category : #memento }
WDELevelEditor3DManipulator >> restoreMementoForDragging: memento [
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> sizeScaleFactorForPosition: position inView: view [
	^ view isPerspective
		ifTrue: [ (position - view validCameraTransform translation) length max: 1.0 ]
		ifFalse: [ view viewScale * 2.0 ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> startDragToolWithEvent: event on: view [
	| dragToolClass |
	dragToolClass := self currentDragToolClass.
	dragToolClass ifNil: [^ self].
	view activeToolMode:
		((dragToolClass for: view)
			manipulator: self;
			dragStartedWith: event;
			yourself)
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> theme [
	^ WDELevelEditorTheme current
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> updateForViewCamera: view [
	children do: [ :each | each updateForViewCamera: view ]
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> visible [
	^ sceneNode isNotNil and: [ sceneNode visible ]
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> visible: aBoolean [
	sceneNode ifNotNil: [ sceneNode visible: aBoolean ]
]
