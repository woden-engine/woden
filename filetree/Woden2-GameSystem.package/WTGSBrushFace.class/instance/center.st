accessing
center	
	| center |
	center := WMVector3D new.
	1 to: indices size do: [ :i | center := center + (self positionAt: i)].
	^ center / indices size