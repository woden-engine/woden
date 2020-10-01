Class {
	#name : #WDCCameraState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#transform => ReversibleAffineTransform3dF32',
		'#projectionMatrix => Float32x4x4',
		'#inverseProjectionMatrix => Float32x4x4',
		'#screenSize => Float32x2',
		'#inverseScreenSize => Float32x2',
		'#clipMapCameraPosition => CompactFloat32x3',
		'#currentTime => Float32',
		'#exposure => Float32',
		'#fogMode => UInt32',
		'#fogFactor1 => Float32',
		'#fogFactor2 => Float32',
		'#fogColor => Float32x4'
	],
	#category : #'WodenEngine-NativeStructures-Core-Camera'
}

{ #category : #accessing }
WDCCameraState >> clipMapCameraPosition [
	^ clipMapCameraPosition
]

{ #category : #accessing }
WDCCameraState >> clipMapCameraPosition: anObject [
	clipMapCameraPosition := anObject
]

{ #category : #accessing }
WDCCameraState >> currentTime [
	^ currentTime
]

{ #category : #accessing }
WDCCameraState >> currentTime: anObject [
	currentTime := anObject
]

{ #category : #accessing }
WDCCameraState >> exposure [
	^ exposure
]

{ #category : #accessing }
WDCCameraState >> exposure: anObject [
	exposure := anObject
]

{ #category : #accessing }
WDCCameraState >> fogColor [
	^ fogColor
]

{ #category : #accessing }
WDCCameraState >> fogColor: anObject [
	fogColor := anObject
]

{ #category : #accessing }
WDCCameraState >> fogFactor1 [
	^ fogFactor1
]

{ #category : #accessing }
WDCCameraState >> fogFactor1: anObject [
	fogFactor1 := anObject
]

{ #category : #accessing }
WDCCameraState >> fogFactor2 [
	^ fogFactor2
]

{ #category : #accessing }
WDCCameraState >> fogFactor2: anObject [
	fogFactor2 := anObject
]

{ #category : #accessing }
WDCCameraState >> fogMode [
	^ fogMode
]

{ #category : #accessing }
WDCCameraState >> fogMode: anObject [
	fogMode := anObject
]

{ #category : #accessing }
WDCCameraState >> inverseProjectionMatrix [
	^ inverseProjectionMatrix
]

{ #category : #accessing }
WDCCameraState >> inverseProjectionMatrix: anObject [
	inverseProjectionMatrix := anObject
]

{ #category : #accessing }
WDCCameraState >> inverseScreenSize [
	^ inverseScreenSize
]

{ #category : #accessing }
WDCCameraState >> inverseScreenSize: anObject [
	inverseScreenSize := anObject
]

{ #category : #accessing }
WDCCameraState >> projectionMatrix [
	^ projectionMatrix
]

{ #category : #accessing }
WDCCameraState >> projectionMatrix: anObject [
	projectionMatrix := anObject
]

{ #category : #accessing }
WDCCameraState >> screenSize [
	^ screenSize
]

{ #category : #accessing }
WDCCameraState >> screenSize: anObject [
	screenSize := anObject
]

{ #category : #accessing }
WDCCameraState >> transform [
	^ transform
]

{ #category : #accessing }
WDCCameraState >> transform: anObject [
	transform := anObject
]
