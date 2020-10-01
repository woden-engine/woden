Class {
	#name : #WDBCanvasVertex2D,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#position => Float32x2 location: 0',
		'#texcoord => Float32x2 location: 1',
		'#color => Float32x4 location: 2'
	],
	#category : #'WodenEngine-NativeStructures-Babylon'
}

{ #category : #accessing }
WDBCanvasVertex2D >> color [
	^ color
]

{ #category : #accessing }
WDBCanvasVertex2D >> color: anObject [
	color := anObject
]

{ #category : #accessing }
WDBCanvasVertex2D >> position [
	^ position
]

{ #category : #accessing }
WDBCanvasVertex2D >> position: anObject [
	position := anObject
]

{ #category : #accessing }
WDBCanvasVertex2D >> texcoord [
	^ texcoord
]

{ #category : #accessing }
WDBCanvasVertex2D >> texcoord: anObject [
	texcoord := anObject
]
