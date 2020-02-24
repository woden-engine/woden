Class {
	#name : #WDCVRDualAnalogCancelEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogCancelEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_CANCEL
]

{ #category : #visiting }
WDCVRDualAnalogCancelEvent >> accept: visitor [
	^ visitor onVRDualAnalogCancelEvent: self
]
