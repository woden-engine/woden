Class {
	#name : #WDGSSpatialDescription,
	#superclass : #WDGSComponent,
	#instVars : [
		'hasVolume',
		'transform',
		'localBoundingBox',
		'boundingBox'
	],
	#classVars : [
		'DefaultHalfExtent'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'class initialization' }
WDGSSpatialDescription class >> initialize [
	super initialize.
	DefaultHalfExtent := WMVector3D x: 0.1 y: 0.1 z: 0.1
]

{ #category : #serialization }
WDGSSpatialDescription class >> jsonTypeName [
	^ 'spatial-description'
]

{ #category : #adding }
WDGSSpatialDescription >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	self changed.
]

{ #category : #accessing }
WDGSSpatialDescription >> applyTransformation: newTransformation [
	transform := newTransformation transformTransform: transform.
	self changed.
]

{ #category : #serialization }
WDGSSpatialDescription >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'spatial-description'.
		'transform' . transform asJsonData. 
		'bounding-box' . localBoundingBox asJsonData. 
	 }
]

{ #category : #accessing }
WDGSSpatialDescription >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDGSSpatialDescription >> bucket [
	^ #spatialDescription
]

{ #category : #updating }
WDGSSpatialDescription >> changed [
	self recomputeBoundingBox.
	entity ifNil: [ ^ self ].
	entity sceneNodesDo: [:node | node transform: transform ].
]

{ #category : #accessing }
WDGSSpatialDescription >> hasVolume [
	^ hasVolume
]

{ #category : #accessing }
WDGSSpatialDescription >> hasVolume: anObject [
	hasVolume := anObject
]

{ #category : #initialization }
WDGSSpatialDescription >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformD identity.
	localBoundingBox := WMBox3DD min: DefaultHalfExtent negated max: DefaultHalfExtent.
	boundingBox := localBoundingBox copy.
	hasVolume := false.
]

{ #category : #testing }
WDGSSpatialDescription >> isSingleton [
	^ true
]

{ #category : #serialization }
WDGSSpatialDescription >> loadFromJson: jsonData [
	jsonData at: 'transform' ifPresent: [ :jsonTransform |
		transform := WMReversibleAffineTransformD loadFromJson: jsonTransform
	].

	jsonData at: 'bounding-box' ifPresent: [ :jsonLocalBoundingBox |
		localBoundingBox := WMBox3DD loadFromJson: jsonLocalBoundingBox
	].
	self
		changed;
		recomputeBoundingBox.
]

{ #category : #accessing }
WDGSSpatialDescription >> localBoundingBox [
	^ localBoundingBox
]

{ #category : #accessing }
WDGSSpatialDescription >> localBoundingBox: anObject [
	localBoundingBox := anObject.
	self recomputeBoundingBox.
]

{ #category : #transformations }
WDGSSpatialDescription >> lookDown [
	transform orthonormal: (WMMatrix3D xrot: Float halfPi negated).
	self changed.
]

{ #category : #accessing }
WDGSSpatialDescription >> recomputeBoundingBox [
	boundingBox := localBoundingBox transformedWith: transform
]

{ #category : #memento }
WDGSSpatialDescription >> restoreTransformMemento: memento [
	self transform: memento
]

{ #category : #accessing }
WDGSSpatialDescription >> transform [
	^ transform
]

{ #category : #accessing }
WDGSSpatialDescription >> transform: anObject [
	transform := anObject.
	self changed.
]

{ #category : #memento }
WDGSSpatialDescription >> transformMemento [
	^ transform copy
]

{ #category : #accessing }
WDGSSpatialDescription >> translation: aPosition [
	transform translation: aPosition.
	self changed.
]
