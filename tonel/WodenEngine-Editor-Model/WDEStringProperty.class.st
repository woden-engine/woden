Class {
	#name : #WDEStringProperty,
	#superclass : #WDEProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #parsing }
WDEStringProperty >> parseText: text [
	^ text
]

{ #category : #parsing }
WDEStringProperty >> parseTextAndSetValue: text [
	| parsedValue |
	parsedValue :=  [
		self parseText: text
	] on: Error do: [ ^ self ].
	
	self setValue: parsedValue.
]
