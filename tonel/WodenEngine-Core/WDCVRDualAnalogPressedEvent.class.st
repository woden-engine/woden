Class {
	#name : #WDCVRDualAnalogPressedEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogPressedEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_PRESSED
]

{ #category : #visiting }
WDCVRDualAnalogPressedEvent >> accept: visitor [
	^ visitor onVRDualAnalogPressedEvent: self
]
