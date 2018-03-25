Class {
	#name : #WTGSSpatialDescription,
	#superclass : #WTGSComponent,
	#instVars : [
		'hasVolume',
		'transform',
		'localBoundingBox',
		'boundingBox'
	],
	#classVars : [
		'DefaultHalfExtent'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WTGSSpatialDescription class >> initialize [
	super initialize.
	DefaultHalfExtent := WMVector3D x: 0.1 y: 0.1 z: 0.1
]

{ #category : #serialization }
WTGSSpatialDescription class >> jsonTypeName [
	^ 'spatial-description'
]

{ #category : #adding }
WTGSSpatialDescription >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	self changed.
]

{ #category : #accessing }
WTGSSpatialDescription >> applyTransformation: newTransformation [
	transform := newTransformation transformTransform: transform.
	self changed.
]

{ #category : #serialization }
WTGSSpatialDescription >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'spatial-description'.
		'transform' . transform asJsonData. 
		'bounding-box' . localBoundingBox asJsonData. 
	 }
]

{ #category : #accessing }
WTGSSpatialDescription >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WTGSSpatialDescription >> bucket [
	^ #spatialDescription
]

{ #category : #updating }
WTGSSpatialDescription >> changed [
	self recomputeBoundingBox.
	entity ifNil: [ ^ self ].
	entity sceneNodesDo: [:node | node transform: transform ].
]

{ #category : #accessing }
WTGSSpatialDescription >> hasVolume [
	^ hasVolume
]

{ #category : #accessing }
WTGSSpatialDescription >> hasVolume: anObject [
	hasVolume := anObject
]

{ #category : #initialization }
WTGSSpatialDescription >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformD identity.
	localBoundingBox := WMBox3DD min: DefaultHalfExtent negated max: DefaultHalfExtent.
	boundingBox := localBoundingBox copy.
	hasVolume := false.
]

{ #category : #testing }
WTGSSpatialDescription >> isSingleton [
	^ true
]

{ #category : #serialization }
WTGSSpatialDescription >> loadFromJson: jsonData [
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
WTGSSpatialDescription >> localBoundingBox [
	^ localBoundingBox
]

{ #category : #accessing }
WTGSSpatialDescription >> localBoundingBox: anObject [
	localBoundingBox := anObject.
	self recomputeBoundingBox.
]

{ #category : #transformations }
WTGSSpatialDescription >> lookDown [
	transform orthonormal: (WMMatrix3D xrot: Float halfPi negated).
	self changed.
]

{ #category : #accessing }
WTGSSpatialDescription >> recomputeBoundingBox [
	boundingBox := localBoundingBox transformedWith: transform
]

{ #category : #memento }
WTGSSpatialDescription >> restoreTransformMemento: memento [
	self transform: memento
]

{ #category : #accessing }
WTGSSpatialDescription >> transform [
	^ transform
]

{ #category : #accessing }
WTGSSpatialDescription >> transform: anObject [
	transform := anObject.
	self changed.
]

{ #category : #memento }
WTGSSpatialDescription >> transformMemento [
	^ transform copy
]

{ #category : #accessing }
WTGSSpatialDescription >> translation: aPosition [
	transform translation: aPosition.
	self changed.
]
