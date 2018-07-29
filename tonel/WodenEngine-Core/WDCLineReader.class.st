"
I am a stream for reading lines of text.
"
Class {
	#name : #WDCLineReader,
	#superclass : #DecoratorStream,
	#category : #'WodenEngine-Core-Stream'
}

{ #category : #converting }
WDCLineReader >> asSpaceTokenReader [
	^ WDCSpaceTokenReader on: decoratedStream
]

{ #category : #accessing }
WDCLineReader >> next [
	^ ByteString streamContents: [ :out |
		[decoratedStream peek ~= Character cr and: [decoratedStream peek ~= Character lf]] whileTrue: [ 
			out nextPut: decoratedStream next
		].
	
		decoratedStream peek = Character cr ifTrue: [ decoratedStream next ].
		decoratedStream peek = Character lf ifTrue: [ decoratedStream next ].
	]
]

{ #category : #accessing }
WDCLineReader >> nextLine [
	^ self next
]
