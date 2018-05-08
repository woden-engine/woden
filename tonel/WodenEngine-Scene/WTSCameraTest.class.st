"
A WTSCameraTest is a test class for testing the behavior of WTSCamera
"
Class {
	#name : #WTSCameraTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Scene-Tests'
}

{ #category : #tests }
WTSCameraTest >> testNew [
	| camera |
	camera := WTSCamera new.
	self assert: camera frustum isNotNil.
]
