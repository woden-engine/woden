Extension { #name : #WDEAlternativeProperty }

{ #category : #'*WodenEngine-Editor-UI' }
WDEAlternativeProperty >> buildSpecPresenter [
	^ SpDropListPresenter new
		items: alternatives value;
		selectItem: self getValue;
		whenSelectedItemChangedDo: [ :newValue | self setValue: newValue ];
		yourself
]
