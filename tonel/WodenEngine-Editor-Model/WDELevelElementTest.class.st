"
A WDELevelElementTest is a test class for testing the behavior of WDELevelElement
"
Class {
	#name : #WDELevelElementTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #tests }
WDELevelElementTest >> testSerialization [
	| encodedLevel decodedLevel sector layer entities entity component |
	encodedLevel := WDELevel new
		addSector: (WDESector new
		isSector2D: true;
		name: 'Sector';
			addLayer: (WDESectorLayer new
				name: 'Layer';
				defaultThickness: 2.0f;
				createPointEntity: 'Player.Start' at: (Float32x2 y: 5.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 4.0f y: 7.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 15.0f y: 5.0f);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: -5.0f y: 0.0f) max: (Float32x2 x: 20.0f y: 1.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: 3.0f y: 4.0f) max: (Float32x2 x: 8.0f y: 5.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				yourself);
		yourself);
	encodeForJSON.
	decodedLevel := WDELevel loadFromJson: encodedLevel.
	self assert: decodedLevel sectors size equals: 1.

	sector := decodedLevel sectors first.
	self assert: sector isSector2D.
	self assert: sector layers size equals: 1.
	
	layer := sector layers first.
	self assert: layer defaultMinZ equals: -1.
	self assert: layer defaultMaxZ equals: 1.
	self assert: layer children size = 5.

	entities := layer children.
	self assert: entities first className equals: 'Player.Start'.
	self assert: entities first position equals: (Float32x2 y: 5.0f).

	self assert: entities second className equals: 'Enemy'.
	self assert: entities second position equals: (Float32x2 x: 4.0f y: 7.0f).
	self assert: entities second isPointEntity.

	self assert: entities third className equals: 'Enemy'.
	self assert: entities third position equals: (Float32x2 x: 15.0f y: 5.0f).
	self assert: entities third isPointEntity.

	self assert: entities fourth className equals: 'Wall'.
	self assert: entities fourth position equals: (Float32x2 x: 7.5f y: 0.5f).
	self assert: entities fourth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 12.5f y: 0.5f z: 0.0)).
	entity := entities fourth.
	
	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).

	self assert: entities fifth className equals: 'Wall'.
	self assert: entities fifth position equals: (Float32x2 x: 5.5f y: 4.5f).
	self assert: entities fifth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 2.5f y: 0.5f z: 0.0)).
	entity := entities fifth.

	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).

]

{ #category : #tests }
WDELevelElementTest >> testSerializationJSONString [
	| encodedLevel decodedLevel sector layer entities entity component |
	encodedLevel := WDELevel new
		addSector: (WDESector new
		isSector2D: true;
		name: 'Sector';
			addLayer: (WDESectorLayer new
				name: 'Layer';
				defaultThickness: 2.0f;
				createPointEntity: 'Player.Start' at: (Float32x2 y: 5.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 4.0f y: 7.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 15.0f y: 5.0f);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: -5.0f y: 0.0f) max: (Float32x2 x: 20.0f y: 1.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: 3.0f y: 4.0f) max: (Float32x2 x: 8.0f y: 5.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				yourself);
		yourself);
	encodeAsJSONString.
	decodedLevel := WDELevel loadFromJsonString: encodedLevel.
	self assert: decodedLevel sectors size equals: 1.

	sector := decodedLevel sectors first.
	self assert: sector isSector2D.
	self assert: sector layers size equals: 1.
	
	layer := sector layers first.
	self assert: layer defaultMinZ equals: -1.
	self assert: layer defaultMaxZ equals: 1.
	self assert: layer children size = 5.

	entities := layer children.
	self assert: entities first className equals: 'Player.Start'.
	self assert: entities first position equals: (Float32x2 y: 5.0f).

	self assert: entities second className equals: 'Enemy'.
	self assert: entities second position equals: (Float32x2 x: 4.0f y: 7.0f).
	self assert: entities second isPointEntity.

	self assert: entities third className equals: 'Enemy'.
	self assert: entities third position equals: (Float32x2 x: 15.0f y: 5.0f).
	self assert: entities third isPointEntity.

	self assert: entities fourth className equals: 'Wall'.
	self assert: entities fourth position equals: (Float32x2 x: 7.5f y: 0.5f).
	self assert: entities fourth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 12.5f y: 0.5f z: 0.0)).
	entity := entities fourth.
	
	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).

	self assert: entities fifth className equals: 'Wall'.
	self assert: entities fifth position equals: (Float32x2 x: 5.5f y: 4.5f).
	self assert: entities fifth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 2.5f y: 0.5f z: 0.0)).
	entity := entities fifth.

	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).

]

{ #category : #tests }
WDELevelElementTest >> testSerializationMessagePack [
	| encodedLevel decodedLevel sector layer entities entity component |
	encodedLevel := WDELevel new
		addSector: (WDESector new
		isSector2D: true;
		name: 'Sector';
			addLayer: (WDESectorLayer new
				name: 'Layer';
				defaultThickness: 2.0f;
				createPointEntity: 'Player.Start' at: (Float32x2 y: 5.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 4.0f y: 7.0f);
				createPointEntity: 'Enemy' at: (Float32x2 x: 15.0f y: 5.0f);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: -5.0f y: 0.0f) max: (Float32x2 x: 20.0f y: 1.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				createSolidEntity: 'Wall' rectangle: (RectangleF32 min: (Float32x2 x: 3.0f y: 4.0f) max: (Float32x2 x: 8.0f y: 5.0f))
					color: (Float32x4 x: 0.2 y: 0.2 z: 0.2 w: 1.0);
				yourself);
		yourself);
	encodeAsMessagePack.
	decodedLevel := WDELevel loadMessagePack: encodedLevel.
	self assert: decodedLevel sectors size equals: 1.

	sector := decodedLevel sectors first.
	self assert: sector isSector2D.
	self assert: sector layers size equals: 1.
	
	layer := sector layers first.
	self assert: layer defaultMinZ equals: -1.
	self assert: layer defaultMaxZ equals: 1.
	self assert: layer children size = 5.

	entities := layer children.
	self assert: entities first className equals: 'Player.Start'.
	self assert: entities first position equals: (Float32x2 y: 5.0f).

	self assert: entities second className equals: 'Enemy'.
	self assert: entities second position equals: (Float32x2 x: 4.0f y: 7.0f).
	self assert: entities second isPointEntity.

	self assert: entities third className equals: 'Enemy'.
	self assert: entities third position equals: (Float32x2 x: 15.0f y: 5.0f).
	self assert: entities third isPointEntity.

	self assert: entities fourth className equals: 'Wall'.
	self assert: entities fourth position equals: (Float32x2 x: 7.5f y: 0.5f).
	self assert: entities fourth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 12.5f y: 0.5f z: 0.0)).
	entity := entities fourth.
	
	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 12.5f y: 0.5f)).

	self assert: entities fifth className equals: 'Wall'.
	self assert: entities fifth position equals: (Float32x2 x: 5.5f y: 4.5f).
	self assert: entities fifth localBoundingBox equals: (BoxF32 halfExtent: (Float32x3 x: 2.5f y: 0.5f z: 0.0)).
	entity := entities fifth.

	self assert: entity components size equals: 2.
	component := entity components first.
	self assert: component isRectangleVisualComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).
	
	component := entity components second.
	self assert: component isRectangleCollisionComponent.
	self assert: component rectangle equals: (RectangleF32 halfExtent: (Float32x2 x: 2.5f y: 0.5f)).

]
