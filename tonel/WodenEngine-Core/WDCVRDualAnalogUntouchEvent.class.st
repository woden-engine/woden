Class {
	#name : #WDCVRDualAnalogUntouchEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogUntouchEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_UNTOUCH
]

{ #category : #visiting }
WDCVRDualAnalogUntouchEvent >> accept: visitor [
	^ visitor onVRDualAnalogUntouchEvent: self
]
