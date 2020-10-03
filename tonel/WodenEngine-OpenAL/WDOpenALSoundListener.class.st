Class {
	#name : #WDOpenALSoundListener,
	#superclass : #Object,
	#instVars : [
		'device',
		'position',
		'velocity',
		'orientation',
		'gain'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #accessing }
WDOpenALSoundListener >> device [
	^ device
]

{ #category : #accessing }
WDOpenALSoundListener >> device: anObject [
	device := anObject
]

{ #category : #accessing }
WDOpenALSoundListener >> gain [
	^ gain
]

{ #category : #accessing }
WDOpenALSoundListener >> gain: anObject [
	gain := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [ OpenAL listenerf: AL_GAIN value: gain ]
	]
]

{ #category : #accessing }
WDOpenALSoundListener >> hasValidHandle [
	^ device isNotNil
]

{ #category : #initialization }
WDOpenALSoundListener >> initialize [
	super initialize.
	position := Float32x3 new.
	velocity := Float32x3 new.
	orientation := Float32x3x3 new.
	gain := 1.0.
]

{ #category : #testing }
WDOpenALSoundListener >> isCurrentListener [
	^ device currentListener == self
]

{ #category : #accessing }
WDOpenALSoundListener >> orientation [
	^ orientation
]

{ #category : #accessing }
WDOpenALSoundListener >> orientation: anObject [
	| forward up orientationData |
	orientation := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		forward := orientation * (Float32x3 z: -1.0).
		up := orientation * (Float32x3 y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
			
		device asCurrentDo: [
			OpenAL listenerfv: AL_ORIENTATION values: orientationData.
		]
	]
]

{ #category : #accessing }
WDOpenALSoundListener >> position [
	^ position
]

{ #category : #accessing }
WDOpenALSoundListener >> position: anObject [
	position := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_POSITION value: position x value: position y value: position z.
		]
	]
]

{ #category : #'as yet unclassified' }
WDOpenALSoundListener >> sendValues [
	| forward up orientationData |
	device asCurrentDo: [
		OpenAL
			listenerf: AL_GAIN value: gain;
			listener3f: AL_POSITION value: position x value: position y value: position z;
			listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		
		forward := orientation * (Float32x3 z: -1.0).
		up := orientation * (Float32x3 y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
		OpenAL listenerfv: AL_ORIENTATION values: orientationData.
	]
]

{ #category : #accessing }
WDOpenALSoundListener >> velocity [
	^ velocity
]

{ #category : #accessing }
WDOpenALSoundListener >> velocity: anObject [
	velocity := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		]
	]
]
