Class {
	#name : #WCADCylinderY,
	#superclass : #WCADCylinder,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADCylinderY >> accept: visitor [
	^ visitor visitCylinderY: self
]

{ #category : #accessing }
WCADCylinderY >> boundingBox [
	^ BoxF64 halfExtent: (Float64x3 x: radius y: length / 2.0 z: radius)
]

{ #category : #testing }
WCADCylinderY >> isCylinderY [
	^ true
]
