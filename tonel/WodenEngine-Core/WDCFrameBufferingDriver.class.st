Class {
	#name : #WDCFrameBufferingDriver,
	#superclass : #Object,
	#instVars : [
		'engine',
		'frameIndex',
		'bufferingFrameIndex',
		'frameFences',
		'yieldSemaphore',
		'mainRenderingProcess',
		'renderingProcessesLock',
		'frontRenderingProcesses',
		'backRenderingProcesses',
		'renderingProcessMutex'
	],
	#category : 'WodenEngine-Core-Engine'
}

{ #category : #accessing }
WDCFrameBufferingDriver class >> defaultFrameBufferingCount [
	^ 3
]

{ #category : #accessing }
WDCFrameBufferingDriver class >> defaultTargetFrameRate [
	^ 60
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

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> mainRenderingProcess [
	| session targetFrameRate frameStartTime nextFrameTargetTime delayTime lastFrameStartTime frameDeltaTime |
	session := Smalltalk session.
	targetFrameRate := self targetFrameRate.
	lastFrameStartTime := Time microsecondClockValue.
	yieldSemaphore := Semaphore new.
	
	[ session == Smalltalk session ] whileTrue: [
		"Compute the delta"
		frameStartTime := Time microsecondClockValue.
		frameDeltaTime := frameStartTime - lastFrameStartTime.
		lastFrameStartTime := frameStartTime.
	
		self swapRenderingProcesses.
		self renderForDeltaMicroseconds: frameDeltaTime.
		frontRenderingProcesses removeAll.
	
		nextFrameTargetTime := frameStartTime + (1000000 / targetFrameRate).
		self flag: 'Support delays in microseconds.'.
		delayTime := (nextFrameTargetTime - Time microsecondClockValue) / 1000.
		
		delayTime > 0 ifTrue: [ 
			(Delay forMilliseconds: delayTime) wait
		] ifFalse: [
			"Allow processing time to the processes with the lower priority"
			self yield
		]
	].
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> renderForDeltaMicroseconds: delta [
	"Always update the simulations"
	self renderingProcessesDo: [ :process | process updateForDeltaMicroseconds: delta ].

	"Only perform rendering if there is at least one process that needs to perform rendering."
	frontRenderingProcesses detect: #needsToRender ifNone: [^ self].
	
	self
		beginFrame;
		renderingProcessesRenderDo: #prepareRendering;
		renderingProcessesRenderDo: #sendRenderingCommands;
		renderingProcessesRenderDo: #commitSurfaces;
		endFrame
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
	^ self class defaultTargetFrameRate
]

{ #category : #accessing }
WDCFrameBufferingDriver >> unsuspendAll [
	self renderingProcessCritical: [
		frontRenderingProcesses do: #unsuspend.
		backRenderingProcesses do: #unsuspend.
	]
]

{ #category : #'rendering process' }
WDCFrameBufferingDriver >> yield [
	[ yieldSemaphore signal ] forkAt: Processor lowestPriority.
	yieldSemaphore wait; consumeAllSignals
]
