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
		'dimensionalityMode',
		'orientation',
		'transform',
		'editorColor'
	],
	#classVars : [
		'EditorColorPalette',
		'EditorColorPaletteLastGeneratedColor',
		'EditorColorPaletteRandomGenerator',
		'PointEntitySelectionBoxHalfExtent'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'basic entity prototypes' }
WDEEntity class >> defaultColor [
	^ Color r: 0.8 g: 0.8 b: 0.8
]

{ #category : #'basic entity prototypes' }
WDEEntity class >> directionalLightPrototype [
	^ self new
		className: #DirectionalLight;
		orientation: QuaternionF32 lookAtBottom;
		addComponent: (WDEVisualComponent directionalLight);
		yourself
]

{ #category : #serialization }
WDEEntity class >> generateEditorColor [
	| newColor |
	[
		newColor := EditorColorPalette atRandom: EditorColorPaletteRandomGenerator
	] doWhileTrue: [ EditorColorPaletteLastGeneratedColor = newColor ].
	^ (EditorColorPaletteLastGeneratedColor := newColor) asFloat32x4
]

{ #category : #serialization }
WDEEntity class >> initialize [
	EditorColorPalette := Color wheel: 13.
	EditorColorPaletteRandomGenerator := Random seed: 1.
	EditorColorPaletteLastGeneratedColor := nil.
	PointEntitySelectionBoxHalfExtent := Float32x3 ones * 0.2 .
]

{ #category : #serialization }
WDEEntity class >> pointEntitySelectionBoxHalfExtent [
	^ PointEntitySelectionBoxHalfExtent
]

{ #category : #'basic entity prototypes' }
WDEEntity class >> pointLightPrototype [
	^ self new
		className: #PointLight;
		addComponent: (WDEVisualComponent pointLight);
		yourself
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
		addComponent: (WDEVisualComponent rectangle: RectangleF32 unitRectangle);
		addComponent: WDECollisionComponent polygonConvexHull;
		yourself

]

{ #category : #'basic entity prototypes' }
WDEEntity class >> solidWall3DPrototype [
	^ self new
		makeEntity3D;
		className: 'Wall';
		localBoundingBox: BoxF32 unitBox;
		addComponent: (WDEVisualComponent box: BoxF32 unitBox);
		addComponent: WDECollisionComponent polyhedronConvexHull;
		yourself

]

{ #category : #'basic entity prototypes' }
WDEEntity class >> spotLightPrototype [
	^ self new
		className: #SpotLight;
		orientation: QuaternionF32 lookAtBottom;
		addComponent: (WDEVisualComponent spotLight);
		yourself
]

{ #category : #visiting }
WDEEntity >> accept: visitor [
	^ visitor visitEntity: self
]

{ #category : #adding }
WDEEntity >> addChild: aChild [
	self addComponent: aChild
]

{ #category : #adding }
WDEEntity >> addComponent: aComponent [
	self assert: aComponent isEntityComponent.
	self assert: aComponent parent isNil.
	components add: aComponent.
	aComponent parent: self.
	self level ifNotNil: [ :level | aComponent addedToLevel: level ].
]

{ #category : #accessing }
WDEEntity >> boundingBox [
	^ boundingBox ifNil: [ boundingBox := self localBoundingBoxWithDepth transformedWith: self transform ]
]

{ #category : #accessing }
WDEEntity >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		stringPropertyNamed: 'Class Name' selector: #className;
		vector3PropertyNamed: 'Position' selector: #position;
		quaternionPropertyNamed: 'Orientation' selector: #orientation;
		propertyNamed: 'Dimensionality Mode' selector: #dimensionalityMode alternatives: [WDELevelElementDimensionalityMode alternatives];
		linearColor4PropertyNamed: 'Editor color' selector: #editorColor.
]

{ #category : #testing }
WDEEntity >> canBeDuplicatedAndPlacedInLayer [
	^ true
]

{ #category : #testing }
WDEEntity >> canBeSubtracted [
	^ self visualComponent ifNil: [ false ] ifNotNil: [ :comp | comp canBeSubtracted ]
]

{ #category : #testing }
WDEEntity >> canBeUsedForSubtraction [
	^ self visualComponent ifNil: [false] ifNotNil: [ :comp | comp canBeUsedForSubtraction ]
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
	className := anObject.
	"Trigger the bounding box change event to recompute the selectable bounding box."
	self localBoundingBox: self localBoundingBox
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
WDEEntity >> computeLocalSelectableBoundingBox [
	localSelectableBoundingBox := BoxF32 center: self localBoundingBoxWithDepth center halfExtent: (self localBoundingBoxWithDepth halfExtent max: self class pointEntitySelectionBoxHalfExtent).

	self isPointEntity ifTrue: [ 
		self gameEntityDescriptions ifNotNil: [ :descs |
			(descs boundingBoxForEntityWithClassName: className) ifNotNil: [ :bbox |
				localSelectableBoundingBox := localSelectableBoundingBox unionWith: bbox
			]
		]
	].

]

{ #category : #accessing }
WDEEntity >> createSimilarButWithVisualComponent: otherVisualComponent [
	| result myVisualComponentCenter otherCenter localCenterOffset centerOffset centeredVisualComponent |
	myVisualComponentCenter := self visualComponent boundingBox center.
	
	otherCenter := otherVisualComponent boundingBox center.
	localCenterOffset := myVisualComponentCenter - otherCenter.
	centerOffset := self transform transformVector: localCenterOffset.
	
	centeredVisualComponent := otherVisualComponent copy translateBy: localCenterOffset negated.

	result := self class new
		setupForNewInstance;
		name: self name;
		className: self className;
		dimensionalityMode: self dimensionalityMode;
		localBoundingBox: centeredVisualComponent boundingBox;
		position: self position + centerOffset;
		orientation: self orientation;
		yourself.
	result addComponent: centeredVisualComponent.
	components do: [ :each |
		each isVisualComponent ifFalse: [ 
			result addComponent: (each makeSimilarForEntity: result)
		].
	].
	^ result
]

{ #category : #initialization }
WDEEntity >> destroyAnnouncers [
	super destroyAnnouncers.
	components destroyAnnouncer.
	position destroyAnnouncer.
	editorColor destroyAnnouncer.
	localBoundingBox destroyAnnouncer.
]

{ #category : #accessing }
WDEEntity >> dimensionalityMode [
	^ dimensionalityMode
]

{ #category : #accessing }
WDEEntity >> dimensionalityMode: anObject [
	dimensionalityMode := anObject
]

{ #category : #accessing }
WDEEntity >> editorColor [
	^ editorColor value
]

{ #category : #accessing }
WDEEntity >> editorColor: aColor [
	editorColor value: aColor asFloat32x4.
	self editorColorChanged.
	
]

{ #category : #private }
WDEEntity >> editorColorChanged [
]

{ #category : #serialization }
WDEEntity >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#className . self className.
		#name . self name.
		#dimensions . self dimensionalityMode name.
		#position . self position encodeForJSON.
		#orientation . self orientation encodeForJSON.
		#localBoundingBox . self localBoundingBox encodeForJSON.
		#editorColor . self editorColor encodeForJSON.
		#components . self components collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #serialization }
WDEEntity >> generateEditorColor [
	self editorColor: self class generateEditorColor
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	components := OrderedCollection new asValueHolder.
	dimensionalityMode := WDELevelElementDimensionalityMode mode3D.
	position := Float32x3 zeros asValueHolder.
	orientation := QuaternionF32 identity asValueHolder.
	localBoundingBox := (BoxF32 point: Float32x3 zeros) asValueHolder.
	editorColor := Float32x4 ones asValueHolder.
]

{ #category : #'ray casting' }
WDEEntity >> intersectsBox: box [
	self selectableBoundingBox isEmpty ifTrue: [ ^ false ].
	
	^ box hasIntersectionWithBox: self selectableBoundingBox
]

{ #category : #'ray casting' }
WDEEntity >> intersectsFrustum: frustum [
	self selectableBoundingBox isEmpty ifTrue: [ ^ false ].
	
	^ frustum intersectsOrContainsBox: self selectableBoundingBox
]

{ #category : #'as yet unclassified' }
WDEEntity >> intersectsWithEntity: otherEntity [
	^ self intersectsBox: otherEntity boundingBox
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

{ #category : #testing }
WDEEntity >> isSectorLevelComponentEntity [
	(self name isEmpty and: [
		self components isNotEmpty and: [
		self components allSatisfy: [:each | each isVisualComponent or: [ each isCollisionComponent]]
		]]) ifTrue: [ ^ true ].

	^ #(Wall) includes: className
]

{ #category : #serialization }
WDEEntity >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	self
		className: (jsonData at: 'className' ifAbsent: ['']);
		name: (jsonData at: 'name' ifAbsent: ['']).
	jsonData at: 'dimensions' ifPresent: [ :data |
		self dimensionalityMode: (WDELevelElementDimensionalityMode named: data)
	].

	jsonData at: 'orientation' ifPresent: [ :data |
		self orientation: (QuaternionF32 loadFromJson: data)
	].

	jsonData at: 'position' ifPresent: [ :data |
		data size = 2 ifTrue: [
			self position: (Float32x3 xy: (Float32x2 loadFromJson: data) z: 0.0)
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

	self generateEditorColor.
	jsonData at: 'editorColor' ifPresent: [ :data |
		self editorColor: (Float32x4 loadFromJson: data)
	].

	jsonData at: 'components' ifPresent: [ :componentData |
		componentData do: [ :each |
			self addComponent: (WDELevelElement loadFromJson: each context: context)
		]
	].

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
			| halfThickness |
			halfThickness := self sectorLayer layerHalfThickness.
			localBoundingBoxWithDepth := BoxF32 min: (rawBox min copy z: halfThickness negated)
				max: (rawBox max copy z: halfThickness)
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
	localSelectableBoundingBox ifNil: [ self computeLocalSelectableBoundingBox ].
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

{ #category : #memento }
WDEEntity >> materialStateMemento [
	^ components collect: [:each | each transformStateMemento ]
]

{ #category : #private }
WDEEntity >> notifyComponentsAboutTransformChange [
	components do: [ :each | each entityTransformChanged ].
]

{ #category : #accessing }
WDEEntity >> orientation [
	^ orientation value
]

{ #category : #accessing }
WDEEntity >> orientation: newOrientation [
	self orientationChanged.
	orientation value: newOrientation.
	self notifyComponentsAboutTransformChange.
]

{ #category : #private }
WDEEntity >> orientationChanged [
	self transformChanged
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
	position value: sanitizedPosition.
	self notifyComponentsAboutTransformChange.
]

{ #category : #private }
WDEEntity >> positionChanged [
	self transformChanged.
]

{ #category : #copying }
WDEEntity >> postCopy [
	| oldComponents oldPosition oldLocalBoundingBox oldEditorColor |
	super postCopy.
	parent := nil.
	oldComponents := components value.
	oldPosition := position value.
	oldLocalBoundingBox := localBoundingBox value.
	oldEditorColor := editorColor value.
	position := oldPosition asValueHolder.
	editorColor := oldEditorColor asValueHolder.
	localBoundingBox := oldLocalBoundingBox asValueHolder.
	components := OrderedCollection new asValueHolder.
	oldComponents do: [:each | self addComponent: each copy ]
		
]

{ #category : #accessing }
WDEEntity >> propertyPages [
	^ (super propertyPages , (self components collect: #propertyPages)) flattened
]

{ #category : #'ray casting' }
WDEEntity >> rayCast: ray [
	| distance |
	self selectableBoundingBox isEmpty ifTrue: [ ^ nil ].
	
	distance := selectableBoundingBox intersectionWithRay: ray.
	distance ifNil: [ ^ nil ].
	^ distance -> self.
]

{ #category : #'ray casting' }
WDEEntity >> rayCastAllAlong: ray [
	| distance |
	self selectableBoundingBox isEmpty ifTrue: [ ^ #() ].
	
	distance := selectableBoundingBox intersectionWithRay: ray.
	distance ifNil: [ ^ #() ].
	^ {distance -> self}.
]

{ #category : #adding }
WDEEntity >> removeChild: aChild [
	self removeComponent: aChild
]

{ #category : #adding }
WDEEntity >> removeComponent: aComponent [
	self assert: aComponent isEntityComponent.
	self assert: aComponent parent == self.
	components remove: aComponent.
	self level ifNotNil: [ :level | aComponent removedFromLevel: level ].
	aComponent parent: nil.

]

{ #category : #memento }
WDEEntity >> restoreMaterialStateMemento: memento [
	self assert: memento size = components size.
	components doWithIndex: [ :eachComponent :index |
		eachComponent restoreMaterialStateMemento: (memento at: index)
	]
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

{ #category : #'as yet unclassified' }
WDEEntity >> sectorLayerThicknessChanged [
	self is2DLevelElement ifTrue: [
		self localBoundingBoxChanged; transformChanged.
		position valueChanged.
	].
	super sectorLayerThicknessChanged
]

{ #category : #accessing }
WDEEntity >> selectableBoundingBox [
	^ selectableBoundingBox ifNil: [ selectableBoundingBox := self localSelectableBoundingBox translatedBy: self validPosition3D ]
]

{ #category : #accessing }
WDEEntity >> setMaterial: aMaterial [
	self components do: [ :each |
		each setMaterial: aMaterial
	]
]

{ #category : #serialization }
WDEEntity >> setupForNewInstance [
	self generateEditorColor
]

{ #category : #'as yet unclassified' }
WDEEntity >> subtract: otherEntity [
	| myVisualComponent otherVisualComponent otherTransformIntoMe subtractionResult |
	myVisualComponent := self visualComponent.
	myVisualComponent ifNil: [ ^ { self } ].
	
	otherVisualComponent := otherEntity visualComponent.
	otherVisualComponent ifNil: [ ^ { self } ].

	otherTransformIntoMe := self transform inverseTransformTransform: otherEntity transform.
	subtractionResult := myVisualComponent subtract: otherVisualComponent withTransform: otherTransformIntoMe.
	(subtractionResult size = 1 and: [ subtractionResult first == myVisualComponent ]) ifTrue: [ ^ { self } ].
	
	^ subtractionResult collect: [ :each | self createSimilarButWithVisualComponent: each ]
]

{ #category : #transforming }
WDEEntity >> transform [
	^ transform ifNil: [transform := ReversibleAffineTransform3dF32 new
		orthonormal: self orientation asFloat32x3x3 translation: self validPosition3D;
		yourself
	]
]

{ #category : #private }
WDEEntity >> transformChanged [
	transform := nil.
	selectableBoundingBox := nil.
	boundingBox := nil.
]

{ #category : #memento }
WDEEntity >> transformStateMemento [
	^ { self position . self localBoundingBox . components collect: [:each | each transformStateMemento ]}
]

{ #category : #transforms }
WDEEntity >> transformWith: transformToApply [
	| rawPosition oldPosition componentTransform |
	rawPosition := self position.
	oldPosition := self validPosition3D.
	self position: (transformToApply transformPosition: self validPosition3D).
	
	componentTransform := transformToApply copy translation: Float32x3 zeros.
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
	self is2DLevelElement ifTrue: [ ^ Float32x3 xy: rawPosition xy z: (self sectorLayer ifNil: [0] ifNotNil: [:l | l layerZ]) ].
	^ rawPosition
]

{ #category : #'as yet unclassified' }
WDEEntity >> validateMaterialList [
	components do: [ :each | each validateMaterialList ]
]

{ #category : #accessing }
WDEEntity >> visualComponent [
	| found |
	found := nil.
	components do: [ :each |
		each isVisualComponent ifTrue: [ 
			found ifNotNil: [ ^ nil ].
			found := each.
		]
	].
	^ found
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
WDEEntity >> whenEditorColorChangedDo: aBlock [
	editorColor whenChangedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenEditorColorChangedDoNow: aBlock [
	self whenEditorColorChangedDo: aBlock.
	aBlock value
]

{ #category : #enumerating }
WDEEntity >> whenLocalBoundingBoxChangedDo: aBlock [
	localBoundingBox whenChangedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenOrientationChangedDo: aBlock [
	orientation whenChangedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenPositionChangedDo: aBlock [
	position whenChangedDo: aBlock
]

{ #category : #enumerating }
WDEEntity >> whenTransformChangedDo: aBlock [
	| adaptBlock |
	adaptBlock := [ aBlock cull: self transform ].
	self
		whenOrientationChangedDo: adaptBlock;
		whenPositionChangedDo: adaptBlock
]
