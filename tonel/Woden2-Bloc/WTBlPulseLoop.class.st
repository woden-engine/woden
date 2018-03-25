Class {
	#name : #WTBlPulseLoop,
	#superclass : #Object,
	#instVars : [
		'started',
		'pulseEvent',
		'pulseStartTime',
		'pulsePeriod'
	],
	#category : 'Woden2-Bloc'
}

{ #category : #period }
WTBlPulseLoop >> defaultPulsePeriod [
	^ 16
]

{ #category : #period }
WTBlPulseLoop >> firePulseOn: anUniverse [
	pulseStartTime := Time millisecondClockValue.
	anUniverse firePulse: self pulseEvent.
]

{ #category : #initialization }
WTBlPulseLoop >> initialize [
	super initialize.
	started := false.
	pulseEvent := BlPulseEvent new.
]

{ #category : #accessing }
WTBlPulseLoop >> pulseEvent [
	^ pulseEvent
]

{ #category : #period }
WTBlPulseLoop >> pulsePeriod [
	^ pulsePeriod ifNil: [pulsePeriod :=self defaultPulsePeriod]
]

{ #category : #period }
WTBlPulseLoop >> pulsePeriod: aPeriod [
	pulsePeriod := aPeriod
]

{ #category : #accessing }
WTBlPulseLoop >> start [
	started := true
]

{ #category : #accessing }
WTBlPulseLoop >> stop [
	started := false.
]

{ #category : #period }
WTBlPulseLoop >> timeIsUp [
	^ pulseStartTime isNotNil
		and: [ Time millisecondClockValue - pulseStartTime < self pulsePeriod ]
]
