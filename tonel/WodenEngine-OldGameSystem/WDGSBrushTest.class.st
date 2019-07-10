"
A WTGSBrushTest is a test class for testing the behavior of WTGSBrush
"
Class {
	#name : #WDGSBrushTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-OldGameSystem-Tests'
}

{ #category : #tests }
WDGSBrushTest >> testNew [
	| brush |
	brush := WDGSBrush new.
	self assert: brush numberOfFaces equals: 0.
	self deny: brush isValid 
]

{ #category : #tests }
WDGSBrushTest >> testTranslate [
	| brush vector |
	vector := (WMVector3D x: 3.0 y: 0.0 z: 0.0 ).
	brush := WDGSBrush unitCube translateBy: vector.
	self assert: (brush boundingBox closeTo: (WMBox3DD unitCube translatedBy: vector))
]

{ #category : #tests }
WDGSBrushTest >> testUnitBlock [
	| brush |
	brush := WDGSBrush unitCube.
	self assert: brush numberOfFaces equals: 6.
	self assert: brush positions size equals: 8.
	self assert: brush isValid.
	self assert: (brush boundingBox closeTo: WMBox3DD unitCube).
]
