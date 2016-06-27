as yet unclassified
loadArmature: armatureData
	| bones names location orientation parentIndex |
	names := armatureData collect: [ :boneData | boneData at: 'name' ].
	bones := NativeArray for: WTRestPoseBone new: armatureData size.
	armatureData doWithIndex: [ :boneData :index |
		location := self loadVector3: (boneData at: 'location').
		orientation := self loadQuaternion: (boneData at: 'orientation').
		parentIndex := boneData at: 'parent'.
		bones at: index put: (WTRestPoseBone new
			parentIndex: parentIndex;
			location: location;
			orientation: orientation;
			yourself)
	].

	^ WTModelArmature new names: names; bones: bones; yourself