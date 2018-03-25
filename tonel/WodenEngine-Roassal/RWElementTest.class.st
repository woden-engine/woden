Class {
	#name : #RWElementTest,
	#superclass : #RWTest,
	#instVars : [
		'element',
		'shape'
	],
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWElementTest >> setUp [
	super setUp.
	shape := RWCube new.
	element := shape elementOn: 20.

]

{ #category : #tests }
RWElementTest >> testBasic [	
	self assert: element model equals: 20.
	self assert: element shape equals: shape
]

{ #category : #'test connected edges' }
RWElementTest >> testConnectedEdges01 [

	| e1 e2 l |
	e1 := RWCube element.
	e2 := RWCube element.
	self deny: (e1 isConnectedTo: e2).
	self deny: (e2 isConnectedTo: e1).
	
	l := RWLine edgeFrom: e1 to: e2.
	self assert: (e1 isConnectedTo: e2).
	self assert: (e2 isConnectedTo: e1).

	self assert: (e1 isDirectlyConnectedTo: e2).
	self deny: (e2 isDirectlyConnectedTo: e1).

]

{ #category : #'test connected edges' }
RWElementTest >> testConnectedEdgesBasic [

	self assert: RWCube element connectedEdges isEmpty
]

{ #category : #tests }
RWElementTest >> testDefaultOrientationMatrix [

	self assert: element orientationMatrix equals: WMMatrix3F identity.
]

{ #category : #tests }
RWElementTest >> testGrowingCubes [

	| v es |
	v := RWView new.
	shape := RWCube new size: #yourself.
	es := shape elementsOn: (1 to: 3 by: 0.5).
	v addAll: es. 
	
	"We cannot test much because Renderable does not have bounding box"
	self assert: (es first boundingBox extent closeTo: (WMVector3F x: 1.0 y: 1.0 z: 1.0))
]

{ #category : #tests }
RWElementTest >> testIsInView [

	| e v |
	e := RWElement new.
	self assert: e view isNil.
	
	v := RWView new.
	v add: e.
	self assert: e view equals: v
]

{ #category : #tests }
RWElementTest >> testLookDown [

	self assert: element orientationMatrix equals: WMMatrix3F identity.
	element lookDown.
	self assert: (element orientationMatrix thirdRow closeTo: (WMVector3F x: 0.0 y: -1.0 z: 0.0))
]

{ #category : #tests }
RWElementTest >> testPosition [

	self assert: element position equals: WMVector3F new.
	
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testReplaceSceneNode [
	| newNode |
	newNode := WDSceneNode new.
	self assert: element sceneNode ~~ newNode.
	element replaceSceneNode: newNode.
	self assert: element sceneNode == newNode.

]

{ #category : #tests }
RWElementTest >> testRotateByX [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F xrot: angle.
	element rotateByX: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByXDegrees [
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F xrot: angle degreesToRadians.
	element rotateByXDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByY [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F yrot: angle.
	element rotateByY: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByYDegrees [
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F yrot: angle degreesToRadians.
	element rotateByYDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByZ [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F zrot: angle.
	element rotateByZ: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByZDegrees [
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F zrot: angle degreesToRadians.
	element rotateByZDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testShapeSize [

	| el |
	shape := RWCube new 
					width: [ :e | e + 1 ];
					height: [ :e | e + 2 ];
					depth: [ :e | e + 3 ].
					
	el := shape elementOn: 5.

	self assert: el extent = (WMVector3F x: 6.0 y: 7.0 z: 8.0)
]

{ #category : #tests }
RWElementTest >> testTranslateBy [

	self assert: element position equals: WMVector3F new.
		
	element translateBy: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByX [

	self assert: element position equals: WMVector3F zero.
		
	element translateByX: 2.0.
	self assert: element position equals: (WMVector3F x: 2.0 y: 0.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByXYZ [

	self assert: element position equals: WMVector3F zero.
		
	element translateByX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByY [

	self assert: element position equals: WMVector3F zero.
		
	element translateByY: 2.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 2.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByZ [

	self assert: element position equals: WMVector3F zero.
		
	element translateByZ: 2.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 0.0 z: 2.0).
]

{ #category : #tests }
RWElementTest >> testTranslateTo [

	self assert: element position equals: WMVector3F zero.
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToX [

	self assert: element position equals: WMVector3F zero.
		
	element translateToX: 5.0.
	self assert: element position equals: (WMVector3F x: 5.0 y: 0.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToY [

	self assert: element position equals: WMVector3F zero.
		
	element translateToY: 2.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 2.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToZ [

	self assert: element position equals: WMVector3F zero.
		
	element translateToZ: -3.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 0.0 z: -3.0).
]
