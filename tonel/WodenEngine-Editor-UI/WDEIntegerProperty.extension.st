Extension { #name : #WDEIntegerProperty }

{ #category : #'*WodenEngine-Editor-UI' }
WDEIntegerProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beInteger;
		number: self getValue;
		minimum: minimum;
		maximum: maximum;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]
