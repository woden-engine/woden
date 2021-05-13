Class {
	#name : #WDELevelElement,
	#superclass : #Object,
	#instVars : [
		'name',
		'visibleInEditor'
	],
	#classVars : [
		'Epsilon',
		'JsonTypeNameDictionary'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'class initialization' }
WDELevelElement class >> initialize [
	Epsilon := 0.00001.
	JsonTypeNameDictionary := Dictionary new.
	self withAllSubclassesDo: [ :each |
		JsonTypeNameDictionary at: each jsonTypeName put: each
	]
]

{ #category : #testing }
WDELevelElement class >> isAbstract [
	^ self == WDELevelElement
]

{ #category : #serialization }
WDELevelElement class >> jsonTypeName [
	^ self name withoutPrefix: 'WDE'
]

{ #category : #serialization }
WDELevelElement class >> loadFromJson: jsonData context: context [
	| elementClass |
	elementClass := self.
	jsonData at: 'type' ifPresent: [ :found |
		elementClass := JsonTypeNameDictionary at: found
	].

	^ elementClass new loadFromJson: jsonData context: context
]

{ #category : #visiting }
WDELevelElement >> accept: visitor [
	^ self subclassResponsibility
]

{ #category : #adding }
WDELevelElement >> addChild: aChild [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelElement >> addedToLevel: level [
	level announceAddedElement: self.
	self children do: [ :each | each addedToLevel: level ]
]

{ #category : #accessing }
WDELevelElement >> buildLevelElementPropertyPageWith: builder [
	builder
		stringPropertyNamed: 'Name' selector: #name
]

{ #category : #testing }
WDELevelElement >> canBeDuplicatedAndPlacedInLayer [
	^ false
]

{ #category : #testing }
WDELevelElement >> canBeUsedForSubtraction [
	^ false
]

{ #category : #accessing }
WDELevelElement >> children [
	^ #()
]

{ #category : #'as yet unclassified' }
WDELevelElement >> destroyAnnouncers [
]

{ #category : #serialization }
WDELevelElement >> encodeAsJSONString [
	^ (NeoJSONWriter toStringPretty: self encodeForJSON) withUnixLineEndings
]

{ #category : #serialization }
WDELevelElement >> encodeAsMessagePack [
	^ SLVMMessagePackEncoder encodeObject: self encodeForJSON
]

{ #category : #serialization }
WDELevelElement >> encodeForJSON [
	^ OrderedDictionary newFromPairs: self encodeJsonKeyValues
]

{ #category : #serialization }
WDELevelElement >> encodeJsonKeyValues [
	^ {
		#type . self class jsonTypeName.
		#name . self name.
		#visibleInEditor . self visibleInEditor.
	}
]

{ #category : #accessing }
WDELevelElement >> gameEntityDescriptions [
	^ self gameSettings ifNotNil: [ :settings | settings entityDescriptions ]
]

{ #category : #accessing }
WDELevelElement >> gameSettings [
	^ self level ifNotNil: [ :level | level gameSettings ]
]

{ #category : #initialization }
WDELevelElement >> initialize [
	super initialize.
	visibleInEditor := true asValueHolder.
]

{ #category : #'ray casting' }
WDELevelElement >> intersectsFrustum: frustum [
	^ false
]

{ #category : #testing }
WDELevelElement >> is2DLevelElement [
	^ false
]

{ #category : #testing }
WDELevelElement >> isBoxCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isConvexPolygonVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isDirectionalLightSourceVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isEntity [
	^ false
]

{ #category : #testing }
WDELevelElement >> isEntityComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isInSector2D [
	^ false
]

{ #category : #testing }
WDELevelElement >> isLevel [
	^ false
]

{ #category : #testing }
WDELevelElement >> isLightSourceVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPointEntity [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPointLightSourceVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPolygonConvexHullCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPolyhedronConvexHullCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPolyhedronVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPunctualVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isRectangleCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isRectangleVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isSector [
	^ false
]

{ #category : #testing }
WDELevelElement >> isSectorLayer [
	^ false
]

{ #category : #testing }
WDELevelElement >> isSectorLayerChild [
	^ (self isSector or: [ self isLevel or: [self isSectorLayer] ]) not
]

{ #category : #testing }
WDELevelElement >> isSpotLightSourceVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent2D [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent3D [
	^ false
]

{ #category : #accessing }
WDELevelElement >> level [
	^ self parent ifNotNil: [ :p | p level ]
]

{ #category : #serialization }
WDELevelElement >> loadFromJson: jsonData context: context [
	name := jsonData at: 'name' ifAbsent: [ '' ].
	self visibleInEditor: (jsonData at: #visibleInEditor ifAbsent: [self visibleInEditor])
]

{ #category : #memento }
WDELevelElement >> materialStateMemento [
	^ nil
]

{ #category : #accessing }
WDELevelElement >> name [
	^ name ifNil: [ name := '' ]
]

{ #category : #accessing }
WDELevelElement >> name: aString [
	name := aString.
]

{ #category : #accessing }
WDELevelElement >> parent [
	^ nil
]

{ #category : #accessing }
WDELevelElement >> position [
	^ Float32x3 zeros
]

{ #category : #accessing }
WDELevelElement >> position: aPosition [
	"By default do nothing"
]

{ #category : #copying }
WDELevelElement >> postCopy [
	super postCopy.
	visibleInEditor := visibleInEditor value asValueHolder.
]

{ #category : #accessing }
WDELevelElement >> propertyPages [
	^ {WDEPropertyPageBuilder for: self buildWith: [:builder |
		builder title: self class jsonTypeName.
		self buildLevelElementPropertyPageWith: builder
	]}
]

{ #category : #'ray casting' }
WDELevelElement >> rayCast: ray [
	^ nil
]

{ #category : #'ray casting' }
WDELevelElement >> rayCastAllAlong: ray [
	^ #()
]

{ #category : #removing }
WDELevelElement >> removeChild: aChild [
	self subclassResponsibility
]

{ #category : #removing }
WDELevelElement >> removeFromParent [
	^ self parent removeChild: self
]

{ #category : #'as yet unclassified' }
WDELevelElement >> removedFromLevel: level [
	self destroyAnnouncers.
	self children do: [ :each | each removedFromLevel: level ].
	level announceRemovedElement: self.

]

{ #category : #memento }
WDELevelElement >> restoreMaterialStateMemento: memento [
]

{ #category : #memento }
WDELevelElement >> restoreTransformStateMemento: memento [
]

{ #category : #accessing }
WDELevelElement >> sector [
	^ self parent ifNotNil: [ :p | p sector ]
]

{ #category : #'as yet unclassified' }
WDELevelElement >> sectorDimensionalityChanged [
	self children do: [ :each | each sectorDimensionalityChanged ]
]

{ #category : #accessing }
WDELevelElement >> sectorLayer [
	^ self parent ifNotNil: [ :p | p sectorLayer ]
]

{ #category : #'as yet unclassified' }
WDELevelElement >> sectorLayerThicknessChanged [
	self children do: [ :each | each sectorLayerThicknessChanged ]
]

{ #category : #initialization }
WDELevelElement >> setMaterial: aMaterial [
	"By default do nothing here."
]

{ #category : #serialization }
WDELevelElement >> setupForNewInstance [
	"By default do nothing"
]

{ #category : #memento }
WDELevelElement >> transformStateMemento [
	^ nil
]

{ #category : #transforms }
WDELevelElement >> transformWith: transform [
]

{ #category : #transforms }
WDELevelElement >> translateBy: translation [
	self transformWith: (ReversibleAffineTransform3dF32 identity translation: translation)
]

{ #category : #accessing }
WDELevelElement >> treeDisplayName [
	^ self class jsonTypeName , ': ', self name
]

{ #category : #'as yet unclassified' }
WDELevelElement >> validateMaterialList [
	"By default do nothing"
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor [
	^ visibleInEditor value
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor: aBoolean [
	visibleInEditor value: aBoolean
]

{ #category : #'as yet unclassified' }
WDELevelElement >> whenVisibleInEditorChanged: aBlock [
	visibleInEditor whenChangedDo: aBlock
]
