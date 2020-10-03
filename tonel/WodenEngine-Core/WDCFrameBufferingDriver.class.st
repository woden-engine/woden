Class {
	#name : #WDCFrameBufferingDriver,
	#superclass : #Object,
	#instVars : [
		'engine',
		'frameIndex',
		'bufferingFrameIndex',
		'frameFences',
		'mainRenderingProcess',
		'renderingProcessesLock',
		'frontRenderingProcesses',
		'backRenderingProcesses',
		'renderingProcessMutex',
		'lastFrameStartTime',
		'currentFrameTargetTime',
		'nextFrameTargetTime',
		'currentFrameStartTime',
		'lastFrameEndTime',
		'currentVRLeftEyeTexture',
		'currentVRRightEyeTexture'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCFrameBufferingDriver class >> defaultFrameBufferingCount [
	^ 3
]

{ #category : #accessing }
WDCFrameBufferingDriver class >> defaultTargetFrameRate [
	^ 60
]

{ #category : #accessing }
WDCFrameBufferingDriver class >> defaultVRTargetFrameRate [
	^ 90
]

{ #category : #'instance creation' }
WDCFrameBufferingDriver class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #adding }
WDCFrameBufferingDriver >> addRenderProcess: aRenderProcess [
	renderingProcessesLock critical: [
		aRenderProcess suspended: false.
		(backRenderingProcesses includes: aRenderProcess) ifFalse: [
			backRenderingProcesses add: aRenderProcess
		]
	]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> addRenderProcess: process withError: error [
	process suspended: true.
	error freeze.
	[ error debug ] fork.

]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> beginFrame [
	| fence |
	fence := frameFences at: bufferingFrameIndex.
	fence ifNotNil: [ fence waitOnClient ].

]

{ #category : #accessing }
WDCFrameBufferingDriver >> bufferingFrameIndex [
	^ bufferingFrameIndex
]

{ #category : #accessing }
WDCFrameBufferingDriver >> bufferingFrameIndexModule: aModule [
	^ frameIndex % aModule
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> createFrameFences [
	frameFences := Array new: self frameBufferingCount.
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> createMainRenderingProcess [
	mainRenderingProcess := [ self mainRenderingProcess ] forkAt: Processor userInterruptPriority
]

{ #category : #accessing }
WDCFrameBufferingDriver >> currentFrameCPUDeltaTime [
	^ (self currentFrameStartTime - self lastFrameStartTime) * 1e-6
]

{ #category : #accessing }
WDCFrameBufferingDriver >> currentFrameStartTime [
	^ currentFrameStartTime ifNil: [ Time microsecondClockValue ]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> endFrame [
	| fence |
	fence := frameFences at: bufferingFrameIndex.
	fence ifNil: [ 
		fence := engine device createFence.
		frameFences at: bufferingFrameIndex put: fence.
	].

	engine graphicsQueue signalFence: fence.

	frameIndex := frameIndex + 1.
	bufferingFrameIndex := (frameIndex % self frameBufferingCount) + 1.
	
	^ bufferingFrameIndex
]

{ #category : #enumerating }
WDCFrameBufferingDriver >> frameBufferingCollect: aBlock [
	^ (1 to: self frameBufferingCount) collect: aBlock
]

{ #category : #accessing }
WDCFrameBufferingDriver >> frameBufferingCount [
	^ self class defaultFrameBufferingCount
]

{ #category : #accessing }
WDCFrameBufferingDriver >> frameIndex [
	^ frameIndex
]

{ #category : #initialization }
WDCFrameBufferingDriver >> initializeWithEngine: anEngine [
	engine := anEngine.
	frameIndex := -1.
	bufferingFrameIndex := 1.
	frameFences := Array new: self frameBufferingCount.
	renderingProcessesLock := Semaphore forMutualExclusion.
	renderingProcessMutex := Mutex new.
	frontRenderingProcesses := OrderedCollection new.
	backRenderingProcesses := OrderedCollection new.
	self createMainRenderingProcess.
]

{ #category : #accessing }
WDCFrameBufferingDriver >> lastFrameCPUConsumption [
	^ (self lastFrameEndTime - self lastFrameStartTime) * 1e-6
]

{ #category : #accessing }
WDCFrameBufferingDriver >> lastFrameEndTime [
	^ lastFrameEndTime ifNil: [ Time microsecondClockValue ]
]

{ #category : #accessing }
WDCFrameBufferingDriver >> lastFrameStartTime [
	^ lastFrameStartTime ifNil: [ Time microsecondClockValue ]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> mainRenderingProcess [
	| session |
	session := Smalltalk session.
	
	[ session == Smalltalk session ] whileTrue: [
		self mainRenderingProcessIteration
	].
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> mainRenderingProcessIteration [
	"Compute the delta"
	| frameDeltaTime delayTime |
	currentFrameTargetTime ifNil: [ currentFrameTargetTime := Time microsecondClockValue ].
	nextFrameTargetTime ifNil: [ nextFrameTargetTime := Time microsecondClockValue ].

	"If the delay is too long."
	Time microsecondClockValue > (nextFrameTargetTime + (500000 // self targetFrameRate)) ifTrue: [ 
		nextFrameTargetTime := Time microsecondClockValue
	].

	"Compute the delta time for the frame."
	frameDeltaTime := nextFrameTargetTime - currentFrameTargetTime.
	currentFrameTargetTime := nextFrameTargetTime.
	
	lastFrameStartTime := currentFrameStartTime.
	currentFrameStartTime := Time microsecondClockValue.
	
	engine resourceCache reloadPendingResources.
	self swapRenderingProcesses.
	engine vrSystem frameStarted.
	self renderForDeltaMicroseconds: frameDeltaTime.
	engine vrSystem frameEnded.
	frontRenderingProcesses removeAll.
	
	
	nextFrameTargetTime := currentFrameTargetTime + (1000000 // self targetFrameRate).
	self flag: 'TODO: Support delays in microseconds.'.
	lastFrameEndTime := Time microsecondClockValue.
	
	delayTime := (nextFrameTargetTime - lastFrameEndTime) // 1000.
	
	"Ask the VR engine VR system to apply the delay. They VR system may want
	 to use a low latency method."
	engine vrSystem applyMainLoopDelay: delayTime.
	
	delayTime <= 0 ifTrue: [
		nextFrameTargetTime := Time microsecondClockValue.
	].

]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> renderForDeltaMicroseconds: delta [
	"Always update the simulations"
	| renderingGraph |
	frontRenderingProcesses reject: #suspended thenDo: #processEvents.

	currentVRLeftEyeTexture := nil.
	currentVRRightEyeTexture := nil.
	
	engine vrSystem pollVREvents.

	self renderingProcessesDo: [ :process |
		process
			updateForDeltaMicroseconds: delta
	].

	"Only perform rendering if there is at least one process that needs to perform rendering."
	frontRenderingProcesses detect: #needsToRender ifNone: [^ self].

	self
		beginFrame.

	"Build the graph with rendering elements."
	renderingGraph := WDCRenderingDependencyGraph new.
	self renderingProcessesRenderDo: [:process |
		renderingGraph addNode: process
	].

	renderingGraph
		sortedNodesDo: #prepareRendering.

	engine frameRenderingMetrics reset.		
	renderingGraph
		sortedNodesDo: #constructRenderingCommandLists;
		sortedNodesDo: #sendRenderingCommands.
	
	(currentVRLeftEyeTexture isNotNil and: [ currentVRRightEyeTexture isNotNil ]) ifTrue: [ 
		engine vrSystem submitLeftEye: currentVRLeftEyeTexture rightEye: currentVRRightEyeTexture
	].

	renderingGraph sortedNodesDo: #commitSurfaces.
	
	self
		endFrame.
		
	engine vrSystem waitAndFetchPoses
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> renderingProcess: process do: aBlock [
	[
		aBlock value: process
	] on: Error do: [ :error |
		self addRenderProcess: process withError: error
	]
]

{ #category : #'as yet unclassified' }
WDCFrameBufferingDriver >> renderingProcessCritical: aBlock [
	^ renderingProcessMutex critical: aBlock
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> renderingProcessesDo: aBlock [
	frontRenderingProcesses reject: #suspended thenDo: [ :process |
		self renderingProcess: process do: aBlock
	]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> renderingProcessesRenderDo: aBlock [
	frontRenderingProcesses
		select: [:proc | proc needsToRender and: [proc suspended not]]
		thenDo: [ :process |
		self renderingProcess: process do: aBlock
	]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> setCurrentVRLeftEyeTexture: leftEyeTexture rightEyeTexture: rightEyeTexture [
	currentVRLeftEyeTexture := leftEyeTexture.
	currentVRRightEyeTexture := rightEyeTexture.
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> swapRenderingProcesses [
	| temp |
	renderingProcessesLock critical: [
		temp := frontRenderingProcesses.
		frontRenderingProcesses := backRenderingProcesses.
		backRenderingProcesses := temp.
		
		self assert: backRenderingProcesses isEmpty.
		frontRenderingProcesses select: #continousUpdating thenDo: [ :proc |
			backRenderingProcesses add: proc
		]
	].
]

{ #category : #accessing }
WDCFrameBufferingDriver >> targetFrameRate [
	^ engine hasSupportForVR
		ifTrue: [ self class defaultVRTargetFrameRate ]
		ifFalse: [ self class defaultTargetFrameRate ]
]

{ #category : #accessing }
WDCFrameBufferingDriver >> unsuspendAll [
	self renderingProcessCritical: [
		frontRenderingProcesses do: #unsuspend.
		backRenderingProcesses do: #unsuspend.
	]
]
