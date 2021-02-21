Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'defaultMinZ',
		'defaultMaxZ',
		'children'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDESectorLayer >> accept: visitor [
	^ visitor visitSectorLayer: self
]

{ #category : #removing }
WDESectorLayer >> addChild: aChild [
	self addEntity: aChild
]

{ #category : #adding }
WDESectorLayer >> addEntity: anEntity [
	self assert: anEntity isEntity.
	self assert: anEntity sectorLayer isNil.
	children add: anEntity.
	anEntity parent: self.
	self level ifNotNil: [ :level | anEntity addedToLevel: level ].
]

{ #category : #accessing }
WDESectorLayer >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		scalarPropertyNamed: '2D Min Z' selector: #defaultMinZ;
		scalarPropertyNamed: '2D Max Z' selector: #defaultMaxZ
]

{ #category : #accessing }
WDESectorLayer >> children [
	^ children
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createPointEntity: entityClassName at: entityLocation [
	^ self instanceEntityPrototype: WDEEntity pointPrototype withClassName: entityClassName andPlaceAt: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName box: entityLocation [
	^ self instanceEntityPrototype: WDEEntity solidWall3DPrototype withClassName: entityClassName andPlaceInBox: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName box: entityLocation material: material [
	^ (self createSolidEntity: entityClassName box: entityLocation)
		setMaterial: material;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: entityLocation [
	^ self instanceEntityPrototype: WDEEntity solidWall2DPrototype withClassName: entityClassName andPlaceInRectangle: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: entityLocation material: material [
	^ (self createSolidEntity: entityClassName rectangle: entityLocation)
		setMaterial: material;
		yourself
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ [
	^ defaultMaxZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ: anObject [
	defaultMaxZ := anObject.
	self sectorLayerThicknessChanged
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ [
	^ defaultMinZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ: anObject [
	defaultMinZ := anObject.
	self sectorLayerThicknessChanged
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultThickness: defaultThickness [
	defaultMinZ := defaultThickness * -0.5.
	defaultMaxZ := defaultThickness * 0.5.
	self sectorLayerThicknessChanged
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultZ [
	^ defaultMinZ + ((defaultMaxZ  - defaultMinZ) /2)
]

{ #category : #serialization }
WDESectorLayer >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#defaultMinZ . self defaultMinZ.
		#defaultMaxZ . self defaultMaxZ.
		#children . children collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #accessing }
WDESectorLayer >> entities [
	^ children
]

{ #category : #initialization }
WDESectorLayer >> initialize [
	super initialize.
	children := OrderedCollection new.
	defaultMinZ := -1.0.
	defaultMaxZ := 1.0.
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: entityPrototype [
	^ entityPrototype copy
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype andPlaceAt: entityLocation [
	| entity |
	entity := self instanceEntityPrototype: prototype.
	(entity isPointEntity and: [ self isInSector2D ]) ifTrue: [
		entity makeEntity2D
	].

	entity placeInPosition: entityLocation.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype andPlaceInBox: placementBox [
	| entity |
	entity := self instanceEntityPrototype: prototype.
	entity placeInBox: placementBox.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype andPlaceInRectangle: placementRectangle [
	| entity |
	entity := self instanceEntityPrototype: prototype.
	entity placeInRectangle: placementRectangle.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: entityPrototype withClassName: newClassName [
	^ entityPrototype copy
		className: newClassName;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceAt: entityLocation [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInPosition: entityLocation.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceInBox: placementBox [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInBox: placementBox.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceInRectangle: placementRectangle [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInRectangle: placementRectangle.
	self addEntity: entity.
	^ entity
]

{ #category : #testing }
WDESectorLayer >> isInSector2D [
	^ sector isSector2D
]

{ #category : #testing }
WDESectorLayer >> isSectorLayer [
	^ true
]

{ #category : #serialization }
WDESectorLayer >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	self
		defaultMinZ: (jsonData at: 'defaultMinZ' ifAbsent: [self defaultMinZ]);
		defaultMaxZ: (jsonData at: 'defaultMaxZ' ifAbsent: [self defaultMaxZ]).

	jsonData at: 'children' ifPresent: [ :childrenData |
		childrenData do: [ :each |
			self addEntity: (WDELevelElement loadFromJson: each context: context)
		]
	]
]

{ #category : #accessing }
WDESectorLayer >> parent [
	^ sector
]

{ #category : #removing }
WDESectorLayer >> removeChild: aChild [
	self removeEntity: aChild
]

{ #category : #adding }
WDESectorLayer >> removeEntity: anEntity [
	self assert: anEntity isEntity.
	self assert: anEntity sectorLayer == self.
	children remove: anEntity.
	self level ifNotNil: [ :level | anEntity removedFromLevel: level ].
	anEntity parent: nil.
]

{ #category : #accessing }
WDESectorLayer >> sector [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector: anObject [
	sector := anObject
]

{ #category : #accessing }
WDESectorLayer >> sectorLayer [
	^ self
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> validateMaterialList [
	children do: [ :each | each validateMaterialList ]
]
