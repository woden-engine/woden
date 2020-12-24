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
WCADSolidBSPBuilder >> visitComplementOperation: operation [
	^ (self visitSolid: operation operand) complement
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitDifferenceOperation: operation [
	^ (self visitSolid: operation leftOperand) differenceWith: (self visitSolid: operation rightOperand)
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitEllipsoid: ellipsoid [
	^ (WCADSolidBSPConvexPolyhedron cubeEllipsoidWithRadiuses: ellipsoid radiuses subdivisions: ellipsoid subdivisions + 1) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitIntersectionOperation: operation [
	^ (self visitSolid: operation leftOperand) intersectionWith: (self visitSolid: operation rightOperand)
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitOperation: operation [
	self error: 'Unsupported operation for BSP construction.'.
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitSphere: sphere [
	^ (WCADSolidBSPConvexPolyhedron icoSphereWithRadius: sphere radius subdivisions: sphere subdivisions) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitSymmetricDifferenceOperation: operation [
	^ (self visitSolid: operation leftOperand) symmetricDifferenceWith: (self visitSolid: operation rightOperand)
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitUnionOperation: operation [
	^ (self visitSolid: operation leftOperand) unionWith: (self visitSolid: operation rightOperand)
]
