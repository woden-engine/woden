Class {
	#name : #WDCVRSensorState,
	#superclass : #Object,
	#instVars : [
		'orientation',
		'translation'
	],
	#category : 'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRSensorState >> orientation [
	^ orientation
]

{ #category : #accessing }
WDCVRSensorState >> orientation: anObject [
	orientation := anObject
]

{ #category : #printing }
WDCVRSensorState >> printOn: aStream [
	aStream
		print: orientation; space;
		print: translation
		yourself
]

{ #category : #accessing }
WDCVRSensorState >> translation [
	^ translation
]

{ #category : #accessing }
WDCVRSensorState >> translation: anObject [
	translation := anObject
]
