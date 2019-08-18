Class {
	#name : #WDCSoundSource,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'dataSource',
		'position',
		'velocity',
		'gain',
		'looped',
		'isGlobalSource',
		'pitch'
	],
	#category : #'WodenEngine-Core-Sound'
}

{ #category : #'as yet unclassified' }
WDCSoundSource >> buildHandle [
	handle := engine soundDevice createSource.
	handle
		dataSource: dataSource validHandle;
		gain: gain;
		pitch: pitch;
		velocity: velocity;
		position: position;
		looped: looped;
		isGlobalSource: isGlobalSource.
]

{ #category : #accessing }
WDCSoundSource >> dataSource [
	^ dataSource
]

{ #category : #accessing }
WDCSoundSource >> dataSource: newDataSource [
	newDataSource == dataSource ifTrue: [ ^ self ].
	dataSource := newDataSource.
	self hasValidHandle ifTrue: [
		handle dataSource: dataSource validHandle
	]
]

{ #category : #accessing }
WDCSoundSource >> gain [
	^ gain
]

{ #category : #accessing }
WDCSoundSource >> gain: anObject [
	gain := anObject.
	self hasValidHandle ifTrue: [
		handle gain: gain
	]
]

{ #category : #initialization }
WDCSoundSource >> initialize [
	super initialize.
	position := WMVector3F new.
	velocity := WMVector3F new.
	gain := 1.0.
	pitch := 1.0.
	isGlobalSource := false.
	looped := false.
]

{ #category : #accessing }
WDCSoundSource >> isGlobalSource [
	^ isGlobalSource
]

{ #category : #accessing }
WDCSoundSource >> isGlobalSource: anObject [
	isGlobalSource := anObject.
	self hasValidHandle ifTrue: [
		handle isGlobalSource: isGlobalSource
	]
]

{ #category : #accessing }
WDCSoundSource >> looped [
	^ looped
]

{ #category : #accessing }
WDCSoundSource >> looped: anObject [
	looped := anObject.
	self hasValidHandle ifTrue: [
		handle looped: looped
	]
]

{ #category : #accessing }
WDCSoundSource >> pitch [
	^ pitch
]

{ #category : #accessing }
WDCSoundSource >> pitch: anObject [
	pitch := anObject.
	self hasValidHandle ifTrue: [
		handle pitch: pitch
	]
]

{ #category : #'as yet unclassified' }
WDCSoundSource >> play [
	self validHandle play
]

{ #category : #accessing }
WDCSoundSource >> position [
	^ position
]

{ #category : #accessing }
WDCSoundSource >> position: anObject [
	position := anObject.
	self hasValidHandle ifTrue: [
		handle position: position
	]
]

{ #category : #'as yet unclassified' }
WDCSoundSource >> stop [
	self validHandle stop
]

{ #category : #accessing }
WDCSoundSource >> velocity [
	^ velocity
]

{ #category : #accessing }
WDCSoundSource >> velocity: anObject [
	velocity := anObject.
	self hasValidHandle ifTrue: [
		handle velocity: position
	]
]
