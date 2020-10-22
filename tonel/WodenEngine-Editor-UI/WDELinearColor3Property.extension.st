Extension { #name : #WDELinearColor3Property }

{ #category : #'*WodenEngine-Editor-UI' }
WDELinearColor3Property >> buildSpecPresenter [
	^ SpTextInputFieldPresenter new
		text: self getFormattedValue;
		whenTextChangedDo: [ :newText |
			self parseTextAndSetValue: newText asString
		];
		yourself
]
