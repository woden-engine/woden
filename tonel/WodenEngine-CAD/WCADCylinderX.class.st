Class {
	#name : #WCADCylinderX,
	#superclass : #WCADCylinder,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADCylinderX >> accept: visitor [
	^ visitor visitCylinderX: self
]

{ #category : #accessing }
WCADCylinderX >> boundingBox [
	^ BoxF64 halfExtent: (Float64x3 x: length / 2.0 y: radius z: radius)
]

{ #category : #testing }
WCADCylinderX >> isCylinderX [
	^ true
]
