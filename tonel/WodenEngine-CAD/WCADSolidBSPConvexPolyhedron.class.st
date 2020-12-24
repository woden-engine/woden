Class {
	#name : #WCADSolidBSPConvexPolyhedron,
	#superclass : #WCADObject,
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
	| baseEllipsoid vertices boundingBox planes |
	baseEllipsoid := (self box: (BoxF64 halfExtent: radiuses))
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			(vertex / radiuses) normalized  * radiuses
		].
	vertices := baseEllipsoid allVertices.

	boundingBox := BoxF64 empty.
	vertices do: [ :v | boundingBox insertPoint: v ].
	planes := vertices collect: [:vertex |
		| projectedVertex normal |
		projectedVertex := (vertex / radiuses) normalized * radiuses .
		normal := (projectedVertex / (radiuses * radiuses)) normalized.
		PlaneF64 normal: normal point: projectedVertex
	].

	^ self fromPlanes: planes boundingBox: boundingBox
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> cubeSphereWithRadius: radius subdivisions: subdivisions [
	^ self cubeEllipsoidWithRadiuses: radius subdivisions: subdivisions
]

{ #category : #hooks }
WCADSolidBSPConvexPolyhedron class >> cylinderWithRadius: radius depth: width slices: slices [
	^ self cylinderWithRadius: radius length: width slices: slices
		uAxis: (Float64x3 x: 1.0)
		vAxis: (Float64x3 y: 1.0)
		lAxis: (Float64x3 z: -1.0)
]

{ #category : #hooks }
WCADSolidBSPConvexPolyhedron class >> cylinderWithRadius: radius height: height slices: slices [
	^ self cylinderWithRadius: radius length: height slices: slices
		uAxis: (Float64x3 x: 1.0)
		vAxis: (Float64x3 z: 1.0)
		lAxis: (Float64x3 y: 1.0)
]

{ #category : #hooks }
WCADSolidBSPConvexPolyhedron class >> cylinderWithRadius: radius length: height slices: slices uAxis: uAxis vAxis: vAxis lAxis: lAxis [
	| bottomVertices topVertices bottom top sideFaces |
	bottomVertices := OrderedCollection new.
	topVertices := OrderedCollection new.
	bottom := height * -0.5 * lAxis.
	top := height * 0.5 * lAxis.
	0 to: slices - 1 do: [ :i |
		| phi u v |
		phi := Float twoPi * i / slices.
		u := phi cos * radius * uAxis.
		v := phi sin * radius * vAxis.

		bottomVertices add: u + v + bottom.
		topVertices add: u + v + top.
	].

	sideFaces := (0 to: slices - 1) collect: [ :i |
		| si ei |
		si := i + 1.
		ei := (i + 1) % slices + 1.
		
		WCADSolidBSPFace new
			vertices: {
				bottomVertices at: ei . bottomVertices at: si .
				topVertices at: si . topVertices at: ei .
			};
			computePlane
	].

	^ self new
		faces: ({ 
		"Bottom face"
		WCADSolidBSPFace new
			vertices: bottomVertices;
			computePlane.

		"Top face"
		WCADSolidBSPFace new
			vertices: topVertices reversed;
			computePlane.
	} , sideFaces);
		yourself
]

{ #category : #hooks }
WCADSolidBSPConvexPolyhedron class >> cylinderWithRadius: radius width: width slices: slices [
	^ self cylinderWithRadius: radius length: width slices: slices
		uAxis: (Float64x3 y: 1.0)
		vAxis: (Float64x3 z: 1.0)
		lAxis: (Float64x3 x: -1.0)
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> fromPlanes: planes boundingBox: tightBox [
	| largerBox largerBoxPolyhedron result |
	largerBox := BoxF64 center: tightBox center halfExtent: tightBox halfExtent * 10.
	largerBoxPolyhedron := self box: largerBox.
	result := largerBoxPolyhedron.
	planes do: [ :p |
		result := result clipAgainstPlane: p
	].

	^ result
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> icoEllipsoidWithRadiuses: radiuses subdivisions: subdivisions [
	^ self icosahedron
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			(vertex / radiuses) normalized  * radiuses
		]
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron class >> icoSphereWithRadius: radius subdivisions: subdivisions [
	^ self icosahedron
		subdivide: subdivisions transformingVerticesWith: [ :vertex |
			vertex * (radius / vertex length)
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

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron >> allVertices [
	| addedVertices result |
	addedVertices := Set new.
	result := OrderedCollection new.
	faces do: [ :f |
		f vertices do: [ :v |
			| roundedVertex |
			roundedVertex := (v / Epsilon) floor.
			(addedVertices includes: roundedVertex) ifFalse: [
				result add: roundedVertex * Epsilon.
				addedVertices add: roundedVertex
			]
		]
	].
	^ result
]

{ #category : #accessing }
WCADSolidBSPConvexPolyhedron >> boundingBox [
	| result |
	result := BoxF64 empty.
	faces do: [ :f | f vertices do: [ :v | result insertPoint: v ] ].
	^ result
]

{ #category : #testing }
WCADSolidBSPConvexPolyhedron >> bspTree [
	(faces allSatisfy: [ :f | f allVerticesAreInPlane ]) ifTrue: [ ^ WCADSolidBSPNode fromConvexFaces: faces ].
	
	^ (self class fromPlanes: (faces collect: [:f | f plane]) boundingBox: self boundingBox)
		bspTree
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron >> clipAgainstPlane: plane [
	| preservedFaces newFaceVertices unduplicatedNewVertices lastRounded |
	preservedFaces := OrderedCollection new.
	newFaceVertices := OrderedCollection new.
	faces do: [ :f |
		| facePartition |
		facePartition := f splitWithPlane: plane.
		facePartition first ifNotNil: [ :insideFace |
			preservedFaces add: insideFace
		].
	
		newFaceVertices addAll: facePartition third
	].

	newFaceVertices sort: [ :a :b | (a/Epsilon) floor <= (b/Epsilon) floor ].
	unduplicatedNewVertices := OrderedCollection new.
	lastRounded := nil.
	newFaceVertices do: [ :each |
		| roundedVertex |
		roundedVertex := (each / Epsilon) floor.
		lastRounded ~= roundedVertex ifTrue: [
			unduplicatedNewVertices add: each.
			lastRounded := roundedVertex
		].
	].

	unduplicatedNewVertices size >= 3 ifTrue: [
		preservedFaces add: (WCADSolidBSPFace new
			plane: plane;
			vertices: unduplicatedNewVertices asArray;
			sortVerticesAlongNormal;
			yourself)
	].
	
	^ self class new faces: preservedFaces asArray
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
WCADSolidBSPConvexPolyhedron >> fixFacePlanes [
	| correctFaces correctedFaces |
	correctFaces := faces collect: [ :f | f allVerticesAreInPlane ].
	(correctFaces allSatisfy: [ :v | v ]) ifTrue: [ ^ self ].
	
	correctedFaces := OrderedCollection new.
	faces doWithIndex: [ :each :index |
		(correctFaces at: index) ifTrue: [
			correctedFaces add: each
		] ifFalse: [
			each splitInTriangleFanInto: correctedFaces
		]
	].

	^ self class new faces: correctedFaces asArray; yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPConvexPolyhedron >> subdivide: subdivisions transformingVerticesWith: vertexTransformationBlock [
	| subdividedFaces |
	subdivisions <= 0 ifTrue: [ ^ self ].
	
	subdividedFaces := OrderedCollection new.
	faces do: [ :each |
		each computeSubdivisionsInto: subdividedFaces
	].

	subdividedFaces := subdividedFaces asArray.
	subdividedFaces do: [ :each |
		each vertices: (each vertices collect: vertexTransformationBlock);
			computePlane
	].

	^ self class new
		faces: subdividedFaces;
		subdivide: subdivisions - 1 transformingVerticesWith: vertexTransformationBlock
]
