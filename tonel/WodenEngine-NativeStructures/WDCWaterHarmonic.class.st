Class {
	#name : #WDCWaterHarmonic,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#center => Float32x2',
		'#amplitude => Float32',
		'#frequency => Float32',
		'#padding => Float32x3',
		'#radial => Int32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCWaterHarmonic >> amplitude [
	^ amplitude
]

{ #category : #accessing }
WDCWaterHarmonic >> amplitude: anObject [
	amplitude := anObject
]

{ #category : #accessing }
WDCWaterHarmonic >> center [
	^ center
]

{ #category : #accessing }
WDCWaterHarmonic >> center: anObject [
	center := anObject
]

{ #category : #accessing }
WDCWaterHarmonic >> frequency [
	^ frequency
]

{ #category : #accessing }
WDCWaterHarmonic >> frequency: anObject [
	frequency := anObject
]

{ #category : #accessing }
WDCWaterHarmonic >> radial [
	^ radial
]

{ #category : #accessing }
WDCWaterHarmonic >> radial: anObject [
	radial := anObject
]
