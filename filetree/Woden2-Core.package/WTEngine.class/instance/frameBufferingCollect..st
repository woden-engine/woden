triple buffering
frameBufferingCollect: aBlock
	^ (1 to: self frameBufferingCount) collect: aBlock