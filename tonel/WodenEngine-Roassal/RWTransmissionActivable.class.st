Class {
	#name : #RWTransmissionActivable,
	#superclass : #RWElementInteraction,
	#instVars : [
		'transmittedItem'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #hooks }
RWTransmissionActivable >> initialize [
	super initialize.
	transmittedItem := #yourself
]

{ #category : #hooks }
RWTransmissionActivable >> initializeElement: element [
	element
		when: RWMouseLeftButtonDown
		do: [ :e |
			element view activateTransmissibleItem: (transmittedItem rwValue: element model)
		].

]

{ #category : #accessing }
RWTransmissionActivable >> transmittedItem [

	^ transmittedItem
]

{ #category : #accessing }
RWTransmissionActivable >> transmittedItem: anObject [

	transmittedItem := anObject
]
