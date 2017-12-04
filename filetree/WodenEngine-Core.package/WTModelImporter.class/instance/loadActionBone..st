as yet unclassified
loadActionBone: actionBoneData
	| boneIndex keyframes keyframesData |
	boneIndex := actionBoneData at: 'index'.
	keyframesData := actionBoneData at: 'keyframes'.
	keyframes := SLVMNativeArray for: WTAnimationActionBoneFrame new: keyframesData size.
	keyframesData doWithIndex: [ :kf :index |
		keyframes at: index put: (WTAnimationActionBoneFrame new
			rotation: (self loadQuaternion: (kf at: 'rotation'));
			translation: (self loadVector3: (kf at: 'translation'));
			yourself
		)
	].

	^ WTAnimationActionBone new
		boneIndex: boneIndex;
		keyframes: keyframes;
		yourself