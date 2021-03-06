Extension { #name : #RWNode }

{ #category : #'*WodenEngine-Spec2' }
RWNode >> inspectionView [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 0 title: 'Roassal View'>

	^ self makeDefaultView inspectionView
]

{ #category : #'*WodenEngine-Spec2' }
RWNode >> inspectionViewContext: aContext [
	aContext active: view isNil
]
