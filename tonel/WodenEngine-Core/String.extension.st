Extension { #name : #String }

{ #category : #'*WodenEngine-Core' }
String >> asColor [
	^ Color fromHexString: self
]

{ #category : #'*WodenEngine-Core' }
String >> asWDCShaderCode [
	^ self utf8Encoded
]
