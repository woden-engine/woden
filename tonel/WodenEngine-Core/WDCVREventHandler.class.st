Class {
	#name : #WDCVREventHandler,
	#superclass : #Object,
	#traits : 'TWDCVREventHandler',
	#classTraits : 'TWDCVREventHandler classTrait',
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'as yet unclassified' }
WDCVREventHandler >> processVREvent: vrEvent [
	^ vrEvent accept: self
]
