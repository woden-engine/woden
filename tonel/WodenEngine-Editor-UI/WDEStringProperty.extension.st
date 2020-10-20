Extension { #name : #WDEStringProperty }

{ #category : #'*WodenEngine-Editor-UI' }
WDEStringProperty >> buildSpecPresenter [
	^ SpTextInputFieldPresenter new
		text: self getFormattedValue;
		whenTextChangedDo: [ :newText |
			self parseTextAndSetValue: newText asString
		];
		yourself
]
