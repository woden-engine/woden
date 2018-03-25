Class {
	#name : #WTOpenALSoundListener,
	#superclass : #Object,
	#instVars : [
		'device',
		'position',
		'velocity',
		'orientation'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : 'WodenEngine-OpenAL'
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
WTOpenALSoundListener >> hasValidHandle [
	^ device isNotNil
]

{ #category : #initialization }
WTOpenALSoundListener >> initialize [
	super initialize.
	position := WMVector3F new.
	velocity := WMVector3F new.
	orientation := WMMatrix3F new.
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
		forward := orientation transformVector3: (WMVector3F z: -1.0).
		up := orientation transformVector3: (WMVector3F y: 1.0).
	
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
			listener3f: AL_POSITION value: position x value: position y value: position z;
			listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		
		forward := orientation transformVector3: (WMVector3F z: -1.0).
		up := orientation transformVector3: (WMVector3F y: 1.0).
	
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
