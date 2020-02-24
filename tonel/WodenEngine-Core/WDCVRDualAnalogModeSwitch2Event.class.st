Class {
	#name : #WDCVRDualAnalogModeSwitch2Event,
	#superclass : #WDCVRDualAnalogEvent,
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'event type' }
WDCVRDualAnalogModeSwitch2Event class >> eventType [
	^ AGPU_VR_EVENT_TYPE_DUAL_ANALOG_MODE_SWITCH_2
]

{ #category : #visiting }
WDCVRDualAnalogModeSwitch2Event >> accept: visitor [
	^ visitor onVRDualAnalogModeSwitch2Event: self
]
