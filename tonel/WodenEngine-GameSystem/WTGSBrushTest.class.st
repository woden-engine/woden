"
A WTGSBrushTest is a test class for testing the behavior of WTGSBrush
"
Class {
	#name : #WTGSBrushTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-GameSystem-Tests'
}

{ #category : #tests }
WTGSBrushTest >> testNew [
	| brush |
	brush := WTGSBrush new.
	self assert: brush numberOfFaces equals: 0.
	self deny: brush isValid 
]

{ #category : #tests }
WTGSBrushTest >> testTranslate [
	| brush vector |
	vector := (WMVector3D x: 3.0 y: 0.0 z: 0.0 ).
	brush := WTGSBrush unitCube translateBy: vector.
	self assert: (brush boundingBox closeTo: (WMBox3DD unitCube translatedBy: vector))
]

{ #category : #tests }
WTGSBrushTest >> testUnitBlock [
	| brush |
	brush := WTGSBrush unitCube.
	self assert: brush numberOfFaces equals: 6.
	self assert: brush positions size equals: 8.
	self assert: brush isValid.
	self assert: (brush boundingBox closeTo: WMBox3DD unitCube).
]
