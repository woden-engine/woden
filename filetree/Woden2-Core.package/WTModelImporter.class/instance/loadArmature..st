as yet unclassified
loadArmature: armatureData
	| bones names location orientation parentIndex boneParents |
	names := armatureData collect: [ :boneData | boneData at: 'name' ].
	boneParents := NativeArray for: #int new: armatureData size.
	bones := NativeArray for: WTAnimationActionBoneFrame new: armatureData size.
	armatureData doWithIndex: [ :boneData :index |
		location := self loadVector3: (boneData at: 'location').
		orientation := self loadQuaternion: (boneData at: 'orientation').
		parentIndex := boneData at: 'parent'.
		boneParents at: index put: parentIndex.
		bones at: index put: (WTAnimationActionBoneFrame new
			translation: location;
			rotation: orientation;
			yourself)
	].

	^ WTModelArmature new names: names; boneParents: boneParents; bones: bones; yourself