as yet unclassified
newCharacterSpanDisplayCommand: span start: startPos stop: stopPos advance: aPoint
	^ WTAthensTxCharacterSpanDisplayCommand new 
			span: span start: startPos stop: stopPos;
			advance: aPoint;
			yourself