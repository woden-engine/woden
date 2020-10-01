Extension { #name : #BabylonMesh2DVertex }

{ #category : #'*WodenEngine-Babylon' }
BabylonMesh2DVertex >> asWDBCanvasVertex2D [
	^ WDBCanvasVertex2D new
		position: position asWMVector2F;
		texcoord: texcoord asWMVector2F;
		color: color asWMVector4F;
		yourself
]
