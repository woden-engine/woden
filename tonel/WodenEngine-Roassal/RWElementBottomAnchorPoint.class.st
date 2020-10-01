Class {
	#name : #RWElementBottomAnchorPoint,
	#superclass : #RWElementAnchorPoint,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWElementBottomAnchorPoint >> position [
	^ element transform transformPosition3: (Float32x3 y: element height * -0.5)
]
