"
I am a mesh builder for creating terrains grids.
"
Class {
	#name : #WDCTerrainMeshBuilder,
	#superclass : #WDCAbstractMeshBuilder,
	#instVars : [
		'vertices',
		'indices',
		'material',
		'vertexLayout',
		'boundingBox',
		'usedClipMapPeriod',
		'vertexData',
		'minHeight',
		'maxHeight'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> addCollisionBoxWithMinHeight: minCollisionHeight maxHeight: maxCollisionHeight [
	| collisionBBox |
	self minHeight: minCollisionHeight;
		maxHeight: maxCollisionHeight.
	collisionBBox := BoxF32
		min: (boundingBox min copy y: minCollisionHeight)
		max: (boundingBox max copy y: maxCollisionHeight).
	self addBoxCollisionShape: collisionBBox

]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> addVertex: aVertex [
	vertices add: aVertex.
	boundingBox insertPoint: (Float32x3 x: aVertex x y: 0.0 z: aVertex y).
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> clipMapPeriodForGridSize: size subdivisions: subdivisions [
	material ifNil: [ ^ self ].
	usedClipMapPeriod := size / (subdivisions + 1).
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> createClipMapWithLevels: levelCount size: size subdivisions: subdivisions [
	(indices isEmpty and: [ vertices isEmpty ]) ifTrue: [ 
		^ WDCResourceCache cachedValueFor: { self class . #clipmap . levelCount . size . subdivisions}
			ifPresent: [ :cachedGeometry |
				vertices := cachedGeometry first.
				indices := cachedGeometry second.
				boundingBox := cachedGeometry third.
				vertexData := cachedGeometry fifth.
				cachedGeometry fourth ifNotNil: [ :period |
					usedClipMapPeriod := period
				]
		] ifAbsentPut: [
			self doCreateClipMapWithLevels: levelCount size: size subdivisions: subdivisions.
			{ vertices . indices . boundingBox . usedClipMapPeriod . vertexData }
		]
	].
	self doCreateClipMapWithLevels: levelCount size: size subdivisions: subdivisions

]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> createGridWithSize: size offset: offset subdivisions: subdivisions lodLevel: lodLevel [
	| baseVertex y x vertex verticesPerRow currentRow nextRow currentRowElement nextRowElement dx dy sx sy |
	baseVertex := vertices size.

	dx := (size x / subdivisions).
	dy := (size y / subdivisions).
	sx := size x * -0.5 + offset x.
	sy := size y * -0.5 + offset y.

	"Create the grid vertices"
	y := sy.
	0 to: subdivisions do: [ :iy |
		x := sx.
		0 to: subdivisions do: [ :ix |
			vertex := Float32x3 x: x y: y z: lodLevel asFloat.
			self addVertex: vertex.
			x := x + dx
		].
	
		y := y + dy
	].

	"Create the grid indices"
	verticesPerRow := subdivisions + 1.
	currentRow := baseVertex.
	nextRow := baseVertex + verticesPerRow.
	0 to: 	subdivisions - 1 do: [ :iy |
		currentRowElement := currentRow.
		nextRowElement := nextRow.
		0 to: 	subdivisions - 1 do: [ :ix |
			indices
				add: nextRowElement; add: nextRowElement + 1; add: currentRowElement;
				add: currentRowElement; add: nextRowElement + 1; add: currentRowElement + 1.
				
			currentRowElement := currentRowElement + 1.
			nextRowElement := nextRowElement + 1.
		].
		currentRow := currentRow + verticesPerRow.
		nextRow := currentRow + verticesPerRow.
	].

	"Build the grid edges"
	^ WDCTerrainMeshBuilderGridEdges new
		left: ((0 to: subdivisions) collect: [ :i | baseVertex + (i*verticesPerRow) ]);
		right: ((0 to: subdivisions) collect: [ :i | baseVertex + (i*verticesPerRow) + verticesPerRow - 1 ]);
		bottom: ((0 to: subdivisions) collect: [ :i | i + baseVertex ]);
		top: ((0 to: subdivisions) collect: [ :i | i + currentRow ]);
		yourself.
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> createGridWithSize: size subdivisions: subdivisions [
	^ self createGridWithSize: size offset: Float32x2 zeros subdivisions: subdivisions lodLevel: 0
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> createIndexBuffer [
	^ engine createIndex: 4 elements: indices size immutableBuffer: indices asByteArray
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> createRingWithLevels: levelCount size: size subdivisions: subdivisions radius: radius interiorEdges: gridEdges lodLevel: lodLevel [
	| cellOffset nextGridEdges allCellEdges cellEdges |
	"Generate the outer ring cells."
	allCellEdges := Array new: 9.
	-1 to: 1 do: [ :cy |
		-1 to: 1 do: [ :cx |
			(cx = 0 and: [ cy = 0 ]) ifFalse: [ 
				cellOffset := Float32x2 x: cx * radius x * 2.0 y: cy * radius y * 2.0.
				cellEdges := self createGridWithSize: size offset: cellOffset subdivisions: subdivisions lodLevel: lodLevel.
				allCellEdges at: (cy+1)*3 + (cx+1) + 1 put: cellEdges.
			]
		]
	].

	"Stitch the inner grid, with the outer grid"
	self
		stitchInnerEdge: gridEdges left withOuterEdge: (allCellEdges at: 4) right flipOrientation: false;
		stitchInnerEdge: gridEdges right withOuterEdge: (allCellEdges at: 6) left flipOrientation: true;
		stitchInnerEdge: gridEdges bottom withOuterEdge: (allCellEdges at: 2) top flipOrientation: true;
		stitchInnerEdge: gridEdges top withOuterEdge: (allCellEdges at: 8) bottom flipOrientation: false.

	"Generate the next level"
	levelCount > 1 ifTrue: [
		nextGridEdges := WDCTerrainMeshBuilderGridEdges new
			left: (allCellEdges at: 1) left , (allCellEdges at: 4) left allButFirst , (allCellEdges at: 7) left allButFirst ;
			right: (allCellEdges at: 3) right , (allCellEdges at: 6) right allButFirst , (allCellEdges at: 9) right allButFirst ;
			bottom: (allCellEdges at: 1) bottom , (allCellEdges at: 2) bottom allButFirst , (allCellEdges at: 3) bottom allButFirst ;
			top: (allCellEdges at: 7) top , (allCellEdges at: 8) top allButFirst , (allCellEdges at: 9) top allButFirst ;
			yourself.
		 self createRingWithLevels: levelCount - 1 size: size*3.0 subdivisions: subdivisions * 3 / 2 radius: radius + size interiorEdges: nextGridEdges lodLevel: lodLevel + 1.0.
	] ifFalse: [
		self clipMapPeriodForGridSize: size subdivisions: subdivisions
	]
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> createSubmesh [
	^ WDCGenericSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: material
		yourself
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> createVertexBinding [
	^ vertexData createVertexBindingFor: engine
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> createVertexBuffer [
	^ vertexData createVertexBufferFor: engine
]

{ #category : #initialization }
WDCTerrainMeshBuilder >> createVertexData [
	vertexData := WDCMeshInterleavedVertexData new
		data: vertices;
		vertexClass: self vertexClass;
		yourself. 
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> doCreateClipMapWithLevels: levelCount size: size subdivisions: subdivisions [
	| gridEdges |
	gridEdges := self createGridWithSize: size offset: Float32x2 zeros subdivisions: subdivisions lodLevel: 0.
	
	levelCount > 1 ifTrue: [ 
		 self createRingWithLevels: levelCount - 1 size: size subdivisions: subdivisions / 2 radius: size / 2 interiorEdges: gridEdges lodLevel: 1.
	] ifFalse: [
		self clipMapPeriodForGridSize: size subdivisions: subdivisions
	]

]

{ #category : #accessing }
WDCTerrainMeshBuilder >> engine: anObject [
	engine := anObject.
	vertexLayout := self retrieveVertexLayout.
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> heightScale: aFloat [
	self
		minHeight: aFloat negated;
		maxHeight: aFloat
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> indices [
	^ indices
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> indices: anObject [
	indices := anObject
]

{ #category : #initialization }
WDCTerrainMeshBuilder >> initialize [
	super initialize.
	vertices := StdnVector newFor: self vertexClass.
	indices := StdnVector newFor: UInt32.
	self createVertexData.
	boundingBox := BoxF32 empty.
	minHeight := maxHeight := 0.0.
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> material [
	^ material
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> maxHeight: anObject [
	maxHeight := anObject
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> mesh [
	| mesh |
	mesh := WDCGenericMesh new.
	mesh
		boundingBox: (BoxF32
			nx: boundingBox min x ny: minHeight nz: boundingBox min z
			px: boundingBox max x py: maxHeight pz: boundingBox max x);
		vertexData: vertexData;
		vertexBinding: self createVertexBinding;
		indexBuffer: self createIndexBuffer;
		submeshes: {self createSubmesh}.
	^ mesh
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> minHeight [
	^ minHeight
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> minHeight: anObject [
	minHeight := anObject
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> retrieveVertexLayout [
	^ engine vertexLayoutFor: WDCTerrainMeshVertexF
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> stitchInnerEdge: innerEdge withOuterEdge: outerEdge flipOrientation: flip [
	| ii i0 i1 i2 o0 o1 |
	self assert: ((outerEdge size - 1) * 2) = (innerEdge size - 1).

	ii := 1.
	1 to: outerEdge size - 1 do: [ :oi |
		i0 := innerEdge at: ii.
		i1 := innerEdge at: ii + 1.
		i2 := innerEdge at: ii + 2.
		
		o0 := outerEdge at: oi.
		o1 := outerEdge at: oi + 1.
		
		flip ifTrue: [ 
			indices
				add: o0; add: i0; add: i1;
				add: o0; add: i1; add: o1;
				add: i1; add: i2; add: o1.
		] ifFalse: [ 
			indices
				add: i0; add: o0; add: i1;
				add: i1; add: o0; add: o1;
				add: i2; add: i1; add: o1.
		].
		
		ii := ii + 2.
	]
]

{ #category : #'terrain mesh building' }
WDCTerrainMeshBuilder >> terrainExtent: terrainExtent [
	boundingBox := BoxF32 halfExtent: (Float32x3 x: terrainExtent x * 0.5 y: 0.0 z: terrainExtent y *0.5)
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> terrainMesh [
	| result |
	result := self mesh asTerrainRenderable.
	usedClipMapPeriod ifNotNil: [
		result clipMapPeriod: usedClipMapPeriod
	].
	^ result
]

{ #category : #initialization }
WDCTerrainMeshBuilder >> vertexClass [
	^ WDCTerrainMeshVertexF
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> vertices [
	^ vertices
]

{ #category : #accessing }
WDCTerrainMeshBuilder >> vertices: anObject [
	vertices := anObject
]

{ #category : #'mesh building' }
WDCTerrainMeshBuilder >> waterMesh [
	| result |
	result := self mesh asWaterRenderable.
	usedClipMapPeriod ifNotNil: [
		result clipMapPeriod: usedClipMapPeriod
	].
	^ result
]
