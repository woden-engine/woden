Class {
	#name : #WDCVREvent,
	#superclass : #Object,
	#instVars : [
		'sourceDevice'
	],
	#classVars : [
		'EventTypeDictionary'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVREvent class >> convertFromAGPU: agpuVREvent [
	^ (EventTypeDictionary at: agpuVREvent type ifAbsent: [ ^ nil ]) new
		initializeFromAGPUVREvent: agpuVREvent;
		yourself
]

{ #category : #'event type' }
WDCVREvent class >> eventType [
	^ nil
]

{ #category : #'class initialization' }
WDCVREvent class >> initialize [
	EventTypeDictionary := Dictionary new.
	self withAllSubclassesDo: [ :sc |
		sc eventType ifNotNil: [ :eventType |
			EventTypeDictionary at: eventType put: sc
		]
	]
]

{ #category : #visiting }
WDCVREvent >> accept: visitor [
	^ self subclassResponsibility
]

{ #category : #initialization }
WDCVREvent >> initializeFromAGPUVREvent: agpuVREvent [
]

{ #category : #accessing }
WDCVREvent >> sourceDevice [
	^ sourceDevice
]

{ #category : #accessing }
WDCVREvent >> sourceDevice: anObject [
	sourceDevice := anObject
]
