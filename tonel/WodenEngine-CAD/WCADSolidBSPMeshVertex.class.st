Class {
	#name : #WCADSolidBSPMeshVertex,
	#superclass : #Object,
	#instVars : [
		'position',
		'normal'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #comparing }
WCADSolidBSPMeshVertex >> = other [
	^ position = other position and: [ normal = other normal ]
]

{ #category : #comparing }
WCADSolidBSPMeshVertex >> hash [
	^ position hash hashMultiply + normal hash
]

{ #category : #accessing }
WCADSolidBSPMeshVertex >> normal [

	^ normal
]

{ #category : #accessing }
WCADSolidBSPMeshVertex >> normal: anObject [

	normal := anObject castTo: Float64x3
]

{ #category : #accessing }
WCADSolidBSPMeshVertex >> position [

	^ position
]

{ #category : #accessing }
WCADSolidBSPMeshVertex >> position: anObject [

	position := anObject castTo: Float64x3
]
