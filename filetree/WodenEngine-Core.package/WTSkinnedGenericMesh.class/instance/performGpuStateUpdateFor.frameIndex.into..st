extra per object rendering data
performGpuStateUpdateFor: engine frameIndex: frameIndex into: animationState
	| poseStateSize |
	poseStateSize := self poseStateSize.
	LibC memCopy: animationState poseMatrices rawData to: animationState poseBuffer validPointer getHandle + (poseStateSize * (frameIndex - 1)) size: poseStateSize