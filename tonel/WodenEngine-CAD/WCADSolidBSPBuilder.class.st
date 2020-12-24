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
WCADSolidBSPBuilder >> visitCylinderX: cylinder [
	^ (WCADSolidBSPConvexPolyhedron cylinderWithRadius: cylinder radius width: cylinder length slices: cylinder slices) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitCylinderY: cylinder [
	^ (WCADSolidBSPConvexPolyhedron cylinderWithRadius: cylinder radius height: cylinder length slices: cylinder slices) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitCylinderZ: cylinder [
	^ (WCADSolidBSPConvexPolyhedron cylinderWithRadius: cylinder radius depth: cylinder length slices: cylinder slices) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitDifferenceOperation: operation [
	^ (self visitSolid: operation leftOperand) differenceWith: (self visitSolid: operation rightOperand)
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitEllipsoid: ellipsoid [
	^ (WCADSolidBSPConvexPolyhedron icoEllipsoidWithRadiuses: ellipsoid radiuses subdivisions: ellipsoid subdivisions + 1) bspTree
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
WCADSolidBSPBuilder >> visitTranslationOperation: operation [
	^ (self visitSolid: operation operand) transformedWithMatrix: (Float64x4x4 translation: operation translation)
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitUnionOperation: operation [
	^ (self visitSolid: operation leftOperand) unionWith: (self visitSolid: operation rightOperand)
]
