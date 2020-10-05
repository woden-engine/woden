Extension { #name : #SpPresenter }

{ #category : #'*WodenEngine-Spec2' }
SpPresenter >> newWodenView [
	^ self instantiate: SpWodenViewPresenter
]
