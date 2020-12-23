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
	| bbox |
	bbox := box boundingBox.
	^ WCADSolidBSPNode fromConvexFaces: {
		"Left"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomLeft . bbox nearTopLeft . bbox farTopLeft . bbox farBottomLeft }
			normal: (Float64x3 x: -1) distance: bbox min x)
			fixVerticesOrientationAlongNormal.
		
		"Right"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomRight . bbox nearTopRight . bbox farTopRight . bbox farBottomRight }
			normal: (Float64x3 x: 1) distance: bbox max x)
			fixVerticesOrientationAlongNormal.
		
		"Bottom"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomLeft . bbox nearBottomRight  . bbox farBottomRight . bbox farBottomLeft }
			normal: (Float64x3 y: -1) distance: bbox min y)
			fixVerticesOrientationAlongNormal.

		"Top"
		(WCADSolidBSPFace
			vertices: { bbox nearTopLeft . bbox nearTopRight  . bbox farTopRight . bbox farTopLeft }
			normal: (Float64x3 y: 1) distance: bbox max y)
			fixVerticesOrientationAlongNormal.

		"Near"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomLeft . bbox nearBottomRight  . bbox nearTopRight . bbox nearTopLeft }
			normal: (Float64x3 z: -1) distance: bbox min z)
			fixVerticesOrientationAlongNormal.

		"Far"
		(WCADSolidBSPFace
			vertices: { bbox farBottomLeft . bbox farBottomRight  . bbox farTopRight . bbox farTopLeft }
			normal: (Float64x3 z: 1) distance: bbox max z)
			fixVerticesOrientationAlongNormal.
	}
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitOperation: operation [
	self error: 'Unsupported operation for BSP construction.'.
]
