adding
interpolateFrame: a with: b alpha: alpha
	| translation rotation |
	translation := (a translation * (1.0 - alpha)) + (b translation * alpha).
	rotation := ((a rotation * (1.0 - alpha)) + (b rotation * alpha)) normalized.
	^ WTAnimationActionBoneFrame new translation: translation; rotation: rotation; yourself