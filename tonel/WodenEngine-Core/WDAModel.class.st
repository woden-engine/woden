"
I am a Woden application model.

I am the core a Woden based application. I take care of handling animation and coordinating my views for doing time based updates.
"
Class {
	#name : #WDAModel,
	#superclass : #WDCRenderingProcess,
	#traits : 'TWDCRenderingDependencyGraphNode',
	#classTraits : 'TWDCRenderingDependencyGraphNode classTrait',
	#instVars : [
		'views',
		'engine',
		'started',
		'session',
		'renderingDependencies'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #'instance creation' }
WDAModel class >> for: aWDCEngine [
	^ self basicNew initializeWithEngine: aWDCEngine
]

{ #category : #adding }
WDAModel >> addDependencyToWodenModel: renderingDependency [
	renderingDependencies add: renderingDependency
]

{ #category : #adding }
WDAModel >> addRenderingDependency: wodenModel [
	renderingDependencies add: wodenModel
]

{ #category : #adding }
WDAModel >> addRenderingElementsToGraph: renderingDependencyGraph [
	renderingDependencyGraph addNodes: views
]

{ #category : #adding }
WDAModel >> addView: aView [
	engine renderingProcessCritical: [
		views add: aView.
	]
]

{ #category : #adding }
WDAModel >> allViewsAreClosed [
	"Stop the process by default"
	self stop
]

{ #category : #accessing }
WDAModel >> continousUpdating [
	^ started
]

{ #category : #'as yet unclassified' }
WDAModel >> defaultViewClass [
	^ WDAView
]

{ #category : #accessing }
WDAModel >> engine [
	^ engine
]

{ #category : #initialization }
WDAModel >> initialize [
	super initialize.
	engine ifNil: [ engine := WDCEngine default. ].
	
	views := OrderedCollection new.
	renderingDependencies := OrderedCollection new.
	started := false.
	self initializeModel.
	self initializeForNewSession.
]

{ #category : #initialization }
WDAModel >> initializeForNewSession [
	session := Smalltalk session.
]

{ #category : #initialization }
WDAModel >> initializeModel [
	"This is the place for doing any model specific initialization"
]

{ #category : #initialization }
WDAModel >> initializeWithEngine: anEngine [
	engine := anEngine.
	self initialize
]

{ #category : #opening }
WDAModel >> isOSWindowBlacklisted [
	(#(null sdl2) includes: Smalltalk os windowSystemName) ifTrue: [ ^ false ].
	^ Smalltalk os isMacOSX or: [ Smalltalk os isWindows ]
]

{ #category : #testing }
WDAModel >> needsToRender [
	^ views isNotEmpty

]

{ #category : #opening }
WDAModel >> open [
	^ self openWith: self defaultViewClass
]

{ #category : #opening }
WDAModel >> openInMorphic [
	^ self openInMorphicWith: self defaultViewClass
]

{ #category : #opening }
WDAModel >> openInMorphicWith: aView [
	| view |
	view := aView engine: engine model: self.
	view openInMorphic.
	self addView: view.
	self start.
	^ view
]

{ #category : #opening }
WDAModel >> openInOSWindow [
	^ self openInOSWindowWith: self defaultViewClass
]

{ #category : #opening }
WDAModel >> openInOSWindowWith: aView [
	| view |
	view := aView engine: engine model: self.
	view openInOSWindow.
	self addView: view.
	self start.
	^ view
]

{ #category : #opening }
WDAModel >> openOnRenderTargetTexture: screenTexture [
	^ self openOnRenderTargetTexture: screenTexture with: self defaultViewClass
]

{ #category : #opening }
WDAModel >> openOnRenderTargetTexture: screenTexture with: aView [
	| view |
	view := aView engine: engine model: self.
	view openOnRenderTargetTexture: screenTexture.
	self addView: view.
	self start.
	^ view
]

{ #category : #opening }
WDAModel >> openWith: aView [
	self isOSWindowBlacklisted ifTrue: [
		^ self openInMorphicWith: aView
	].
 
	^ self openInOSWindowWith: aView
]

{ #category : #'rendering process stages' }
WDAModel >> processEvents [
	engine renderingProcessCritical: [ 
		views do: #processEvents
	]

]

{ #category : #adding }
WDAModel >> removeRenderingDependency: renderingDependency [
	renderingDependencies remove: renderingDependency ifAbsent: []
]

{ #category : #adding }
WDAModel >> removeView: aView [
	engine renderingProcessCritical: [
		views remove: aView.
		views ifEmpty: [ self allViewsAreClosed ]
	]
]

{ #category : #'rendering graph' }
WDAModel >> renderingGraphDependencies [
	^ renderingDependencies
]

{ #category : #initialization }
WDAModel >> start [
	started ifTrue: [ ^ self ].
	started := true.
	engine addRenderProcess: self.

]

{ #category : #initialization }
WDAModel >> stop [
	started := false
]

{ #category : #'rendering process stages' }
WDAModel >> updateForDeltaMicroseconds: microsecondsDelta [
	self flag: 'TODO: deterministic time step.'.
	self updateForFrameDelta: microsecondsDelta * 1e-6

]

{ #category : #'rendering process stages' }
WDAModel >> updateForFrameDelta: delta [
	self updateViewsForFrameDelta: delta
]

{ #category : #'rendering process stages' }
WDAModel >> updateViewsForFrameDelta: delta [
	engine renderingProcessCritical: [ 
		views do: [:v | v updateForFrameDelta: delta].
	]
]

{ #category : #accessing }
WDAModel >> views [
	^ views
]
