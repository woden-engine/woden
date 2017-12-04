resource building
uploadTexture2DFormData
	"Only supporting form for now."
	| pitch slicePitch actualData |
	self assert: data isForm.
	pitch := data width * (data depth // 8).
	slicePitch := pitch * data height.
	data unhibernate.
	actualData := data bits.
	data depth < 32 ifTrue: [ actualData := actualData asByteArray ].
	handle uploadTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch data: actualData.