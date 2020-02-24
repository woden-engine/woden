Class {
	#name : #WDCVRDualAnalogModeSwitch1Event,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogModeSwitch1Event class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MODE_SWITCH_1 
]

{ #category : #visiting }
WDCVRDualAnalogModeSwitch1Event >> accept: visitor [
	^ visitor onVRDualAnalogModeSwitch1Event: self
]
