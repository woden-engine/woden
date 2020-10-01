Class {
	#name : #WDCSoundListener,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'position',
		'velocity',
		'orientation',
		'gain'
	],
	#category : #'WodenEngine-Core-Sound'
}

{ #category : #'as yet unclassified' }
WDCSoundListener >> activate [
	engine soundDevice useListener: self validHandle
]

{ #category : #'as yet unclassified' }
WDCSoundListener >> buildHandle [
	handle := engine soundDevice createListener.
	handle
		velocity: velocity;
		position: position;
		orientation: orientation;
		gain: gain
]

{ #category : #'as yet unclassified' }
WDCSoundListener >> deactivate [
	engine soundDevice useListener: nil
]

{ #category : #accessing }
WDCSoundListener >> gain [
	^ gain
]

{ #category : #accessing }
WDCSoundListener >> gain: anObject [
	gain := anObject.
	self hasValidHandle ifTrue: [ handle gain: anObject ].
]

{ #category : #initialization }
WDCSoundListener >> initialize [
	super initialize.
	position := Float32x3 new.
	velocity := Float32x3 new.
	orientation := Float32x3x3 new.
	gain := 1.0.
]

{ #category : #accessing }
WDCSoundListener >> orientation [
	^ orientation
]

{ #category : #accessing }
WDCSoundListener >> orientation: anObject [
	orientation := anObject.
	self hasValidHandle ifTrue: [ handle orientation: anObject ].
]

{ #category : #accessing }
WDCSoundListener >> position [
	^ position
]

{ #category : #accessing }
WDCSoundListener >> position: anObject [
	position := anObject.
	self hasValidHandle ifTrue: [ handle position: anObject ].
]

{ #category : #accessing }
WDCSoundListener >> velocity [
	^ velocity
]

{ #category : #accessing }
WDCSoundListener >> velocity: anObject [
	velocity := anObject.
	self hasValidHandle ifTrue: [ handle position: anObject ].
]
