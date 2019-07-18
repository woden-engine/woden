Class {
	#name : #WDCSpatialSubdivisionDataStructureBoxElement,
	#superclass : #WDCSpatialSubdivisionDataStructureSimpleElement,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #testing }
WDCSpatialSubdivisionDataStructureBoxElement >> isSpatialVolumeElement [
	^ true
]

{ #category : #testing }
WDCSpatialSubdivisionDataStructureBoxElement >> spatialElementBoundingBox [
	^ value
]
