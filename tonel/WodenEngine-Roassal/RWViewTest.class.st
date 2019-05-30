Class {
	#name : #RWViewTest,
	#superclass : #RWTest,
	#instVars : [
		'view'
	],
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #running }
RWViewTest >> setUp [
	super setUp.
	view := RWView new
]

{ #category : #tests }
RWViewTest >> testAddingElement [
	| element |
	element := RWCube element.
	view add: element.
	self assert: view elements size equals: 1
]

{ #category : #tests }
RWViewTest >> testAddingElements [
	| elements |
	elements := RWCube elementsOn: (1 to: 20).
	view addAll: elements.
	self assert: view elements size equals: 20.
	self assert: view numberOfElements equals: 20.
]

{ #category : #tests }
RWViewTest >> testAddingOverlay [
	| overlay |
	overlay := RWOverlay new.
	view addOverlay: overlay.
	self assert: view overlays size equals: 1.
	self assert: view numberOfOverlays equals: 1.
	self assert: overlay view equals: view.
]

{ #category : #tests }
RWViewTest >> testBackgroundColor [
	self assert: (view backgroundColor closeTo: Color white).
	view backgroundColor: Color red.
	self assert: (view backgroundColor closeTo: Color red).
]

{ #category : #tests }
RWViewTest >> testBaseShape [
	| baseShape |
	baseShape := view baseShapeNodeFor: #dummyShape.
	self assert: baseShape == nil
]

{ #category : #tests }
RWViewTest >> testBaseShapePutting [
	| baseShape node |
	node := WDSGSpatialObjectInstanceGroup new.
	baseShape := view baseShapeNodeFor: #dummyShape ifAbsentPut: [ node ].
	self assert: baseShape equals: node
]

{ #category : #tests }
RWViewTest >> testBoundingBox [
	view add: RWCube element.
	self assert: (view boundingBox closeTo: (WMBox3DF unitCube)).
]

{ #category : #tests }
RWViewTest >> testCameraLightColor [
	self assert: (view cameraLightColor asColor closeTo: Color lightGray).
	view cameraLightColor: Color red.
	self assert: (view cameraLightColor asColor closeTo: Color red).
	
]

{ #category : #tests }
RWViewTest >> testElementFromModel [
	| element |
	element := RWCube elementOn: 42.
	view add: element.
	self assert: (view elementFromModel: 42) equals: element
]

{ #category : #tests }
RWViewTest >> testElementValidId [
	| firstElement secondElement secondElementId |
	firstElement := RWCube element id: #firstElement.
	secondElement := RWCube element.
	view addAll: { firstElement . secondElement }.
	
	self assert: firstElement validId equals: #firstElement.
	secondElementId := secondElement validId.
	self assert: secondElementId isNotNil.
	self assert: secondElement id equals: secondElementId.
	self assert: secondElement validId equals: secondElementId.
]

{ #category : #tests }
RWViewTest >> testEmpty [
	self assert: view elements size equals: 0
]

{ #category : #tests }
RWViewTest >> testGetElementById [
	| element |
	element := RWCube element id: #someElement.
	view add: element.
	self assert: (view getElementById: #someElement) equals: element
]

{ #category : #tests }
RWViewTest >> testGetElementByIdChanged [
	| element |
	element := RWCube element id: #someElement.
	view add: element.
	element id: #newName.
	self assert: (view getElementById: #someElement) equals: nil.
	self assert: (view getElementById: #newName) equals: element.
]

{ #category : #tests }
RWViewTest >> testOpening [

	RWView new open close
]

{ #category : #tests }
RWViewTest >> testRemovingOverlay [
	| overlay |
	overlay := RWOverlay new.
	view addOverlay: overlay.
	overlay remove.
	self assert: view overlays size equals: 0.
	self assert: view numberOfOverlays equals: 0.
	self assert: overlay view equals: nil.
]
