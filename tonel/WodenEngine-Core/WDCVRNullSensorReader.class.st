Class {
	#name : #WDCVRNullSensorReader,
	#superclass : #WDCVRSensorReader,
	#instVars : [
		'nullState'
	],
	#category : 'WodenEngine-Core-VR'
}

{ #category : #'session management' }
WDCVRNullSensorReader >> initialize [
	super initialize.
	nullState := WDCVRSensorState new
		orientation: WMQuaternionF identity;
		translation: WMVector3F new.
]

{ #category : #'session management' }
WDCVRNullSensorReader >> sensorState [
	^ nullState
]
