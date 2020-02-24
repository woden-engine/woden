Class {
	#name : #WDCVRButtonPressedEvent,
	#superclass : #WDCVRButtonEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRButtonPressedEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_BUTTON_PRESSED
]

{ #category : #visiting }
WDCVRButtonPressedEvent >> accept: visitor [
	^ visitor onVRButtonPressedEvent: self
]
