Class {
	#name : #WDEScalarProperty,
	#superclass : #WDEStringProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEScalarProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beFloat;
		number: self getValue;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]

{ #category : #parsing }
WDEScalarProperty >> parseText: text [
	^ text asNumber
]
