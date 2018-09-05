Extension { #name : #String }

{ #category : #'*WodenEngine-Core' }
String >> asColor [
	^ Color fromHexString: self
]

{ #category : #'*WodenEngine-Core' }
String >> asShaderCode [
	^ self utf8Encoded
]
