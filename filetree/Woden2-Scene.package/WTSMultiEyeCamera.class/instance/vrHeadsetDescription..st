projections
vrHeadsetDescription: aWTVRHeadsetDescription
	vrHeadset := aWTVRHeadsetDescription.
	projectionMode := #vr.
	eyes first transform translation: vrHeadset leftTranslation.
	eyes first transform translation: vrHeadset rightTranslation.