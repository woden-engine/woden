Class {
	#name : #WTGSEntity,
	#superclass : #WTGSMapNode,
	#instVars : [
		'components',
		'numberOfComponents',
		'map',
		'pointEntity',
		'worldEntity',
		'pointEntityNode'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WTGSEntity class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #behaviors }
WTGSEntity >> addBehaviorClass: aClass [
	self addComponent: (WTGSBehaviorClass new behaviorClassName: aClass name)
]

{ #category : #behaviors }
WTGSEntity >> addBehaviorClassName: aClassName [
	self addComponent: (WTGSBehaviorClass new behaviorClassName: aClassName)
]

{ #category : #adding }
WTGSEntity >> addComponent: aComponent [
	| componentsCollection |
	componentsCollection := components at: aComponent bucket ifAbsentPut: [ OrderedCollection new ].
	componentsCollection add: aComponent.
	aComponent addedToEntity: self.
	numberOfComponents := numberOfComponents + 1.
]

{ #category : #adding }
WTGSEntity >> addComponents: newComponents [
	newComponents do: [ :comp | self addComponent: comp ]
]

{ #category : #adding }
WTGSEntity >> addedToMap: aMap [
	map := aMap.
]

{ #category : #adding }
WTGSEntity >> addedToScene: anScene [
	self componentsDo: [ :comp | comp addedToScene: anScene ].
	pointEntity ifTrue: [ self createPointEntityNode ].
]

{ #category : #accessing }
WTGSEntity >> applyTransformation: transformation [
	| spatialDescription |
	spatialDescription := self spatialDescription.
	spatialDescription ifNotNil: [ spatialDescription applyTransformation: transformation ].
]

{ #category : #serialization }
WTGSEntity >> asJsonData [
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
WTGSEntity >> behaviorsDo: aBlock [
	(components at: #behavior ifAbsent: [ ^ self ]) do: aBlock
]

{ #category : #accessing }
WTGSEntity >> boundingBox [
	self spatialDescription ifNotNil: [ :desc | ^ desc boundingBox ].
	^ self localBoundingBox
]

{ #category : #changing }
WTGSEntity >> changedSelectionState [
	pointEntityNode ifNil: [ ^ self ].
	
	pointEntityNode
		color: self currentColor.
]

{ #category : #accessing }
WTGSEntity >> components [
	^ components
]

{ #category : #'iterating elements' }
WTGSEntity >> componentsCollect: aBlock [
	| result |
	result := Array new: numberOfComponents.
	self componentsDoWithIndex: [ :comp :index |
		result at: index put: (aBlock value: comp)
	].
	^ result
]

{ #category : #'iterating elements' }
WTGSEntity >> componentsDo: aBlock [
	components valuesDo: [ :list | list do: aBlock ]
]

{ #category : #'iterating elements' }
WTGSEntity >> componentsDoWithIndex: aBlock [
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
WTGSEntity >> componentsSelect: aBlock [
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
WTGSEntity >> componentsSelect: aBlock thenDo: doBlock [
	components valuesDo: [ :list |
		list do: [:comp |
			(aBlock value: comp) ifTrue: [
				doBlock value: comp
			]
		]
	].

]

{ #category : #'as yet unclassified' }
WTGSEntity >> createPointEntityNode [
	| scene |
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	worldEntity ifTrue: [ ^ self ].
	pointEntityNode ifNotNil: [ ^ self ].
	scene := self scene.
	scene ifNil: [ ^ self ].
	
	pointEntityNode := WTSLocalShapedSpatialObject new.
	pointEntityNode color: self currentColor.
	pointEntityNode shapeTransform: self pointEntityShapeTransform.
	self spatialDescription ifNotNil: [ :desc | pointEntityNode transform: desc transform ].
	map pointEntityInstanceGroup addChild: pointEntityNode.
]

{ #category : #accessing }
WTGSEntity >> currentColor [
	^ selected ifTrue: [ 
		lastSelected ifTrue: [ LastSelectionColor ] ifFalse: [ SelectionColor ]
	] ifFalse: [ Color white ].
]

{ #category : #'as yet unclassified' }
WTGSEntity >> deletePointEntityNode [
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	pointEntityNode ifNil: [ ^ self ].
	pointEntityNode removeFromScene.
	pointEntityNode := nil
]

{ #category : #selection }
WTGSEntity >> elementsAlongRay: ray mode: mode do: aBlock [
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
WTGSEntity >> ensureRenderingModels [
	| nodes |
	nodes := components at: #renderingModels ifAbsentPut: [ OrderedCollection new ].
	nodes isEmpty ifTrue: [
		self addComponent: WTGSRenderingModels new.
	]
]

{ #category : #adding }
WTGSEntity >> ensureSceneNodeOfType: nodeType [
	| nodes |
	nodes := components at: #sceneNode ifAbsentPut: [ OrderedCollection new ].
	(nodes isEmpty or: [ nodes first node class ~~ nodeType]) ifTrue: [
		self flag: 'Notify the removal of the old nodes'.
		nodes removeAll.
		self addComponent: (WTGSSceneNode new node: nodeType new).
	].

	^ nodes first
]

{ #category : #'as yet unclassified' }
WTGSEntity >> ensureSpatialDescription [
	self spatialDescription ifNil: [ self addComponent: WTGSSpatialDescription new ].
]

{ #category : #adding }
WTGSEntity >> ensureSpatialObject [
	^ self ensureSceneNodeOfType: WTSSpatialObject
]

{ #category : #'as yet unclassified' }
WTGSEntity >> findBrushesIntersectingBox: box into: collection [
	| models |
	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model |
		(box intersectsOrContainsBox: model boundingBox) ifTrue: [ collection add: model ]
	]
]

{ #category : #initialization }
WTGSEntity >> initialize [
	super initialize.
	components := IdentityDictionary new.
	numberOfComponents := 0.
	pointEntity := true.
	worldEntity := false.
]

{ #category : #rendering }
WTGSEntity >> invalidateModels [
	self renderingModels ifNotNil: [:models | models invalidate].
]

{ #category : #rendering }
WTGSEntity >> invalidateTexturedModel [
	self renderingModels ifNotNil: [:models | models invalidateTexturedModel ].
]

{ #category : #testing }
WTGSEntity >> isEntity [
	^ true
]

{ #category : #accessing }
WTGSEntity >> isPointSelected [
	^ pointEntity
]

{ #category : #accessing }
WTGSEntity >> lightSource [
	^ (components at: #'light-source' ifAbsent: [ ^ nil ]) first
]

{ #category : #serialization }
WTGSEntity >> loadFromJson: jsonData [
	| comp |
	worldEntity := jsonData at: 'world' ifAbsent: [ false ].
	jsonData at: 'components' ifPresent: [ :componentsJson |
		componentsJson do: [ :componentJson |
			comp := WTGSComponent loadFromJson: componentJson.
			comp ifNotNil: [ self addComponent: comp ]
		]
	]
]

{ #category : #accessing }
WTGSEntity >> localBoundingBox [
	self spatialDescription ifNotNil: [ :desc | ^ desc localBoundingBox ].
	^ WMBox3DD nx: -0.1 ny: -0.1 nz: -0.1 px: 0.1 py: 0.1 pz: 0.1
]

{ #category : #accessing }
WTGSEntity >> map [
	^ map
]

{ #category : #accessing }
WTGSEntity >> numberOfComponents [
	^ numberOfComponents
]

{ #category : #copying }
WTGSEntity >> playModeCopyWith: copiedDictionary [
	| result |
	result := self class new.
	result worldEntity: worldEntity.
		
	self componentsSelect: #isUsedInPlayMode thenDo: [:comp |
		result addComponent: (copiedDictionary at: comp ifAbsentPut: [comp playModeCopyWith: copiedDictionary])
	].

	^ result
]

{ #category : #accessing }
WTGSEntity >> pointEntity [
	^ pointEntity
]

{ #category : #accessing }
WTGSEntity >> pointEntity: anObject [
	pointEntity := anObject.
	pointEntity ifTrue: [ self createPointEntityNode ] ifFalse: [ self deletePointEntityNode ]
]

{ #category : #'as yet unclassified' }
WTGSEntity >> pointEntityShapeTransform [
	^ WMReversibleAffineTransformF identity scaleBy: self localBoundingBox extent asWMVector3F
]

{ #category : #accessing }
WTGSEntity >> position [
	^ self spatialDescription ifNotNil: [ :desc | desc transform translation ] ifNil: [ WMVector3D new ]
]

{ #category : #adding }
WTGSEntity >> removeComponent: aComponent [
	(components at: aComponent bucket ifAbsent: [ ^ self ]) remove: aComponent.
	aComponent removedFromEntity: self.
	numberOfComponents := numberOfComponents - 1.
]

{ #category : #adding }
WTGSEntity >> removeFromMap [
	map removeEntity: self
]

{ #category : #adding }
WTGSEntity >> removedFromMap: aMap [
	map := nil
]

{ #category : #adding }
WTGSEntity >> removedFromScene: anScene [
	(components at: #sceneNode ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	(components at: #renderingModels ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	pointEntity ifTrue: [ self deletePointEntityNode ].
]

{ #category : #accessing }
WTGSEntity >> renderingModels [
	^ (components at: #renderingModels ifAbsent: [ ^ nil ]) first
]

{ #category : #memento }
WTGSEntity >> restoreTransformMemento: memento [
	memento ifNil: [ ^ self ].
	self spatialDescription restoreTransformMemento: memento
]

{ #category : #accessing }
WTGSEntity >> scene [
	map ifNil: [ ^ nil ].
	^ map scene
]

{ #category : #accessing }
WTGSEntity >> sceneNodeComponent [
	^ (components at: #sceneNode ifAbsent: [ ^ nil ]) first
]

{ #category : #accessing }
WTGSEntity >> sceneNodesDo: aBlock [
	pointEntityNode ifNotNil: [ aBlock value: pointEntityNode. ].
	components at: #sceneNode ifPresent: [ :nodes | nodes do: [:node | aBlock value: node node ] ]
]

{ #category : #behaviors }
WTGSEntity >> sendToBehaviors: selector withArguments: arguments [
	(components at: #behavior ifAbsent: [ ^ self ]) do: [ :behavior |
		(behavior respondsTo: selector) ifTrue: [
			behavior perform: selector withArguments: arguments
		]
	]
]

{ #category : #rendering }
WTGSEntity >> simulateTime: delta [
]

{ #category : #accessing }
WTGSEntity >> spatialDescription [
	^ (components at: #spatialDescription ifAbsent: [ ^ nil ]) first
]

{ #category : #'map events' }
WTGSEntity >> spawn [
	| allComponents |
	allComponents := self componentsCollect: #yourself.
	"Copy the list of components because they could be calling spawn recursively."
	allComponents do: #spawn
]

{ #category : #behaviors }
WTGSEntity >> subscribeToTouchEvents [
	self map registerTouchListener: self
]

{ #category : #events }
WTGSEntity >> touch: anEntity [
	self behaviorsDo: [ :behavior | behavior touch: anEntity ]
]

{ #category : #memento }
WTGSEntity >> transformMemento [
	| spatialDesc |
	spatialDesc := self spatialDescription.
	spatialDesc ifNil: [ ^ nil ].
	^ spatialDesc transformMemento
]

{ #category : #behaviors }
WTGSEntity >> unsubscribeToTouchEvents [
	self map unregisterTouchListener: self
]

{ #category : #accessing }
WTGSEntity >> worldEntity [
	^ worldEntity
]

{ #category : #accessing }
WTGSEntity >> worldEntity: anObject [
	worldEntity := anObject
]
