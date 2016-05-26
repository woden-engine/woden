initialization
createFrameFences
	frameFences := (1 to: self frameBufferingCount) collect: [ :i | device createFence ]