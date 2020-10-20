Extension { #name : #WDEBooleanProperty }

{ #category : #'*WodenEngine-Editor-UI' }
WDEBooleanProperty >> buildSpecPresenter [
	^ SpCheckBoxPresenter new
		state: self getValue;
		whenChangedDo: [ :newState | self setValue: newState ];
		yourself
]
