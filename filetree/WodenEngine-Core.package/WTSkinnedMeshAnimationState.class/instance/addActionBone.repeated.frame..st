adding
addActionBone: actionBone repeated: repeated frame: frame
	| floorFrameIndex ceilingFrameIndex alpha floorFrame ceilingFrame interpolatedFrame |
	floorFrameIndex := self computeFrameIndex: frame floor asInteger actionBone: actionBone repeated: repeated.
	ceilingFrameIndex := self computeFrameIndex: frame ceiling asInteger actionBone: actionBone repeated: repeated.
	alpha := frame - floorFrameIndex min: 1.0 max: 0.0.
	
	floorFrame := actionBone keyframes at: floorFrameIndex.
	ceilingFrame := actionBone keyframes at: ceilingFrameIndex.
	
	interpolatedFrame := self interpolateFrame: floorFrame with: ceilingFrame alpha: alpha.
	pose at: actionBone boneIndex + 1 put: interpolatedFrame