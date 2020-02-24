Class {
	#name : #WDCVRDualAnalogEvent,
	#superclass : #WDCVREvent,
	#instVars : [
		'which',
		'x',
		'y',
		'transformedX',
		'transformedY'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #initialization }
WDCVRDualAnalogEvent >> initializeFromAGPUVREvent: agpuVREvent [
	| dualAnalogData |
	dualAnalogData := agpuVREvent data.
	x := dualAnalogData x.
	y := dualAnalogData y.
	transformedX := dualAnalogData transformedX.
	transformedY := dualAnalogData transformedY.
	which := dualAnalogData which.
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> transformedX [
	^ transformedX
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> transformedX: anObject [
	transformedX := anObject
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> transformedY [
	^ transformedY
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> transformedY: anObject [
	transformedY := anObject
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> which [
	^ which
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> which: anObject [
	which := anObject
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> x [
	^ x
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> x: anObject [
	x := anObject
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> y [
	^ y
]

{ #category : #accessing }
WDCVRDualAnalogEvent >> y: anObject [
	y := anObject
]
