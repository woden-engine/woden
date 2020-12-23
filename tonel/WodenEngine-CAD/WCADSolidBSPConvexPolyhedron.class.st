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
			normal: (Float64x3 x: -1) distance: bbox min x negated)
			fixVerticesOrientationAlongNormal.
		
		"Right"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomRight . bbox nearTopRight . bbox farTopRight . bbox farBottomRight }
			normal: (Float64x3 x: 1) distance: bbox max x)
			fixVerticesOrientationAlongNormal.
		
		"Bottom"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomLeft . bbox nearBottomRight  . bbox farBottomRight . bbox farBottomLeft }
			normal: (Float64x3 y: -1) distance: bbox min y negated)
			fixVerticesOrientationAlongNormal.

		"Top"
		(WCADSolidBSPFace
			vertices: { bbox nearTopLeft . bbox nearTopRight  . bbox farTopRight . bbox farTopLeft }
			normal: (Float64x3 y: 1) distance: bbox max y)
			fixVerticesOrientationAlongNormal.

		"Near"
		(WCADSolidBSPFace
			vertices: { bbox nearBottomLeft . bbox nearBottomRight  . bbox nearTopRight . bbox nearTopLeft }
			normal: (Float64x3 z: -1) distance: bbox min z negated)
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
WCADSolidBSPConvexPolyhedron class >> cubeEllipsoidWithRadiuses: radiuses subdivisions: subdivisions [
	^ (self box: (BoxF64 halfExtent: radiuses))
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			(vertex / radiuses) normalized  * radiuses
		] computingNormalsWith: [ :face :centroid |
			(centroid / radiuses) normalized * radiuses
		]

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

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> icoEllipsoidWithRadiuses: radiuses subdivisions: subdivisions [
	^ self icosahedron
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			(vertex / radiuses) normalized  * radiuses
		] computingNormalsWith: [ :face :centroid |
			(centroid / radiuses) normalized * radiuses
		]

]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> icoSphereWithRadius: radius subdivisions: subdivisions [
	^ self icosahedron
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			vertex * (radius / vertex length)
		] computingNormalsWith: [ :face :centroid |
			centroid normalized
		]

]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> icosahedron [
	"Icosahedron mesh from: https://schneide.blog/2016/07/15/generating-an-icosphere-in-c/"
	| x z n vertices triangles |
	x:=0.525731112119133606.
	z:=0.850650808352039932.
	n:=0.0.
	
	vertices := {
		{x negated.n.z}. {x.n.z}. 	{x negated.n.z negated}. {x.n.z negated}.
		{n.z.x}. {n.z.x negated}. {n.z negated.x}. {n.z negated.x negated}.
		{z.x.n}. {z negated.x. n}. {z.x negated.n}. {z negated.x negated. n}
	} collect: [:each | Float64x3 loadFromJson: each ].

	triangles := #(
		(0 4 1) (0 9 4) (9 5 4) (4 5 8) (4 8 1)
		(8 10 1) (8 3 10) (5 3 8) (5 2 3) (2 7 3)
		(7 10 3) (7 6 10) (7 11 6) (11 0 6) (0 1 6)
		(6 1 10) (9 0 11) (9 11 2) (9 2 5) (7 2 11)
	).	
	
	^ self new faces: (triangles collect: [ :each |
		WCADSolidBSPFace new
			vertices: (each reversed collect: [:vi | vertices at: vi + 1]);
			computePlane;
			yourself
		]
	)
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
