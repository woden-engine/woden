Extension { #name : #CompactFloat32x3 }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
CompactFloat32x3 >> formatAsDastrelColor [
	^ 'float4({1}f, {2}f, {3}f, 1.0f)' format: {x . y . z}
]
