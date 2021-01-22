Extension { #name : #WDAModel }

{ #category : #'*WodenEngine-Spec2' }
WDAModel >> inspectionView [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 100 title: 'Woden View'>
	^ SpWodenViewPresenter new
		wodenApplication: self;
		yourself
]

{ #category : #'*WodenEngine-Spec2' }
WDAModel >> inspectionViewContext: aContext [
	aContext active: self isOpened not
]
