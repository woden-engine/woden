Extension { #name : #BabylonMesh2DVertex }

{ #category : #'*WodenEngine-Babylon' }
BabylonMesh2DVertex >> asWDBCanvasVertex2D [
	^ WDBCanvasVertex2D new
		position: position asFloat32x2;
		texcoord: texcoord asFloat32x2;
		color: color asFloat32x4;
		yourself
]
