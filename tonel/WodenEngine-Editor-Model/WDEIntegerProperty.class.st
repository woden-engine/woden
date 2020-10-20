Class {
	#name : #WDEIntegerProperty,
	#superclass : #WDEScalarProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEIntegerProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beInteger;
		number: self getValue;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]
