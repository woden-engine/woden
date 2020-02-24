Class {
	#name : #WDCVRButtonUntouchEvent,
	#superclass : #WDCVRButtonEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRButtonUntouchEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_BUTTON_UNTOUCH
]

{ #category : #visiting }
WDCVRButtonUntouchEvent >> accept: visitor [
	^ visitor onVRButtonUntouchEvent: self
]
