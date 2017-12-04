building
bank: bankName with: aBlock
	| bank |
	bank := WDCShaderSignatureSpecBank new name: bankName; index: elements size.
	elements add: bank.
	aBlock value: bank.
	^ bank