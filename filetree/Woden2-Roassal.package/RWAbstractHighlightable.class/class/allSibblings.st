public
allSibblings

	^ self highlightElements: [ :el | el view elements select: [ :e | e model notNil and: [ e model == el model ]] ]