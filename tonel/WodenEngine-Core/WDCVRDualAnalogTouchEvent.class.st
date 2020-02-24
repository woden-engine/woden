Class {
	#name : #WDCVRDualAnalogTouchEvent,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogTouchEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_TOUCH
]

{ #category : #visiting }
WDCVRDualAnalogTouchEvent >> accept: visitor [
	^ visitor onVRDualAnalogTouchEvent: self
]
