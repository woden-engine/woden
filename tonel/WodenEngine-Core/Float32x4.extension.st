Extension { #name : #Float32x4 }

{ #category : #'*WodenEngine-Core' }
Float32x4 >> asAGPUColor4f [
	^ AGPUColor4f new
		r: x;
		g: y;
		b: z;
		a: w;
		yourself
]

{ #category : #'*WodenEngine-Core' }
Float32x4 class >> asWodenVertexFormat [
	^ #float4
]
