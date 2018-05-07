Class {
	#name : #WDPPompeiiClearCommand,
	#superclass : #WDPPompeiiCommand,
	#instVars : [
		'color'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #accessing }
WDPPompeiiClearCommand >> color [
	^ color
]

{ #category : #accessing }
WDPPompeiiClearCommand >> color: anObject [
	color := anObject
]

{ #category : #'as yet unclassified' }
WDPPompeiiClearCommand >> executeWith: stateTracker on: surface [
	surface beginRenderPassWithColor: color
]
