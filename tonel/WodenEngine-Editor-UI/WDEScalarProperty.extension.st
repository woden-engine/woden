Extension { #name : #WDEScalarProperty }

{ #category : #'*WodenEngine-Editor-UI' }
WDEScalarProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beFloat;
		number: self getValue;
		minimum: minimum;
		maximum: maximum;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]
