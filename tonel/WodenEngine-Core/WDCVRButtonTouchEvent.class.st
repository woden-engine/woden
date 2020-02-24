Class {
	#name : #WDCVRButtonTouchEvent,
	#superclass : #WDCVRButtonEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRButtonTouchEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_BUTTON_TOUCH
]

{ #category : #visiting }
WDCVRButtonTouchEvent >> accept: visitor [
	^ visitor onVRButtonTouchEvent: self
]
