Class {
	#name : #WDGSEntity,
	#superclass : #WDGSMapNode,
	#instVars : [
		'components',
		'numberOfComponents',
		'map',
		'pointEntity',
		'worldEntity',
		'pointEntityNode',
		'spawning'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WDGSEntity class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #behaviors }
WDGSEntity >> addBehaviorClass: aClass [
	self addComponent: (WDGSBehaviorClass new behaviorClassName: aClass name)
]

{ #category : #behaviors }
WDGSEntity >> addBehaviorClassName: aClassName [
	self addComponent: (WDGSBehaviorClass new behaviorClassName: aClassName)
]

{ #category : #adding }
WDGSEntity >> addComponent: aComponent [
	| componentsCollection |
	componentsCollection := components at: aComponent bucket ifAbsentPut: [ OrderedCollection new ].
	componentsCollection add: aComponent.
	aComponent addedToEntity: self.
	numberOfComponents := numberOfComponents + 1.
	self scene ifNotNil: [ :scene | aComponent addedToScene: scene ].
	self isSpawning ifTrue: [ aComponent spawn ]
]

{ #category : #adding }
WDGSEntity >> addComponents: newComponents [
	newComponents do: [ :comp | self addComponent: comp ]
]

{ #category : #adding }
WDGSEntity >> addedToMap: aMap [
	map := aMap.
]

{ #category : #adding }
WDGSEntity >> addedToScene: anScene [
	self componentsDo: [ :comp | comp addedToScene: anScene ].
	pointEntity ifTrue: [ self createPointEntityNode ].
]

{ #category : #accessing }
WDGSEntity >> applyTransformation: transformation [
	| spatialDescription |
	spatialDescription := self spatialDescription.
	spatialDescription ifNotNil: [ spatialDescription applyTransformation: transformation ].
]

{ #category : #serialization }
WDGSEntity >> asJsonData [
	| compJson |
	^ OrderedDictionary newFromPairs: {
		'world' . worldEntity .
		'components' . Array streamContents: [:out | 
			components valuesDo: [:list |
				list do: [:comp |
					compJson := comp asJsonData.
					compJson ifNotNil: [ out nextPut: compJson ].
				] 
			]
		]
	 }
]

{ #category : #behaviors }
WDGSEntity >> behaviorsDo: aBlock [
	(components at: #behavior ifAbsent: [ ^ self ]) do: aBlock
]

{ #category : #accessing }
WDGSEntity >> boundingBox [
	self spatialDescription ifNotNil: [ :desc | ^ desc boundingBox ].
	^ self localBoundingBox
]

{ #category : #accessing }
WDGSEntity >> cameraSceneNode [
	^ self view ifNotNil: [ :view | view cameraSceneNode ]
]

{ #category : #changing }
WDGSEntity >> changedSelectionState [
	pointEntityNode ifNil: [ ^ self ].
	
	pointEntityNode
		color: self currentColor.
]

{ #category : #accessing }
WDGSEntity >> components [
	^ components
]

{ #category : #'iterating elements' }
WDGSEntity >> componentsCollect: aBlock [
	| result |
	result := Array new: numberOfComponents.
	self componentsDoWithIndex: [ :comp :index |
		result at: index put: (aBlock value: comp)
	].
	^ result
]

{ #category : #'iterating elements' }
WDGSEntity >> componentsDo: aBlock [
	components valuesDo: [ :list | list do: aBlock ]
]

{ #category : #'iterating elements' }
WDGSEntity >> componentsDoWithIndex: aBlock [
	| index |
	index := 1.
	components valuesDo: [ :list |
		list do: [:comp |
			aBlock value: comp value: index.
			index := index + 1
		]
	]
]

{ #category : #'iterating elements' }
WDGSEntity >> componentsSelect: aBlock [
	| result |
	result := OrderedCollection new.
	components valuesDo: [ :list |
		list do: [:comp |
			(aBlock value: comp) ifTrue: [
				result add: comp
			]
		]
	].

	^ result
]

{ #category : #'iterating elements' }
WDGSEntity >> componentsSelect: aBlock thenDo: doBlock [
	components valuesDo: [ :list |
		list do: [:comp |
			(aBlock value: comp) ifTrue: [
				doBlock value: comp
			]
		]
	].

]

{ #category : #'as yet unclassified' }
WDGSEntity >> createPointEntityNode [
	| scene |
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	worldEntity ifTrue: [ ^ self ].
	pointEntityNode ifNotNil: [ ^ self ].
	scene := self scene.
	scene ifNil: [ ^ self ].
	
	pointEntityNode := WDSGLocalShapedSpatialObject new.
	pointEntityNode color: self currentColor.
	pointEntityNode shapeTransform: self pointEntityShapeTransform.
	self spatialDescription ifNotNil: [ :desc | pointEntityNode transform: desc transform ].
	map pointEntityInstanceGroup addChild: pointEntityNode.
]

{ #category : #accessing }
WDGSEntity >> currentColor [
	^ selected ifTrue: [ 
		lastSelected ifTrue: [ LastSelectionColor ] ifFalse: [ SelectionColor ]
	] ifFalse: [ Color white ].
]

{ #category : #'as yet unclassified' }
WDGSEntity >> deletePointEntityNode [
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	pointEntityNode ifNil: [ ^ self ].
	pointEntityNode removeFromScene.
	pointEntityNode := nil
]

{ #category : #selection }
WDGSEntity >> elementsAlongRay: ray mode: mode do: aBlock [
	| models distance result localRay spatialDescription |
	localRay := ray.
	spatialDescription := self spatialDescription.
	spatialDescription ifNotNil: [ 
		localRay := ray transformedWithInverseOf: spatialDescription transform.
	].

	(mode == #entity and: [ worldEntity not ]) ifTrue: [
		distance := localRay intersectionDistanceWithBox: self localBoundingBox.
		distance ifNil: [ ^ self ].
		result := ray testResultForDistance: distance value: self.
		^ aBlock value: result
	].

	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model | model elementsAlongRay: localRay mode: mode do: aBlock ]
]

{ #category : #adding }
WDGSEntity >> ensurePhysicsComponent [
	| nodes component |
	nodes := components at: #physicsComponent ifAbsentPut: [ OrderedCollection new ].
	nodes isEmpty ifTrue: [
		component := WDGSPhysicsComponent new.
		self setupPhysicsComponent: component.
		self addComponent: component.
	].
]

{ #category : #adding }
WDGSEntity >> ensureRenderingModels [
	| nodes |
	nodes := components at: #renderingModels ifAbsentPut: [ OrderedCollection new ].
	nodes isEmpty ifTrue: [
		self addComponent: WDGSRenderingModels new.
	]
]

{ #category : #adding }
WDGSEntity >> ensureSceneNodeOfType: nodeType [
	| nodes |
	nodes := components at: #sceneNode ifAbsentPut: [ OrderedCollection new ].
	(nodes isEmpty or: [ nodes first node class ~~ nodeType]) ifTrue: [
		self flag: 'Notify the removal of the old nodes'.
		nodes removeAll.
		self addComponent: (WDGSSceneNode new node: nodeType new).
	].

	^ nodes first
]

{ #category : #'as yet unclassified' }
WDGSEntity >> ensureSpatialDescription [
	self spatialDescription ifNil: [ self addComponent: WDGSSpatialDescription new ].
]

{ #category : #adding }
WDGSEntity >> ensureSpatialObject [
	^ self ensureSceneNodeOfType: WDSGSpatialObject
]

{ #category : #'as yet unclassified' }
WDGSEntity >> findBrushesIntersectingBox: box into: collection [
	| models |
	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model |
		(box intersectsOrContainsBox: model boundingBox) ifTrue: [ collection add: model ]
	]
]

{ #category : #initialization }
WDGSEntity >> initialize [
	super initialize.
	components := IdentityDictionary new.
	numberOfComponents := 0.
	pointEntity := true.
	worldEntity := false.
	spawning := false.
]

{ #category : #rendering }
WDGSEntity >> invalidateModels [
	self renderingModels ifNotNil: [:models | models invalidate].
	self physicsComponent ifNotNil: [:models | models invalidate].
]

{ #category : #rendering }
WDGSEntity >> invalidateTexturedModel [
	self renderingModels ifNotNil: [:models | models invalidateTexturedModel ].
]

{ #category : #testing }
WDGSEntity >> isEntity [
	^ true
]

{ #category : #accessing }
WDGSEntity >> isPointSelected [
	^ pointEntity
]

{ #category : #testing }
WDGSEntity >> isSpawning [
	^ spawning
]

{ #category : #accessing }
WDGSEntity >> lightSource [
	^ (components at: #'light-source' ifAbsent: [ ^ nil ]) first
]

{ #category : #serialization }
WDGSEntity >> loadFromJson: jsonData [
	| comp |
	worldEntity := jsonData at: 'world' ifAbsent: [ false ].
	jsonData at: 'components' ifPresent: [ :componentsJson |
		componentsJson do: [ :componentJson |
			comp := WDGSComponent loadFromJson: componentJson.
			comp ifNotNil: [ self addComponent: comp ]
		]
	]
]

{ #category : #accessing }
WDGSEntity >> localBoundingBox [
	self spatialDescription ifNotNil: [ :desc | ^ desc localBoundingBox ].
	^ WMBox3DD nx: -0.1 ny: -0.1 nz: -0.1 px: 0.1 py: 0.1 pz: 0.1
]

{ #category : #accessing }
WDGSEntity >> map [
	^ map
]

{ #category : #accessing }
WDGSEntity >> numberOfComponents [
	^ numberOfComponents
]

{ #category : #accessing }
WDGSEntity >> physicsComponent [
	^ (components at: #physicsComponent ifAbsent: [ ^ nil ]) first
]

{ #category : #copying }
WDGSEntity >> playModeCopyWith: copiedDictionary [
	| result |
	result := self class new.
	result worldEntity: worldEntity.
		
	self componentsSelect: #isUsedInPlayMode thenDo: [:comp |
		result addComponent: (copiedDictionary at: comp ifAbsentPut: [comp playModeCopyWith: copiedDictionary])
	].

	^ result
]

{ #category : #accessing }
WDGSEntity >> pointEntity [
	^ pointEntity
]

{ #category : #accessing }
WDGSEntity >> pointEntity: anObject [
	pointEntity := anObject.
	pointEntity ifTrue: [ self createPointEntityNode ] ifFalse: [ self deletePointEntityNode ]
]

{ #category : #'as yet unclassified' }
WDGSEntity >> pointEntityShapeTransform [
	^ WMReversibleAffineTransformF identity scaleBy: self localBoundingBox extent asWMVector3F
]

{ #category : #accessing }
WDGSEntity >> position [
	^ self spatialDescription ifNotNil: [ :desc | desc transform translation ] ifNil: [ WMVector3D new ]
]

{ #category : #adding }
WDGSEntity >> removeComponent: aComponent [
	(components at: aComponent bucket ifAbsent: [ ^ self ]) remove: aComponent.
	aComponent removedFromEntity: self.
	numberOfComponents := numberOfComponents - 1.
]

{ #category : #adding }
WDGSEntity >> removeFromMap [
	map removeEntity: self
]

{ #category : #adding }
WDGSEntity >> removedFromMap: aMap [
	map := nil
]

{ #category : #adding }
WDGSEntity >> removedFromScene: anScene [
	(components at: #sceneNode ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	(components at: #renderingModels ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	pointEntity ifTrue: [ self deletePointEntityNode ].
]

{ #category : #accessing }
WDGSEntity >> renderingModels [
	^ (components at: #renderingModels ifAbsent: [ ^ nil ]) first
]

{ #category : #memento }
WDGSEntity >> restoreTransformMemento: memento [
	memento ifNil: [ ^ self ].
	self spatialDescription restoreTransformMemento: memento
]

{ #category : #accessing }
WDGSEntity >> scene [
	map ifNil: [ ^ nil ].
	^ map scene
]

{ #category : #accessing }
WDGSEntity >> sceneNodeComponent [
	^ (components at: #sceneNode ifAbsent: [ ^ nil ]) first
]

{ #category : #accessing }
WDGSEntity >> sceneNodesDo: aBlock [
	pointEntityNode ifNotNil: [ aBlock value: pointEntityNode. ].
	components at: #sceneNode ifPresent: [ :nodes | nodes do: [:node | aBlock value: node node ] ]
]

{ #category : #behaviors }
WDGSEntity >> sendToBehaviors: selector withArguments: arguments [
	(components at: #behavior ifAbsent: [ ^ self ]) do: [ :behavior |
		(behavior respondsTo: selector) ifTrue: [
			behavior perform: selector withArguments: arguments
		]
	]
]

{ #category : #physics }
WDGSEntity >> setupPhysicsComponent: aComponent [
	self behaviorsDo: [ :behavior | behavior setupPhysicsComponent: aComponent ]
]

{ #category : #rendering }
WDGSEntity >> simulateTime: delta [
]

{ #category : #accessing }
WDGSEntity >> spatialDescription [
	^ (components at: #spatialDescription ifAbsent: [ ^ nil ]) first
]

{ #category : #'map events' }
WDGSEntity >> spawn [
	| allComponents |
	spawning := true.
	[ 
		allComponents := self componentsCollect: #yourself.
		"Copy the list of components because they could be calling spawn recursively."
		allComponents do: #spawn
	] ensure: [ spawning := false ].

]

{ #category : #behaviors }
WDGSEntity >> subscribeToTouchEvents [
	self map registerTouchListener: self
]

{ #category : #events }
WDGSEntity >> touch: anEntity [
	self behaviorsDo: [ :behavior | behavior touch: anEntity ]
]

{ #category : #memento }
WDGSEntity >> transformMemento [
	| spatialDesc |
	spatialDesc := self spatialDescription.
	spatialDesc ifNil: [ ^ nil ].
	^ spatialDesc transformMemento
]

{ #category : #behaviors }
WDGSEntity >> unsubscribeToTouchEvents [
	self map unregisterTouchListener: self
]

{ #category : #accessing }
WDGSEntity >> view [
	^ (components at: #'view' ifAbsent: [ ^ nil ]) first view
]

{ #category : #accessing }
WDGSEntity >> worldEntity [
	^ worldEntity
]

{ #category : #accessing }
WDGSEntity >> worldEntity: anObject [
	worldEntity := anObject
]
