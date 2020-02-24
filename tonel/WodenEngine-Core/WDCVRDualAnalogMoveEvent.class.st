Class {
	#name : #WDCVRDualAnalogMoveEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogMoveEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MOVE
]

{ #category : #visiting }
WDCVRDualAnalogMoveEvent >> accept: visitor [
	^ visitor onVRDualAnalogMoveEvent: self
]
