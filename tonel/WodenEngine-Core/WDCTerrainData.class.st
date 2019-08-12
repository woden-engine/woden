Class {
	#name : #WDCTerrainData,
	#superclass : #WDCResourceWithDependants,
	#instVars : [
		'engine',
		'heightMap',
		'splatterMap',
		'heightScale',
		'heightMapScale',
		'heightMapOffset',
		'heightOffset',
		'terrainExtent',
		'minHeight',
		'maxHeight',
		'clipMapLevels',
		'collisionShape'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCTerrainData class >> textureExtent: textureExtent heightRenderWith: aBlock [
	| heightMapData |
	heightMapData := WDCTextureData extent: textureExtent heightRenderWith: aBlock.
	^ self new
		heightMap: heightMapData
]

{ #category : #'mesh building' }
WDCTerrainData >> buildTerrainMeshWith: builder [
	builder
		minHeight: minHeight;
		maxHeight: maxHeight.

	clipMapLevels > 0 ifTrue: [ 
		builder
			createClipMapWithLevels: clipMapLevels size: (WMVector2F x: 40.0 y: 40.0) subdivisions: 128;
			terrainExtent: terrainExtent
	] ifFalse: [
		builder createGridWithSize: terrainExtent subdivisions: (heightMap width max: heightMap height)
	].

]

{ #category : #accessing }
WDCTerrainData >> clipMapLevels [
	^ clipMapLevels
]

{ #category : #accessing }
WDCTerrainData >> clipMapLevels: anObject [
	clipMapLevels := anObject
]

{ #category : #accessing }
WDCTerrainData >> collisionShape [
	heightMap ifNil: [ ^ nil ].
	engine ifNil: [ ^ nil ].
	
	collisionShape ifNil: [ 
		collisionShape := WDCAbstractGeometryBuilder new createHeightMapCollision: heightMap heightScale: heightScale minHeight: minHeight maxHeight: maxHeight scale: self heightMapScale offset: self heightMapOffset.
	].

	^ collisionShape
]

{ #category : #'mesh building' }
WDCTerrainData >> createTerrainMeshWithMaterial: material [
	| builder terrainMesh |
	builder := WDCTerrainMeshBuilder for: engine.
	builder material: material.
	self buildTerrainMeshWith: builder.
	terrainMesh := builder terrainMesh.
	terrainMesh deformationState
		terrainData: self;
		yourself.
	^ terrainMesh
		
]

{ #category : #accessing }
WDCTerrainData >> engine [
	^ engine
]

{ #category : #accessing }
WDCTerrainData >> engine: anObject [
	engine := anObject.
	
	heightMap ifNotNil: [ heightMap := heightMap asTextureFor: engine ].
	splatterMap ifNotNil: [ splatterMap := splatterMap asTextureFor: engine ].
]

{ #category : #accessing }
WDCTerrainData >> heightMap [
	^ heightMap
]

{ #category : #accessing }
WDCTerrainData >> heightMap: anObject [
	heightMap := anObject
]

{ #category : #accessing }
WDCTerrainData >> heightMapOffset [
	heightMapOffset ifNil: [ self validateCoordinateTransform  ].
	^ heightMapOffset
]

{ #category : #accessing }
WDCTerrainData >> heightMapScale [
	heightMapScale ifNil: [ self validateCoordinateTransform  ].
	^ heightMapScale
]

{ #category : #accessing }
WDCTerrainData >> heightOffset [
	heightOffset ifNil: [ self validateHeightTransform ].
	^ heightOffset
]

{ #category : #accessing }
WDCTerrainData >> heightScale [
	heightScale ifNil: [ self validateHeightTransform ].
	^ heightScale
]

{ #category : #initialization }
WDCTerrainData >> initialize [
	super initialize.
	terrainExtent := WMVector2F ones.
	minHeight := 0.0.
	maxHeight := 1.0.

	heightMapScale := nil.
	heightMapOffset := nil.
	heightOffset := nil.
	heightScale := nil.
	clipMapLevels := 0.

]

{ #category : #private }
WDCTerrainData >> invalidateCoordinateTransform [
	heightMapScale := nil.
	heightMapOffset := nil.
]

{ #category : #private }
WDCTerrainData >> invalidateHeightTransform [
	heightScale := nil.
	heightOffset := nil.
]

{ #category : #accessing }
WDCTerrainData >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
WDCTerrainData >> maxHeight: anObject [
	maxHeight := anObject.
	self invalidateHeightTransform.
]

{ #category : #accessing }
WDCTerrainData >> minHeight [
	^ minHeight
]

{ #category : #accessing }
WDCTerrainData >> minHeight: anObject [
	minHeight := anObject.
	self invalidateHeightTransform.
]

{ #category : #accessing }
WDCTerrainData >> splatterMap [
	^ splatterMap
]

{ #category : #accessing }
WDCTerrainData >> splatterMap: anObject [
	splatterMap := anObject
]

{ #category : #accessing }
WDCTerrainData >> terrainExtent [
	^ terrainExtent
]

{ #category : #accessing }
WDCTerrainData >> terrainExtent: anObject [
	terrainExtent := anObject asWMVector2F.
	self invalidateCoordinateTransform.
]

{ #category : #private }
WDCTerrainData >> validateCoordinateTransform [
	heightMapScale := WMVector2F ones / (terrainExtent * 0.5).
	heightMapOffset := WMVector2F zero.
]

{ #category : #private }
WDCTerrainData >> validateHeightTransform [
	heightScale := maxHeight - minHeight.
	(heightMap isNotNil and: [ heightMap hasSignedHeightFieldFormat ]) ifTrue: [ 
		heightOffset := (maxHeight + minHeight) * 0.5.
		heightScale := heightScale * 0.5
	] ifFalse: [
		heightOffset := minHeight
	].


]
