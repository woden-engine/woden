Class {
	#name : #WCADCylinderZ,
	#superclass : #WCADCylinder,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADCylinderZ >> accept: visitor [
	^ visitor visitCylinderZ: self
]

{ #category : #accessing }
WCADCylinderZ >> boundingBox [
	^ BoxF64 halfExtent: (Float64x3 x: radius y: radius z: length / 2.0)
]

{ #category : #testing }
WCADCylinderZ >> isCylinderZ [
	^ true
]
