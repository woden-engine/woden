Class {
	#name : #WDCRayIntersectionTestResult,
	#superclass : #Object,
	#instVars : [
		'priority',
		'distance',
		'value'
	],
	#category : #'WodenEngine-NativeStructures-Core-Math'
}

{ #category : #accessing }
WDCRayIntersectionTestResult >> distance [
	^ distance
]

{ #category : #accessing }
WDCRayIntersectionTestResult >> distance: anObject [
	distance := anObject
]

{ #category : #accessing }
WDCRayIntersectionTestResult >> priority [
	^ priority
]

{ #category : #accessing }
WDCRayIntersectionTestResult >> priority: anObject [
	priority := anObject
]

{ #category : #accessing }
WDCRayIntersectionTestResult >> value [
	^ value
]

{ #category : #accessing }
WDCRayIntersectionTestResult >> value: anObject [
	value := anObject
]
