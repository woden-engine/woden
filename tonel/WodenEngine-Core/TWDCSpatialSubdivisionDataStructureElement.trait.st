Trait {
	#name : #TWDCSpatialSubdivisionDataStructureElement,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #converting }
TWDCSpatialSubdivisionDataStructureElement >> asSpatialSubdivisionDataStructureElement [
	^ self
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> isSpatialElementInsideOfBox: box [
	^ box includesBox: self spatialElementBoundingBox
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> isSpatialElementIntersectingBox: box [
	^ box hasIntersectionWithBox: self spatialElementBoundingBox
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> isSpatialElementStrictlyInsideOfBox: box [
	^ box includesBox: self spatialElementBoundingBox
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> isSpatialVolumeElement [
	"This should return true for spatial elements with a bounding volume, and false for spatial elements which are just points."
	self explicitRequirement
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> spatialElementBoundingBox [
	"This should return a bounding box for the spatial subdivision element."
	self explicitRequirement
]

{ #category : #testing }
TWDCSpatialSubdivisionDataStructureElement >> spatialElementCenter [
	^ self spatialElementBoundingBox center
]

{ #category : #'as yet unclassified' }
TWDCSpatialSubdivisionDataStructureElement >> spatialElementValue [
	^ self
]
