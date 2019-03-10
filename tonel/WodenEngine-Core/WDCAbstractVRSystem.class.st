Class {
	#name : #WDCAbstractVRSystem,
	#superclass : #Object,
	#instVars : [
		'engine',
		'yieldSemaphore'
	],
	#category : #'WodenEngine-Core-VR'
}

{ #category : #'instance creation' }
WDCAbstractVRSystem class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #'as yet unclassified' }
WDCAbstractVRSystem >> applyMainLoopDelay: delayTime [
	delayTime > 0 ifTrue: [ 
		(Delay forMilliseconds: delayTime) wait
	] ifFalse: [
		"Allow processing time to the processes with the lower priority"
		self yield
	]

]

{ #category : #accessing }
WDCAbstractVRSystem >> engine [
	^ engine
]

{ #category : #'as yet unclassified' }
WDCAbstractVRSystem >> frameEnded [
]

{ #category : #'as yet unclassified' }
WDCAbstractVRSystem >> frameStarted [
]

{ #category : #testing }
WDCAbstractVRSystem >> hasSupportForVR [
	^ true
]

{ #category : #accessing }
WDCAbstractVRSystem >> hmdTrackedDevice [
	self subclassResponsibility
]

{ #category : #initialization }
WDCAbstractVRSystem >> initializeWithEngine: anEngine [
	engine := anEngine.
	yieldSemaphore := Semaphore new.
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> leftEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractVRSystem >> leftEyeRenderTargetExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> leftEyeTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #'as yet unclassified' }
WDCAbstractVRSystem >> pollVREvents [
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> rightEyeProjectionMatrixNear: near far: far invertedY: invertedY [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractVRSystem >> rightEyeRenderTargetExtent [
	self subclassResponsibility
]

{ #category : #'multi eye rendering' }
WDCAbstractVRSystem >> rightEyeTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #'as yet unclassified' }
WDCAbstractVRSystem >> submitLeftEye: leftEyeTexture rightEye: rightEyeTexture [
]

{ #category : #accessing }
WDCAbstractVRSystem >> trackedDevices [
	^ self subclassResponsibility
]

{ #category : #wrappers }
WDCAbstractVRSystem >> waitAndFetchPoses [
]

{ #category : #'rendering process' }
WDCAbstractVRSystem >> yield [
	[ yieldSemaphore signal ] forkAt: Processor lowestPriority.
	yieldSemaphore wait; consumeAllSignals
]
