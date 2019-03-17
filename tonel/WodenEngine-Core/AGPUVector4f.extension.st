Extension { #name : #AGPUVector4f }

{ #category : #'*WodenEngine-Core' }
AGPUVector4f >> asWMVector3F [
	^ WMVector3F x: self x y: self y z: self z
]

{ #category : #'*WodenEngine-Core' }
AGPUVector4f >> asWMVector4F [
	^ WMVector4F x: self x y: self y z: self z w: self w
]
