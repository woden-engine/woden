Class {
	#name : #WDEEntity,
	#superclass : #WDELevelElement,
	#instVars : [
		'position',
		'parent',
		'className',
		'components',
		'localSelectableBoundingBox',
		'localBoundingBox',
		'boundingBox',
		'selectableBoundingBox',
		'localBoundingRectangle',
		'localBoundingBoxWithDepth',
		'dimensionalityMode'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'basic entity prototypes' }
WDEEntity class >> defaultColor [
	^ Color r: 0.8 g: 0.8 b: 0.8
]

{ #category : #'basic entity prototypes' }
WDEEntity class >> pointPrototype [
	^ self new
		className: #Point;
		yourself
]

{ #category : #'basic entity prototypes' }
WDEEntity class >> solidWall2DPrototype [
	^ self new
		makeEntity2D;
		className: 'Wall';
		localBoundingRectangle: RectangleF32 unitRectangle;
		addComponent: (WDEVisualComponent rectangle: RectangleF32 unitRectangle color: self defaultColor);
		addComponent: (WDECollisionComponent rectangle: RectangleF32 unitRectangle);
		yourself

]

{ #category : #'basic entity prototypes' }
WDEEntity class >> solidWall3DPrototype [
	^ self new
		makeEntity3D;
		className: 'Wall';
		localBoundingBox: BoxF32 unitBox;
		addComponent: (WDEVisualComponent box: BoxF32 unitBox color: self defaultColor);
		addComponent: (WDECollisionComponent box: BoxF32 unitBox);
		yourself

]

{ #category : #visiting }
WDEEntity >> accept: visitor [
	^ visitor visitEntity: self
]

{ #category : #adding }
WDEEntity >> addComponent: aComponent [
	self assert: aComponent parent isNil.
	components add: aComponent.
	aComponent parent: self.
	self level ifNotNil: [ :level | aComponent addedToLevel: level ].
]

{ #category : #accessing }
WDEEntity >> boundingBox [
	^ boundingBox ifNil: [ boundingBox := self localBoundingBoxWithDepth translatedBy: self validPosition3D ]
]

{ #category : #accessing }
WDEEntity >> children [
	^ components
]

{ #category : #accessing }
WDEEntity >> className [
	^ className ifNil: [ className := '' ]
]

{ #category : #accessing }
WDEEntity >> className: anObject [
	className := anObject
]

{ #category : #accessing }
WDEEntity >> components [
	^ components
]

{ #category : #private }
WDEEntity >> computeLocalBoundingBoxFromComponents [
	| box |
	box := BoxF32 empty.
	components do: [ :each |
		box insertBox: each boundingBox
	].

	box isEmpty ifTrue: [ box insertPoint: 0 ].
	localBoundingBox value: box.
]

{ #category : #private }
WDEEntity >> computeLocalSelecteableBoundingBox [

	localSelectableBoundingBox := BoxF32 center: self localBoundingBoxWithDepth center halfExtent: (self localBoundingBoxWithDepth halfExtent max: 0.1)
]

{ #category : #accessing }
WDEEntity >> dimensionalityMode [
	^ dimensionalityMode
]

{ #category : #accessing }
WDEEntity >> dimensionalityMode: anObject [
	dimensionalityMode := anObject
]

{ #category : #serialization }
WDEEntity >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#className . self className.
		#name . self name.
		#position . self position encodeForJSON.
		#localBoundingBox . self localBoundingBox encodeForJSON.
		#components . self components collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	components := OrderedCollection new asValueHolder.
	dimensionalityMode := WDELevelElementDimensionalityMode mode3D.
	position := Float32x3 zeros asValueHolder.
	localBoundingBox := (BoxF32 point: Float32x3 zeros) asValueHolder.
]

{ #category : #'ray casting' }
WDEEntity >> intersectsFrustum: frustum [
	self selectableBoundingBox isEmpty ifTrue: [ ^ false ].
	
	^ frustum intersectsOrContainsBox: self selectableBoundingBox
]

{ #category : #transforms }
WDEEntity >> is2DLevelElement [
	^ dimensionalityMode is2D
]

{ #category : #testing }
WDEEntity >> isEntity [
	^ true
]

{ #category : #testing }
WDEEntity >> isInSector2D [
	^ self parent isInSector2D
]

{ #category : #testing }
WDEEntity >> isPointEntity [
	^ self localBoundingBox min = self localBoundingBox max
]

{ #category : #serialization }
WDEEntity >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	self
		className: (jsonData at: 'className' ifAbsent: ['']);
		name: (jsonData at: 'name' ifAbsent: ['']).
	jsonData at: 'position' ifPresent: [ :data |
		data size = 2 ifTrue: [
			self position: (Float32x2 loadFromJson: data)
		] ifFalse: [
			self assert: data size = 3.
			self position: (Float32x3 loadFromJson: data)
		]
	].

	jsonData at: 'localBoundingBox' ifPresent: [ :data |
		| minData |
		minData := (data at: 'min').
		minData size = 2 ifTrue: [
			self localBoundingRectangle: (RectangleF32 loadFromJson: data)
		] ifFalse: [
			self assert: minData size = 3.
			self localBoundingBox: (BoxF32 loadFromJson: data)
		]
	].

	jsonData at: 'components' ifPresent: [ :componentData |
		componentData do: [ :each |
			self addComponent: (WDELevelElement loadFromJson: each)
		]
	]
]

{ #category : #accessing }
WDEEntity >> localBoundingBox [
	^ localBoundingBox value
]

{ #category : #accessing }
WDEEntity >> localBoundingBox: anObject [
	self localBoundingBoxChanged.
	localBoundingBox value: anObject.

]

{ #category : #private }
WDEEntity >> localBoundingBoxChanged [
	localBoundingBoxWithDepth := nil.
	localSelectableBoundingBox := nil.
	selectableBoundingBox := nil.
	boundingBox := nil.
]

{ #category : #testing }
WDEEntity >> localBoundingBoxHasValidArea [
	^ self localBoundingBox width > 0 and: [ self localBoundingBox height > 0 ]
]

{ #category : #testing }
WDEEntity >> localBoundingBoxHasValidVolume [
	^ self localBoundingBoxHasValidArea and: [ self localBoundingBoxWithDepth depth > 0 ]
]

{ #category : #accessing }
WDEEntity >> localBoundingBoxWithDepth [
	| rawBox |
	localBoundingBoxWithDepth ifNil: [ 
		rawBox := self localBoundingBox.
		(rawBox min ~= rawBox max and: [ rawBox min z = 0 and: [ rawBox max z = 0 ] ]) ifTrue: [
			localBoundingBoxWithDepth := BoxF32 min: (rawBox min copy z: self sectorLayer defaultMinZ)
				max: (rawBox max copy z: self sectorLayer defaultMaxZ)
		] ifFalse: [
			localBoundingBoxWithDepth := rawBox
		]
	].
	^ localBoundingBoxWithDepth
]

{ #category : #accessing }
WDEEntity >> localBoundingRectangle: aRectangle [
	self localBoundingBox: (BoxF32 min: (Float32x3 xy: aRectangle min z: 0) max: (Float32x3 xy: aRectangle max z: 0))
]

{ #category : #accessing }
WDEEntity >> localSelectableBoundingBox [
	localSelectableBoundingBox ifNil: [ self computeLocalSelecteableBoundingBox ].
	^ localSelectableBoundingBox
]

{ #category : #'as yet unclassified' }
WDEEntity >> makeEntity2D [
	self dimensionalityMode: WDELevelElementDimensionalityMode mode2D
]

{ #category : #'as yet unclassified' }
WDEEntity >> makeEntity3D [
	self dimensionalityMode: WDELevelElementDimensionalityMode mode3D
]

{ #category : #accessing }
WDEEntity >> parent [
	^ parent
]

{ #category : #accessing }
WDEEntity >> parent: anObject [
	parent := anObject
]

{ #category : #'as yet unclassified' }
WDEEntity >> placeInBox: targetBox [
	| transform |
	(self isPointEntity or: [self localBoundingBoxHasValidArea not])
		ifTrue: [ ^ self placeInPosition: targetBox center ].
	(self is2DLevelElement or: [self localBoundingBoxHasValidVolume not])
		ifTrue: [ ^ self placeInRectangle: targetBox asRectangleXY ].
	transform := targetBox reversibleTransformToConvertToMe: self localBoundingBoxWithDepth.
	self transformWith: transform
]

{ #category : #'as yet unclassified' }
WDEEntity >> placeInPosition: newPosition [
	newPosition class elements = self position class elements ifTrue: [ 
		^ self position: newPosition
	].

	self is2DLevelElement ifTrue: [ 
		self position: newPosition xy
	] ifFalse: [ 
		self position: (Float32x3 xy: newPosition z: 0)
	].

]

{ #category : #'as yet unclassified' }
WDEEntity >> placeInRectangle: targetRectangle [
	| transform |
	(self isPointEntity or: [self localBoundingBoxHasValidArea not])
		ifTrue: [ ^ self placeInPosition: targetRectangle center ].

	transform := targetRectangle reversibleTransform3dToConvertToMe: self localBoundingBox asRectangleXY.
	self transformWith: transform
]

{ #category : #accessing }
WDEEntity >> position [
	^ position value
]

{ #category : #accessing }
WDEEntity >> position: newPosition [
	| sanitizedPosition |
	sanitizedPosition := (dimensionalityMode sanitizePosition: (newPosition implicitCastTo: Float32x3)).
	self positionChanged.
	position value: sanitizedPosition
]

{ #category : #private }
WDEEntity >> positionChanged [
	selectableBoundingBox := nil.
	boundingBox := nil.
]

{ #category : #copying }
WDEEntity >> postCopy [
	| oldComponents oldPosition oldLocalBoundingBox |
	super postCopy.
	parent := nil.
	oldComponents := components value.
	oldPosition := position value.
	oldLocalBoundingBox := localBoundingBox value.
	position := oldPosition asValueHolder.
	localBoundingBox := oldLocalBoundingBox asValueHolder.
	components := OrderedCollection new asValueHolder.
	oldComponents do: [:each | self addComponent: each copy ]
		
]

{ #category : #'ray casting' }
WDEEntity >> rayCast: ray [
	| distance |
	self selectableBoundingBox isEmpty ifTrue: [ ^ nil ].
	
	distance := selectableBoundingBox intersectionWithRay: ray.
	distance ifNil: [ ^ nil ].
	^ distance -> self.
]

{ #category : #memento }
WDEEntity >> restoreTransformStateMemento: memento [
	| componentMementos |
	self assert: memento size = 3.
	self assert: memento third size = components size.
	self
		position: memento first;
		localBoundingBox: memento second.

	componentMementos := memento third.
	components doWithIndex: [ :eachComponent :index |
		eachComponent restoreTransformStateMemento: (componentMementos at: index)
	]
]

{ #category : #accessing }
WDEEntity >> selectableBoundingBox [
	^ selectableBoundingBox ifNil: [ selectableBoundingBox := self localSelectableBoundingBox translatedBy: self validPosition3D ]
]

{ #category : #accessing }
WDEEntity >> setVisualColor: aColor [
	self components do: [ :each |
		each setVisualColor: aColor
	]
]

{ #category : #memento }
WDEEntity >> transformStateMemento [
	^ { self position . self localBoundingBox . components collect: [:each | each transformStateMemento ]}
]

{ #category : #transforms }
WDEEntity >> transformWith: transform [
	| rawPosition oldPosition componentTransform |
	rawPosition := self position.
	oldPosition := self validPosition3D.
	self position: (transform transformPosition: self validPosition3D).
	
	componentTransform := transform copy translation: Float32x3 zeros.
	self localBoundingBox: (self localBoundingBox transformedWith: componentTransform).
	components do: [ :each |
		each transformWith: componentTransform
	]
]

{ #category : #transforms }
WDEEntity >> translateBy: translation [
	| rawPosition |
	rawPosition := self position.
	rawPosition class elements = 2 ifTrue: [ 
		self position: rawPosition + translation xy
	] ifFalse: [ 
		self position: rawPosition + translation
	].

]

{ #category : #accessing }
WDEEntity >> treeDisplayName [
	^ self className  ,': ' , self name
]

{ #category : #accessing }
WDEEntity >> validPosition3D [
	| rawPosition |
	rawPosition := self position.
	rawPosition class elements = 2 ifTrue: [ ^ Float32x3 xy: rawPosition z: (self sectorLayer ifNil: [0] ifNotNil: [:l | l defaultZ]) ].
	^ rawPosition
]

{ #category : #events }
WDEEntity >> whenComponentAddedDo: aBlock [
	components whenAddedDo: aBlock
]

{ #category : #events }
WDEEntity >> whenComponentRemovedDo: aBlock [
	components whenRemovedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenLocalBoundingBoxChangedDo: aBlock [
	localBoundingBox whenChangedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenPositionChangedDo: aBlock [
	position whenChangedDo: aBlock
]
