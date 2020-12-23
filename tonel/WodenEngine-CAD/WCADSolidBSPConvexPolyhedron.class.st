Class {
	#name : #WCADSolidBSPConvexPolyhedron,
	#superclass : #Object,
	#instVars : [
		'faces'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #hooks }
WCADSolidBSPConvexPolyhedron class >> box: bbox [
	^ self new faces: {
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
	};
	yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> cubeSphereWithRadius: radius subdivisions: subdivisions [
	^ (self box: (BoxF64 halfExtent: radius))
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			vertex * (radius / vertex length)
		] computingNormalsWith: [ :face :centroid |
			centroid normalized
		]

]

{ #category : #testing }
WCADSolidBSPConvexPolyhedron >> bspTree [
	^ WCADSolidBSPNode fromConvexFaces: faces
]

{ #category : #accessing }
WCADSolidBSPConvexPolyhedron >> faces [

	^ faces
]

{ #category : #accessing }
WCADSolidBSPConvexPolyhedron >> faces: anObject [

	faces := anObject
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron >> subdivide: subdivisions transformingVerticesWith: vertexTransformationBlock computingNormalsWith: normalComputationBlock [
	| subdividedFaces |
	subdivisions <= 0 ifTrue: [ ^ self ].
	
	subdividedFaces := OrderedCollection new.
	faces do: [ :each |
		each computeSubdivisionsInto: subdividedFaces
	].

	subdividedFaces := subdividedFaces asArray.
	subdividedFaces do: [ :each |
		each
			vertices: (each vertices collect: vertexTransformationBlock);
			computePlaneWithNormal: (normalComputationBlock cull: each cull: each centroid);
			fixVerticesOrientationAlongNormal
	].

	^ self class new
		faces: subdividedFaces;
		subdivide: subdivisions - 1 transformingVerticesWith: vertexTransformationBlock computingNormalsWith: normalComputationBlock
	
]
