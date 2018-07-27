"
A WTSCameraTest is a test class for testing the behavior of WTSCamera
"
Class {
	#name : #WDSGCameraTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Scene-Tests'
}

{ #category : #tests }
WDSGCameraTest >> testNew [
	| camera |
	camera := WDSGCamera new.
	self assert: camera frustum isNotNil.
]
