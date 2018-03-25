Class {
	#name : #WDCSoundListener,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'position',
		'velocity',
		'orientation'
	],
	#category : 'WodenEngine-Core-Sound'
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
		orientation: orientation.
]

{ #category : #initialization }
WDCSoundListener >> initialize [
	super initialize.
	position := WMVector3F new.
	velocity := WMVector3F new.
	orientation := WMMatrix3F new.
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
