Class {
	#name : #WDCVRButtonEvent,
	#superclass : #WDCVREvent,
	#instVars : [
		'button'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRButtonEvent >> button [
	^ button
]

{ #category : #accessing }
WDCVRButtonEvent >> button: anObject [
	button := anObject
]

{ #category : #initialization }
WDCVRButtonEvent >> initializeFromAGPUVREvent: agpuVREvent [
	button := agpuVREvent data controller button
]

{ #category : #testing }
WDCVRButtonEvent >> isA [
	^ button = AGPU_VR_BUTTON_A
]

{ #category : #testing }
WDCVRButtonEvent >> isApplicationMenu [
	^ button = AGPU_VR_BUTTON_APPLICATION_MENU
]

{ #category : #testing }
WDCVRButtonEvent >> isAxis0 [
	^ button  = AGPU_VR_BUTTON_AXIS_0
]

{ #category : #testing }
WDCVRButtonEvent >> isAxis1 [
	^ button  = AGPU_VR_BUTTON_AXIS_1
]

{ #category : #testing }
WDCVRButtonEvent >> isAxis2 [
	^ button  = AGPU_VR_BUTTON_AXIS_2
]

{ #category : #testing }
WDCVRButtonEvent >> isAxis3 [
	^ button  = AGPU_VR_BUTTON_AXIS_3
]

{ #category : #testing }
WDCVRButtonEvent >> isAxis4 [
	^ button  = AGPU_VR_BUTTON_AXIS_4
]

{ #category : #testing }
WDCVRButtonEvent >> isGrip [
	^ button = AGPU_VR_BUTTON_GRIP
]

{ #category : #testing }
WDCVRButtonEvent >> isSteamVRTouchpad [
	^ button = AGPU_VR_BUTTON_STEAM_VR_TOUCHPAD
]

{ #category : #testing }
WDCVRButtonEvent >> isSteamVRTrigger [
	^ button = AGPU_VR_BUTTON_STEAM_VR_TRIGGER
]
