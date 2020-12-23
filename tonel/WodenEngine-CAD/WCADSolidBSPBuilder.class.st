Class {
	#name : #WCADSolidBSPBuilder,
	#superclass : #WCADSolidVisitor,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #visiting }
WCADSolidBSPBuilder >> visitBasicSolid: solid [
	self error: 'Unsupported basic solid for BSP construction.'.
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitBox: box [
	^ (WCADSolidBSPConvexPolyhedron box: box boundingBox) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitOperation: operation [
	self error: 'Unsupported operation for BSP construction.'.
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitSphere: sphere [
	^ (WCADSolidBSPConvexPolyhedron cubeSphereWithRadius: sphere radius subdivisions: 2) bspTree
]
