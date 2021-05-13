Class {
	#name : #WDELevel,
	#superclass : #WDELevelElement,
	#instVars : [
		'sectors',
		'announcer',
		'materials',
		'textures',
		'textureSet',
		'materialSet',
		'gameSettings'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #requirements }
WDELevel class >> empty [
	^ self new
		addSector: (WDESector new
				addLayer: (WDESectorLayer new
					yourself);
			yourself);
		yourself
]

{ #category : #serialization }
WDELevel class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #serialization }
WDELevel class >> loadFromJsonString: jsonString [
	^ self loadFromJson: (NeoJSONReader fromString: jsonString)
]

{ #category : #serialization }
WDELevel class >> loadMessagePack: messagePack [
	^ self loadFromJson: (SLVMMessagePackDecoder decode: messagePack)
]

{ #category : #visiting }
WDELevel >> accept: visitor [
	^ visitor visitLevel: self
]

{ #category : #adding }
WDELevel >> addChild: aChild [
	self addSector: aChild
]

{ #category : #adding }
WDELevel >> addSector: aSector [
	self assert: aSector isSector.
	self assert: aSector level isNil.
	sectors add: aSector.
	aSector level: self.
	aSector addedToLevel: self.
]

{ #category : #'ray casting' }
WDELevel >> allEntitiesDo: aBlock [
	self sectors do: [ :eachSector |
		eachSector layers do: [ :eachLayer |
			eachLayer entities do: aBlock
		].
	].

]

{ #category : #'ray casting' }
WDELevel >> allVisibleEntitiesDo: aBlock [
	self sectors select: [:each | each visibleInEditor ] thenDo: [ :eachSector |
		eachSector layers select: [:each | each visibleInEditor ] thenDo: [ :eachLayer |
			eachLayer entities select: [:each | each visibleInEditor ] thenDo: aBlock
		].
	].

]

{ #category : #'as yet unclassified' }
WDELevel >> announceAddedElement: anElement [
	announcer announce: (WDEAddedElementAnnouncement new element: anElement)
]

{ #category : #'as yet unclassified' }
WDELevel >> announceRemovedElement: anElement [
	announcer announce: (WDERemovedElementAnnouncement new element: anElement)
]

{ #category : #accessing }
WDELevel >> announcer [
	^ announcer
]

{ #category : #accessing }
WDELevel >> children [
	^ sectors
]

{ #category : #'ray casting' }
WDELevel >> elementsInFrustum: frustum [
	| result |
	result := OrderedCollection new.
	self allVisibleEntitiesDo: [ :eachEntity |
		(eachEntity intersectsFrustum: frustum) ifTrue: [
			result add: eachEntity
		]
	].
	^ result asArray
]

{ #category : #serialization }
WDELevel >> encodeJsonKeyValues [
	self validateMaterialList.
	^ super encodeJsonKeyValues , {
		#textures . textures collect: [ :each | each encodeForJSON ].
		#materials . materials collect: [ :each | each encodeForJSON ].
		#sectors . sectors collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #'as yet unclassified' }
WDELevel >> findEntitiesThatIntersectEntities: testingEntitites [
	| enclosingBox searchSet searchLayers searchLayerSet coarseSearchResult |
	enclosingBox := BoxF32 empty.
	searchSet := testingEntitites as: IdentitySet.
	searchLayers := OrderedCollection new.
	searchLayerSet := IdentitySet new.
	
	"Find the layers to search, and an enclosing volume."
	testingEntitites do: [ :each |
		| layer |
		enclosingBox insertBox: each boundingBox.
		layer := each sectorLayer.
		(searchLayerSet includes: layer) ifFalse: [
			searchLayers add: layer.
			searchLayerSet add: layer
		]
	].

	"Coarse search".
	coarseSearchResult := OrderedCollection new.
	searchLayers do: [:layer |
		coarseSearchResult addAll: ((layer elementsInBox: enclosingBox)
			reject: [ :each | searchSet includes: each ])
	].

	coarseSearchResult ifEmpty: [ ^ #() ].
	
	"Refine the search intersected entities."
	^ coarseSearchResult select: [ :each | testingEntitites anySatisfy: [ :testEntity | each intersectsWithEntity: testEntity ] ]
]

{ #category : #accessing }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevel >> gameSettings: anObject [

	gameSettings := anObject
]

{ #category : #serialization }
WDELevel >> getMaterialWithIndex: index [
	(index isNil or: [ index < 1 ]) ifTrue: [ ^ nil ].
	^ materials at: index
]

{ #category : #serialization }
WDELevel >> getTextureWithIndex: index [
	(index isNil or: [ index < 1 ]) ifTrue: [ ^ nil ].
	^ textures at: index
]

{ #category : #initialization }
WDELevel >> initialize [
	super initialize.
	sectors := OrderedCollection new.
	announcer := Announcer new.
]

{ #category : #testing }
WDELevel >> isLevel [
	^ true
]

{ #category : #accessing }
WDELevel >> level [
	^ self
]

{ #category : #serialization }
WDELevel >> loadFromJson: jsonData [
	^ self loadFromJson: jsonData context: self
]

{ #category : #serialization }
WDELevel >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.

	textures := #().
	jsonData at: 'textures' ifPresent: [ :textureData |
		textures := textureData collect: [ :each | WDELevelElement loadFromJson: each context: context ]
	].

	materials := #().
	jsonData at: 'materials' ifPresent: [ :materialData |
		materials := materialData collect: [ :each | WDELevelElement loadFromJson: each context: context ]		
	].

	jsonData at: 'sectors' ifPresent: [ :childrenData |
		childrenData do: [ :each |
			self addSector: (WDELevelElement loadFromJson: each context: context)
		]
	]
]

{ #category : #'instance creation' }
WDELevel >> newEditorSession [
	^ WDELevelEditorSession new level: self; yourself
]

{ #category : #'ray casting' }
WDELevel >> rayCast: ray [
	| bestResult |
	bestResult := nil.
	self allVisibleEntitiesDo: [ :eachEntity |
		| newResult |
		newResult := eachEntity rayCast: ray.
		newResult ifNotNil: [
			(bestResult isNil or: [ newResult < bestResult ]) ifTrue: [ 
				bestResult := newResult
			].
		].
	].
	^ bestResult
]

{ #category : #'ray casting' }
WDELevel >> rayCastAllAlong: ray [
	| result |
	result := OrderedCollection new.
	self allVisibleEntitiesDo: [ :eachEntity |
		result addAll: (eachEntity rayCastAllAlong: ray).
	].

	^ result sort: [ :a :b | a key <= b key ]
]

{ #category : #removing }
WDELevel >> removeChild: aChild [
	self removeSector: aChild
]

{ #category : #adding }
WDELevel >> removeSector: aSector [
	self assert: aSector isSector.
	self assert: aSector level == self.
	sectors remove: aSector.
	aSector removedFromLevel: self.
	aSector level: nil.

]

{ #category : #accessing }
WDELevel >> sectors [
	^ sectors
]

{ #category : #'as yet unclassified' }
WDELevel >> validateMaterial: material [
	material ifNil: [ ^ self ].
	
	materialSet at: material ifPresent: [ :index |
		material materialIndex: index
	] ifAbsentPut: [
		materials add: material.
		material materialIndex: materials size.
		materials size
	]
]

{ #category : #'as yet unclassified' }
WDELevel >> validateMaterialList [
	textures := OrderedCollection new.
	textureSet := Dictionary new.

	materials := OrderedCollection new.
	materialSet := Dictionary new.
	sectors do: [ :sector | sector validateMaterialList  ].
]

{ #category : #'as yet unclassified' }
WDELevel >> validateTexture: texture [
	textureSet at: texture ifPresent: [ :index |
		texture textureIndex: index
	] ifAbsentPut: [
		texture textureIndex: materials size.
		texture textureIndex
	]
]

{ #category : #'as yet unclassified' }
WDELevel >> whenAddedElementDo: aBlock [
	^ announcer when: WDEAddedElementAnnouncement do: [ :ann | aBlock cull: ann element ]
]

{ #category : #'as yet unclassified' }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
	^ self
		whenAddedElementDo: aBlock;
		whenRemovedElementDo: aBlock
]

{ #category : #'as yet unclassified' }
WDELevel >> whenRemovedElementDo: aBlock [
	^ announcer when: WDERemovedElementAnnouncement do: [ :ann | aBlock cull: ann element ]
]
