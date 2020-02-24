Class {
	#name : #WDCVRButtonReleasedEvent,
	#superclass : #WDCVRButtonEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRButtonReleasedEvent class >> eventType [
	^ AGPU_VR_EVENT_TYPE_BUTTON_RELEASED
]

{ #category : #visiting }
WDCVRButtonReleasedEvent >> accept: visitor [
	^ visitor onVRButtonReleasedEvent: self
]
