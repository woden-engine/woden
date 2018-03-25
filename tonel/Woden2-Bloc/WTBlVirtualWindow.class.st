Class {
	#name : #WTBlVirtualWindow,
	#superclass : #Object,
	#traits : 'TBlHostWindow',
	#classTraits : 'TBlHostWindow classTrait',
	#instVars : [
		'engine',
		'extent',
		'eventFetcher',
		'visible',
		'opened',
		'eventHandler',
		'renderNeeded',
		'position',
		'resizable',
		'borderless',
		'title'
	],
	#category : 'Woden2-Bloc'
}

{ #category : #accessing }
WTBlVirtualWindow >> borderless [
	^ borderless
]

{ #category : #accessing }
WTBlVirtualWindow >> borderless: anObject [
	borderless := anObject
]

{ #category : #displaying }
WTBlVirtualWindow >> close [
	opened := false.
]

{ #category : #'as yet unclassified' }
WTBlVirtualWindow >> contentExtent [
	^ extent
]

{ #category : #'initialize-release' }
WTBlVirtualWindow >> createDefaultEventFetcher [
	self eventFetcher: BlOSWindowEventFetcher new
]

{ #category : #'initialize-release' }
WTBlVirtualWindow >> createDefaultEventHandler [
	eventHandler := BlOSWindowEventHandler window: self
]

{ #category : #'initialize-release' }
WTBlVirtualWindow >> createDefaultRenderer [
	"Do nothing here"
]

{ #category : #accessing }
WTBlVirtualWindow >> engine [
	^ engine
]

{ #category : #accessing }
WTBlVirtualWindow >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WTBlVirtualWindow >> eventFetcher [
	^ eventFetcher ifNil:[eventFetcher := BlOSWindowEventFetcher new]
]

{ #category : #'initialize-release' }
WTBlVirtualWindow >> eventFetcher: anEventFetcher [
	eventFetcher := anEventFetcher
]

{ #category : #accessing }
WTBlVirtualWindow >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
WTBlVirtualWindow >> eventHandler: anObject [
	eventHandler := anObject
]

{ #category : #accessing }
WTBlVirtualWindow >> extent [
	^ extent
]

{ #category : #accessing }
WTBlVirtualWindow >> extent: anObject [
	extent := anObject
]

{ #category : #displaying }
WTBlVirtualWindow >> hide [
	visible := false
]

{ #category : #accessing }
WTBlVirtualWindow >> initialize [
	super initialize.
	position := 0@0.
	resizable := false.
	borderless := false.
	title := 'Untitled'.
	self initHostWindow.
]

{ #category : #displaying }
WTBlVirtualWindow >> open [
	opened := true.
]

{ #category : #accessing }
WTBlVirtualWindow >> position [
	^ position
]

{ #category : #accessing }
WTBlVirtualWindow >> position: aPosition [
	position := aPosition
]

{ #category : #'as yet unclassified' }
WTBlVirtualWindow >> render: aNode [
	"Transcript show: aNode; cr."
]

{ #category : #testing }
WTBlVirtualWindow >> renderNeeded [
	renderNeeded := true.
	"Transcript show: #renderNeeded; cr."
]

{ #category : #accessing }
WTBlVirtualWindow >> renderNeeded1 [
	^ renderNeeded
]

{ #category : #accessing }
WTBlVirtualWindow >> renderNeeded: anObject [
	renderNeeded := anObject
]

{ #category : #accessing }
WTBlVirtualWindow >> resizable [
	^ resizable
]

{ #category : #accessing }
WTBlVirtualWindow >> resizable: anObject [
	resizable := anObject
]

{ #category : #displaying }
WTBlVirtualWindow >> show [
	visible := true
]

{ #category : #accessing }
WTBlVirtualWindow >> title [
	^ title
]

{ #category : #accessing }
WTBlVirtualWindow >> title: anObject [
	title := anObject
]
