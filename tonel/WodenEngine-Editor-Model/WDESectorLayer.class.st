Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'children',
		'layerMaxZ',
		'layerMinZ'
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
	
	sector isSector2D ifTrue: [ 
		builder
			scalarPropertyNamed: '2D Layer Thickness' selector: #layerThickness;
			scalarPropertyNamed: '2D Layer Z' selector: #layerZ;

			scalarPropertyNamed: '2D Layer Min Z' selector: #layerMinZ;
			scalarPropertyNamed: '2D Layer Max Z' selector: #layerMaxZ
	].

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
	^ self instanceEntityPrototype: WDEEntity bspBoxPrototype withClassName: entityClassName andPlaceInBox: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName box: entityLocation material: material [
	^ (self createSolidEntity: entityClassName box: entityLocation)
		setMaterial: material;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: entityLocation [
	^ self instanceEntityPrototype: WDEEntity extrudedRectanglePrototype withClassName: entityClassName andPlaceInRectangle: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: entityLocation material: material [
	^ (self createSolidEntity: entityClassName rectangle: entityLocation)
		setMaterial: material;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> elementsInBox: box [
	^ children select: [ :each | each isEntity and: [ each intersectsBox: box ] ]
]

{ #category : #serialization }
WDESectorLayer >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#layerMinZ . self layerMinZ.
		#layerMaxZ . self layerMaxZ.
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
	layerMinZ := -1.0.
	layerMaxZ := 1.0.
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: entityPrototype [
	^ entityPrototype copy setupForNewInstance; yourself
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

{ #category : #accessing }
WDESectorLayer >> layerHalfThickness [
	^ self layerThickness * 0.5
]

{ #category : #accessing }
WDESectorLayer >> layerMaxZ [
	^ layerMaxZ
]

{ #category : #accessing }
WDESectorLayer >> layerMaxZ: anObject [
	layerMaxZ := anObject.
	self sectorLayerThicknessChanged
]

{ #category : #accessing }
WDESectorLayer >> layerMinZ [
	^ layerMinZ
]

{ #category : #accessing }
WDESectorLayer >> layerMinZ: anObject [
	layerMinZ := anObject.
	self sectorLayerThicknessChanged
]

{ #category : #accessing }
WDESectorLayer >> layerThickness [
	^ layerMaxZ - layerMinZ
]

{ #category : #accessing }
WDESectorLayer >> layerThickness: newLayerThickness [
	self layerZ: self layerZ thickness: newLayerThickness
]

{ #category : #accessing }
WDESectorLayer >> layerZ [
	^ layerMinZ + ((layerMaxZ  - layerMinZ) * 0.5)
]

{ #category : #accessing }
WDESectorLayer >> layerZ: newZ [
	self layerZ: newZ thickness: self layerThickness
]

{ #category : #accessing }
WDESectorLayer >> layerZ: newZ thickness: thickness [
	| halfThickness |
	halfThickness := thickness * 0.5.
	layerMinZ := newZ - halfThickness.
	layerMaxZ := newZ + halfThickness.
	self sectorLayerThicknessChanged
]

{ #category : #serialization }
WDESectorLayer >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	self
		layerMinZ: (jsonData at: 'layerMinZ' ifAbsent: [self layerMinZ]);
		layerMaxZ: (jsonData at: 'layerMaxZ' ifAbsent: [self layerMaxZ]).

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
