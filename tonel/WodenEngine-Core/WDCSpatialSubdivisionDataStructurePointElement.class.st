Class {
	#name : #WDCSpatialSubdivisionDataStructurePointElement,
	#superclass : #WDCSpatialSubdivisionDataStructureSimpleElement,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> isSpatialElementInsideOfBox: box [
	^ box includesPoint: value
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> isSpatialElementIntersectingBox: box [
	^ self isSpatialElementInsideOfBox: box
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> isSpatialElementStrictlyInsideOfBox: box [
	^ box includesPointStrict: value
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> isSpatialVolumeElement [
	^ false
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> spatialElementBoundingBox [
	^ BoxF32 min: value max: value
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructurePointElement >> spatialElementCenter [
	^ value
]
