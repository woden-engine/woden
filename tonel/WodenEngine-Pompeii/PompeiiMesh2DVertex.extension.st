Extension { #name : #PompeiiMesh2DVertex }

{ #category : #'*WodenEngine-Pompeii' }
PompeiiMesh2DVertex >> asWDPCanvasVertex2D [
	^ WDPCanvasVertex2D new
		position: position asWMVector2F;
		texcoord: texcoord asWMVector2F;
		color: color asWMVector4F;
		yourself
]
