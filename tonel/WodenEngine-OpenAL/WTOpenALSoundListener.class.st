Class {
	#name : #WTOpenALSoundListener,
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
WTOpenALSoundListener >> device [
	^ device
]

{ #category : #accessing }
WTOpenALSoundListener >> device: anObject [
	device := anObject
]

{ #category : #accessing }
WTOpenALSoundListener >> gain [
	^ gain
]

{ #category : #accessing }
WTOpenALSoundListener >> gain: anObject [
	gain := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [ OpenAL listenerf: AL_GAIN value: gain ]
	]
]

{ #category : #accessing }
WTOpenALSoundListener >> hasValidHandle [
	^ device isNotNil
]

{ #category : #initialization }
WTOpenALSoundListener >> initialize [
	super initialize.
	position := Float32x3 new.
	velocity := Float32x3 new.
	orientation := Float32x3x3 new.
	gain := 1.0.
]

{ #category : #testing }
WTOpenALSoundListener >> isCurrentListener [
	^ device currentListener == self
]

{ #category : #accessing }
WTOpenALSoundListener >> orientation [
	^ orientation
]

{ #category : #accessing }
WTOpenALSoundListener >> orientation: anObject [
	| forward up orientationData |
	orientation := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		forward := orientation transformVector3: (Float32x3 z: -1.0).
		up := orientation transformVector3: (Float32x3 y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
			
		device asCurrentDo: [
			OpenAL listenerfv: AL_ORIENTATION values: orientationData.
		]
	]
]

{ #category : #accessing }
WTOpenALSoundListener >> position [
	^ position
]

{ #category : #accessing }
WTOpenALSoundListener >> position: anObject [
	position := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_POSITION value: position x value: position y value: position z.
		]
	]
]

{ #category : #'as yet unclassified' }
WTOpenALSoundListener >> sendValues [
	| forward up orientationData |
	device asCurrentDo: [
		OpenAL
			listenerf: AL_GAIN value: gain;
			listener3f: AL_POSITION value: position x value: position y value: position z;
			listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		
		forward := orientation transformVector3: (Float32x3 z: -1.0).
		up := orientation transformVector3: (Float32x3 y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
		OpenAL listenerfv: AL_ORIENTATION values: orientationData.
	]
]

{ #category : #accessing }
WTOpenALSoundListener >> velocity [
	^ velocity
]

{ #category : #accessing }
WTOpenALSoundListener >> velocity: anObject [
	velocity := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		device asCurrentDo: [
			OpenAL listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		]
	]
]
