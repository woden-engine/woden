Extension { #name : #String }

{ #category : #'*WodenEngine-Core' }
String >> asShaderCode [
	^ self utf8Encoded
]
