Class {
	#name : #WDEEntity,
	#superclass : #WDELevelElement,
	#instVars : [
		'position',
		'sectorLayer',
		'className',
		'components',
		'localSelectableBoundingBox',
		'localBoundingBox',
		'boundingBox',
		'selectableBoundingBox',
		'localBoundingRectangle',
		'localBoundingBoxWithDepth'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDEEntity >> accept: visitor [
	^ visitor visitEntity: self
]

{ #category : #adding }
WDEEntity >> addComponent: aComponent [
	self assert: aComponent parentEntity isNil.
	components add: aComponent.
	aComponent parentEntity: self
]

{ #category : #accessing }
WDEEntity >> boundingBox [
	^ boundingBox ifNil: [ boundingBox := self localBoundingBox translatedBy: self position ]
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
	localSelectableBoundingBox := BoxF32 center: self localBoundingBoxWithDepth center halfExtent: self localBoundingBoxWithDepth halfExtent + 0.1
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	components := OrderedCollection new asValueHolder.
	position := Float32x3 zeros asValueHolder.
	localBoundingBox := (BoxF32 point: Float32x3 zeros) asValueHolder.
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

{ #category : #accessing }
WDEEntity >> position [
	^ position value
]

{ #category : #accessing }
WDEEntity >> position: anObject [
	position value: anObject
]

{ #category : #private }
WDEEntity >> positionBoxChanged [
	selectableBoundingBox := nil.
	boundingBox := nil.
]

{ #category : #accessing }
WDEEntity >> sectorLayer [
	^ sectorLayer
]

{ #category : #accessing }
WDEEntity >> sectorLayer: anObject [
	sectorLayer := anObject
]

{ #category : #accessing }
WDEEntity >> selectableBoundingBox [
	^ selectableBoundingBox ifNil: [ selectableBoundingBox := self localSelectableBoundingBox translatedBy: self position ]
]

{ #category : #accessing }
WDEEntity >> treeDisplayName [
	^ self className  ,': ' , self name
]

{ #category : #accessing }
WDEEntity >> validPosition3D [
	| rawPosition |
	rawPosition := self position.
	rawPosition class elements = 2 ifTrue: [ ^ Float32x3 xy: rawPosition z: self sectorLayer defaultZ ].
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
