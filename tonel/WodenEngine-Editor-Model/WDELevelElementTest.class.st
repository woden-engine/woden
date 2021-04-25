"
A WDELevelElementTest is a test class for testing the behavior of WDELevelElement
"
Class {
	#name : #WDELevelElementTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Editor-Model-Tests'
}

{ #category : #tests }
WDELevelElementTest class >> createTestLevel [
	^ WDELevel new
		addSector: (WDESector new
		isSector2D: true;
		name: 'Sector';
			addLayer: (WDESectorLayer new
				name: 'Layer';
				layerThickness: 2.0f;
				createPointEntity: 'Player.Start' at: (Float32x2 y: 5.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 4.0f y: 7.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 15.0f y: 5.0f);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: -5.0f y: 0.0f) max: (Float32x2 x: 20.0f y: 1.0f)) material: self redMaterial;
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: 3.0f y: 4.0f) max: (Float32x2 x: 8.0f y: 5.0f)) material: self greenMaterial;
				yourself);
		yourself)
]

{ #category : #tests }
WDELevelElementTest class >> greenMaterial [
	^ WDEMetallicRoughnessMaterial new baseColorFactor: Color green; yourself
]

{ #category : #tests }
WDELevelElementTest class >> redMaterial [
	^ WDEMetallicRoughnessMaterial new baseColorFactor: Color red; yourself
]

{ #category : #tests }
WDELevelElementTest >> createTestLevel [
	^ self class createTestLevel
]

{ #category : #tests }
WDELevelElementTest >> testBoxIntersection [
	self assert:
		((WDEVisualComponent box: (BoxF32 halfExtent: 2))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
	self assert:
		((WDEVisualComponent box: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).

	self assert:
		((WDEVisualComponent box: (BoxF32 center: 2 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
	self deny:
		((WDEVisualComponent box: (BoxF32 center: 3 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
			
	self assert:
		((WDEVisualComponent box: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: (ReversibleAffineTransform3dF32 identity translateByX: 2)).
	self deny:
		((WDEVisualComponent box: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent box: (BoxF32 halfExtent: 1))
			withTransform: (ReversibleAffineTransform3dF32 identity translateByX: 3)).
]

{ #category : #tests }
WDELevelElementTest >> testEntitySubtraction [
	| biggerBox smallerBox biggerPolyhedron smallerPolyhedron subtractionResult biggerEntity smallerEntity |
	biggerBox := BoxF32 halfExtent: 2.
	smallerBox := BoxF32 halfExtent: 1.
	biggerPolyhedron := WDEVisualComponent polyhedronBox: biggerBox.
	smallerPolyhedron := WDEVisualComponent polyhedronBox: smallerBox.
	biggerEntity := WDEEntity new addComponent: biggerPolyhedron.
	smallerEntity := WDEEntity new addComponent: smallerPolyhedron.

	subtractionResult := biggerEntity subtract: smallerEntity.
	self assert: subtractionResult size equals: 6.
	
	self assert: (subtractionResult collect: [:each | each boundingBox halfExtent]) asArray equals: {
		(Float32x3 x: 0.5 y: 2.0 z: 2.0).
		(Float32x3 x: 0.5 y: 2.0 z: 2.0).
		(Float32x3 x: 1.0 y: 2.0 z: 0.5).
		(Float32x3 x: 1.0 y: 2.0 z: 0.5).
		(Float32x3 x: 1.0 y: 0.5 z: 1.0).
		(Float32x3 x: 1.0 y: 0.5 z: 1.0).
	}.
	
	self assert: (subtractionResult collect: [:each | each boundingBox center]) asArray equals: {
		(Float32x3 x: -1.5 y: 0.0 z: 0.0).
		(Float32x3 x: 1.5 y: 0.0 z: 0.0).
		(Float32x3 x: 0.0 y: 0.0 z: -1.5).
		(Float32x3 x: 0.0 y: 0.0 z: 1.5).
		(Float32x3 x: 0.0 y: -1.5 z: 0.0).
		(Float32x3 x: 0.0 y: 1.5 z: 0.0)
	}
]

{ #category : #tests }
WDELevelElementTest >> testEntitySubtraction2 [
	| biggerBox smallerBox biggerPolyhedron smallerPolyhedron subtractionResult biggerEntity smallerEntity |
	biggerBox := BoxF32 halfExtent: 2.
	smallerBox := BoxF32 halfExtent: 1.
	biggerPolyhedron := WDEVisualComponent polyhedronBox: biggerBox.
	smallerPolyhedron := WDEVisualComponent polyhedronBox: smallerBox.
	biggerEntity := WDEEntity new addComponent: biggerPolyhedron.
	smallerEntity := WDEEntity new
		position: (Float32x3 ones);
		addComponent: smallerPolyhedron.

	subtractionResult := biggerEntity subtract: smallerEntity.
	self assert: subtractionResult size equals: 3.
	
	self assert: (subtractionResult collect: [:each | each boundingBox halfExtent]) asArray equals: {
		(Float32x3 x: 1.0 y: 2.0 z: 2.0).
		(Float32x3 x: 1.0 y: 2.0 z: 1.0).
		(Float32x3 x: 1.0 y: 1.0 z: 1.0)
	}.
	
	self assert: (subtractionResult collect: [:each | each boundingBox center]) asArray equals: {
		(Float32x3 x: -1.0 y: 0.0 z: 0.0).
		(Float32x3 x: 1.0 y: 0.0 z: -1.0).
		(Float32x3 x: 1.0 y: -1.0 z: 1.0)
	}
]

{ #category : #tests }
WDELevelElementTest >> testPolyhedronBox [
	| box polyhedron |
	box := BoxF32 unitBox.
	polyhedron := WDEPolyhedronVisualComponent new constructFacesForBox: box.
	self assert: polyhedron faces size equals: 6.
	self assert: polyhedron faces first plane equals: (PlaneF32 nx: -1 distance: 0.5).
	self assert: polyhedron faces second plane equals: (PlaneF32 nx: 1 distance: 0.5).
	self assert: polyhedron faces third plane equals: (PlaneF32 nz: -1 distance: 0.5).
	self assert: polyhedron faces fourth plane equals: (PlaneF32 nz: 1 distance: 0.5).
	self assert: polyhedron faces fifth plane equals: (PlaneF32 ny: -1 distance: 0.5).
	self assert: polyhedron faces sixth plane equals: (PlaneF32 ny: 1 distance: 0.5).
	self assert: polyhedron boundingBox equals: box.
]

{ #category : #tests }
WDELevelElementTest >> testPolyhedronBoxIntersection [
	self assert:
		((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 2))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
	self assert:
		((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).

	self assert:
		((WDEVisualComponent polyhedronBox: (BoxF32 center: 2 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
	self deny:
		((WDEVisualComponent polyhedronBox: (BoxF32 center: 3 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: ReversibleAffineTransform3dF32 identity).
			
	self assert:
		((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: (ReversibleAffineTransform3dF32 identity translateByX: 2)).
	self deny:
		((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			hasIntersectionWith:
		(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
			withTransform: (ReversibleAffineTransform3dF32 identity translateByX: 3)).
]

{ #category : #tests }
WDELevelElementTest >> testPolyhedronBoxPolytopeSupportFunction [
	| box polyhedron supportFunction |
	box := BoxF32 unitBox.
	polyhedron := WDEPolyhedronVisualComponent new constructFacesForBox: box.
	supportFunction := polyhedron polytopeSupportFunction.
	self assert: (supportFunction value: (Float32x3 x: -1)) x equals: -0.5.
	self assert: (supportFunction value: (Float32x3 y: -1)) y equals: -0.5.
	self assert: (supportFunction value: (Float32x3 z: -1)) z equals: -0.5.
	
	self assert: (supportFunction value: (Float32x3 x: 1)) x equals: 0.5.
	self assert: (supportFunction value: (Float32x3 y: 1)) y equals: 0.5.
	self assert: (supportFunction value: (Float32x3 z: 1)) z equals: 0.5.
]

{ #category : #tests }
WDELevelElementTest >> testPolyhedronBoxSubtraction [
	| biggerBox smallerBox biggerPolyhedron smallerPolyhedron subtractionResult |
	biggerBox := BoxF32 halfExtent: 2.
	smallerBox := BoxF32 halfExtent: 1.
	biggerPolyhedron := WDEVisualComponent polyhedronBox: biggerBox.
	smallerPolyhedron := WDEVisualComponent polyhedronBox: smallerBox.
	subtractionResult := biggerPolyhedron subtract: smallerPolyhedron withTransform: ReversibleAffineTransform3dF32 identity.
	self assert: subtractionResult size equals: 6.
	
	self assert: (subtractionResult collect: [:each | each boundingBox halfExtent]) asArray equals: {
		(Float32x3 x: 0.5 y: 2.0 z: 2.0).
		(Float32x3 x: 0.5 y: 2.0 z: 2.0).
		(Float32x3 x: 1.0 y: 2.0 z: 0.5).
		(Float32x3 x: 1.0 y: 2.0 z: 0.5).
		(Float32x3 x: 1.0 y: 0.5 z: 1.0).
		(Float32x3 x: 1.0 y: 0.5 z: 1.0).
	}.
	
	self assert: (subtractionResult collect: [:each | each boundingBox center]) asArray equals: {
		(Float32x3 x: -1.5 y: 0.0 z: 0.0).
		(Float32x3 x: 1.5 y: 0.0 z: 0.0).
		(Float32x3 x: 0.0 y: 0.0 z: -1.5).
		(Float32x3 x: 0.0 y: 0.0 z: 1.5).
		(Float32x3 x: 0.0 y: -1.5 z: 0.0).
		(Float32x3 x: 0.0 y: 1.5 z: 0.0)
	}
]

{ #category : #tests }
WDELevelElementTest >> testPolyhedronBoxSubtractionCount [
	self assert: ((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 2))
		subtract:
	(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
		withTransform: ReversibleAffineTransform3dF32 identity) size equals: 6.
		
	self assert: ((WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
		subtract:
	(WDEVisualComponent polyhedronBox: (BoxF32 halfExtent: 1))
		withTransform: ReversibleAffineTransform3dF32 identity) size equals: 0.

]

{ #category : #tests }
WDELevelElementTest >> testSerialization [
	| encodedLevel decodedLevel |
	encodedLevel := self createTestLevel encodeForJSON.
	decodedLevel := WDELevel loadFromJson: encodedLevel.
	self validateTestLevel: decodedLevel
]

{ #category : #tests }
WDELevelElementTest >> testSerializationJSONString [
	| encodedLevel decodedLevel |
	encodedLevel := self createTestLevel encodeAsJSONString.
	decodedLevel := WDELevel loadFromJsonString: encodedLevel.
	self validateTestLevel: decodedLevel
]

{ #category : #tests }
WDELevelElementTest >> testSerializationMessagePack [
	| encodedLevel decodedLevel |
	encodedLevel := self createTestLevel encodeAsMessagePack.
	decodedLevel := WDELevel loadMessagePack: encodedLevel.
	self validateTestLevel: decodedLevel
]

{ #category : #tests }
WDELevelElementTest >> validateTestLevel: decodedLevel [
	| sector layer entities entity component |
	self assert: decodedLevel sectors size equals: 1.

	sector := decodedLevel sectors first.
	self assert: sector isSector2D.
	self assert: sector layers size equals: 1.
	
	layer := sector layers first.
	self assert: layer layerMinZ equals: -1.
	self assert: layer layerMaxZ equals: 1.
	self assert: layer children size = 5.

	entities := layer children.
	self assert: entities first className equals: 'Player.Start'.
	self assert: entities first position equals: (Float32x3 y: 5.0f).

	self assert: entities second className equals: 'Enemy'.
	self assert: entities second position equals: (Float32x3 x: 4.0f y: 7.0f).
	self assert: entities second isPointEntity.

	self assert: entities third className equals: 'Enemy'.
	self assert: entities third position equals: (Float32x3 x: 15.0f y: 5.0f).
	self assert: entities third isPointEntity.

	self assert: entities fourth className equals: 'Wall'.
	self assert: entities fourth position equals: (Float32x3 x: 7.5f y: 0.5f).
	self assert: entities fourth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 12.5f y: 0.5f z: 0.0)).
	entity := entities fourth.
	
	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).
	self assert: component materialAttributes material equals: self class redMaterial.
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).

	self assert: entities fifth className equals: 'Wall'.
	self assert: entities fifth position equals: (Float32x3 x: 5.5f y: 4.5f).
	self assert: entities fifth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 2.5f y: 0.5f z: 0.0)).
	entity := entities fifth.

	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).
	self assert: component materialAttributes material equals: self class greenMaterial.
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).

]
