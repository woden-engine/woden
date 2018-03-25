"
I am a Woden application model.

I am the core a Woden based application. I take care of handling animation and coordinating my views for doing time based updates.
"
Class {
	#name : #WDAModel,
	#superclass : #WDCRenderingProcess,
	#instVars : [
		'views',
		'engine',
		'started',
		'session'
	],
	#category : 'WodenEngine-Core-Application'
}

{ #category : #'instance creation' }
WDAModel class >> for: aWDCEngine [
	^ self basicNew initializeWithEngine: aWDCEngine
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

{ #category : #'rendering process stages' }
WDAModel >> commitSurfaces [
	engine renderingProcessCritical: [ 
		views do: #commitSurfaces
	]

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
WDAModel >> openWith: aView [
	Smalltalk os isMacOSX ifTrue: [
		^ self openInMorphicWith: aView
	].
 
	^ self openInOSWindowWith: aView
]

{ #category : #'rendering process stages' }
WDAModel >> prepareRendering [
	engine renderingProcessCritical: [ 
		views do: #prepareRendering
	]

]

{ #category : #adding }
WDAModel >> removeView: aView [
	engine renderingProcessCritical: [
		views remove: aView.
		views ifEmpty: [ self allViewsAreClosed ]
	]
]

{ #category : #'rendering process stages' }
WDAModel >> sendRenderingCommands [
	engine renderingProcessCritical: [ 
		views do: #sendRenderingCommands
	]

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
