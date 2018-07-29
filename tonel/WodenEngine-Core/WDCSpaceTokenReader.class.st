"
I am a stream for reading space separated tokens from a stream
"
Class {
	#name : #WDCSpaceTokenReader,
	#superclass : #DecoratorStream,
	#category : #'WodenEngine-Core-Stream'
}

{ #category : #converting }
WDCSpaceTokenReader >> asLineReader [
	^ WDCLineReader on: decoratedStream
]

{ #category : #private }
WDCSpaceTokenReader >> next [
	self skipWhite.
	^ ByteString streamContents: [ :out |
		[decoratedStream atEnd not and: [ decoratedStream peek > Character space ]] whileTrue: [
			out nextPut: decoratedStream next
		]
	]
]

{ #category : #private }
WDCSpaceTokenReader >> nextToken [
	^ self next
]

{ #category : #private }
WDCSpaceTokenReader >> skipWhite [
	[decoratedStream atEnd not and: [ decoratedStream peek <= Character space ]] whileTrue: [
		decoratedStream next
	]
]
