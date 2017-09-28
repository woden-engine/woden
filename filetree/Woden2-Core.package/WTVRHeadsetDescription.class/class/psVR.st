as yet unclassified
psVR
	"Parameters obtained from https://github.com/gusmanb/PSVRFramework/blob/master/VRVideoPlayer/vrdevice.h"
	^ self new
		extent: 1920 @ 1080 dpi: 386.47 @ 386.47;

		fov: 68.0;
		interLensDistance: 0.0630999878;
		screenLensDistance: 0.0354;
		screenVerticalAlignment: 0.0394899882;
		distortionCoefficients: (WMVector2F x: 0.22 y: 0.24);
		yourself