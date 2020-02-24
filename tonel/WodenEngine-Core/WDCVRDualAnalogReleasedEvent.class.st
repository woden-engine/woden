Class {
	#name : #WDCVRDualAnalogReleasedEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogReleasedEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_RELEASED
]

{ #category : #visiting }
WDCVRDualAnalogReleasedEvent >> accept: visitor [
	^ visitor onVRDualAnalogReleasedEvent: self
]
