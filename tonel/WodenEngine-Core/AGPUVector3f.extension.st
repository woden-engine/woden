Extension { #name : #AGPUVector3f }

{ #category : #'*WodenEngine-Core' }
AGPUVector3f >> asWMVector3F [
	^ WMVector3F x: self x y: self y z: self z
]
