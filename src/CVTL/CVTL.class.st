Class {
	#name : #CVTL,
	#superclass : #Object,
	#instVars : [
		'memory',
		'exitBlock',
		'ui',
		'status'
	],
	#classVars : [
		'VariableTable'
	],
	#category : #'CVTL-Core'
}

{ #category : #'class initialization' }
CVTL class >> initialize [
	"CVTL initialize"

	VariableTable := self variableTable
]

{ #category : #private }
CVTL class >> variableTable [

	| obj dict |
	obj := self new.
	dict := Array new: 128.
	0 to: 127 do: [ :each | 
	dict at: each + 1 put: (obj indexForAsciiValue: each) ].
	^ dict
]

{ #category : #accessing }
CVTL >> addressForAsciiValue: anInteger [

	VariableTable ifNil: [ self class initialize ].
	^ 2 * ((VariableTable at: anInteger + 1) + 2)
]

{ #category : #accessing }
CVTL >> boundary [

	^ memory wordAt: self boundaryAddress
]

{ #category : #accessing }
CVTL >> boundary: anInteger [

	memory wordAt: self boundaryAddress put: anInteger
]

{ #category : #constants }
CVTL >> boundaryAddress [

	^ 2 * (2 + $& asciiValue)
]

{ #category : #accessing }
CVTL >> currentLineNo [

	^ memory wordAt: self currentLineNoAddress
]

{ #category : #accessing }
CVTL >> currentLineNo: anInteger [

	memory wordAt: self currentLineNoAddress put: anInteger
]

{ #category : #constants }
CVTL >> currentLineNoAddress [

	^ 2 * (2 + $# asciiValue)
]

{ #category : #private }
CVTL >> deleteLineNo: anInteger [

	| cur src dst boundary |
	self currentLineNo: anInteger.
	cur := self findLine.
	cur ifNil: [ ^ nil ].
	(memory wordAt: cur) = anInteger ifFalse: [ ^ cur ].
	src := self nextLineOf: cur.
	boundary := self boundary.
	dst := cur.
	[ src ~= boundary ] whileTrue: [ 
		memory copyByteFrom: src to: dst.
		src := src + 1.
		dst := dst + 1 ].
	self boundary: dst.
	^ cur
]

{ #category : #action }
CVTL >> doEntryLineNo: anInteger from: anInteger2 [

	| cur count |
	cur := self deleteLineNo: anInteger.
	cur ifNil: [ cur := self boundary ].
	(memory byteAt: anInteger2) = 0 ifTrue: [ ^ self ].
	count := 3 + (memory countFrom: anInteger2 until: 0).
	(self insert: count at: cur) ifFalse: [ ^ self ].
	self putLineNo: anInteger from: anInteger2 to: cur
]

{ #category : #action }
CVTL >> doExecuteStep [

	| lineNo r2 |
	self executeContext: (self newContext: status pos).
	lineNo := self currentLineNo.
	r2 := memory wordAt: status address.
	(lineNo = 0 or: [ lineNo = r2 ])
		ifTrue: [ 
			status address = self lineBufferAddress ifTrue: [ 
				^ status bePrompted ].
			status address: (self nextLineOf: status address).
			status address >= self boundary ifTrue: [ ^ status bePrompted ] ]
		ifFalse: [ 
			lineNo := memory wordAt: status address.
			memory wordAt: self savedLineNoAddress put: lineNo + 1.
			status address: self findLine.
			status address ifNil: [ ^ status bePrompted ] ].
	lineNo := memory wordAt: status address.
	self currentLineNo: lineNo.
	status pos: status address + 2 + 1
]

{ #category : #action }
CVTL >> doExit [

	exitBlock ifNil: [ ^ self ].
	exitBlock value
]

{ #category : #action }
CVTL >> doList [

	| context num boundary |
	context := self newContext: self programAddress.
	boundary := self boundary.
	[ context pos < boundary ] whileTrue: [ 
		num := memory wordAt: context pos.
		self putNumber: num.
		context
			incrementPos;
			incrementPos.
		self putUntil: 0 context: context.
		self putCrlf ]
]

{ #category : #action }
CVTL >> doOneCycle [

	| pos context lineNo |
	status isPrompted ifTrue: [ 
		pos := self lineBufferAddress + 2.
		self getLineInto: pos.
		context := self newContext: pos.
		lineNo := self getNumberContext: context.
		lineNo ifNotNil: [ 
			^ lineNo = 0
				  ifTrue: [ self doList ]
				  ifFalse: [ self doEntryLineNo: lineNo from: context pos ] ].
		status pos: pos.
		pos := self lineBufferAddress.
		memory wordAt: pos put: 0.
		self currentLineNo: 0.
		status
			beStepping;
			address: pos ].
	status isStepping ifTrue: [ ^ self doExecuteStep ].
	self error
]

{ #category : #private }
CVTL >> executeContext: aContext [

	| tmp c address c2 value |
	tmp := self getVariableContext: aContext.
	c := tmp first.
	address := tmp second.
	aContext incrementPos.
	c2 := memory byteAt: aContext pos.
	c2 = $" asciiValue ifTrue: [ 
		aContext incrementPos.
		self putUntil: $" asciiValue context: aContext.
		c2 := memory byteAt: aContext pos.
		c2 = $; asciiValue ifFalse: [ self putCrlf ].
		^ self ].
	value := self expressionContext: aContext.
	c = $$ asciiValue ifTrue: [ ^ self putAsciiValue: (value bitAnd: 16rFF) ].
	c = $? asciiValue ifTrue: [ ^ self putNumber: value ].
	memory wordAt: address put: value.
	self updateRandom: value
]

{ #category : #accessing }
CVTL >> exitBlock [

	^ exitBlock
]

{ #category : #accessing }
CVTL >> exitBlock: anObject [

	exitBlock := anObject
]

{ #category : #private }
CVTL >> expressionContext: aContext [

	| value c |
	value := self factorContext: aContext.
	[ 
	(c := memory byteAt: aContext pos) ~= 0 and: [ c ~= $) asciiValue ] ] 
		whileTrue: [ value := self term: value context: aContext ].
	aContext incrementPos.
	^ value
]

{ #category : #private }
CVTL >> factorContext: aContext [

	| c tmp |
	c := memory byteAt: aContext pos.
	c = 0 ifTrue: [ ^ 0 ].
	tmp := self getNumberContext: aContext.
	tmp ifNotNil: [ ^ tmp ].
	c := memory byteAt: aContext pos.
	aContext incrementPos.
	c = $? asciiValue ifTrue: [ 
		tmp := self lineBufferAddress.
		self getLineInto: tmp.
		^ self expressionContext: (self newContext: tmp) ].
	c = $$ asciiValue ifTrue: [ self error ].
	c = $( asciiValue ifTrue: [ ^ self expressionContext: aContext ].
	aContext decrementPos.
	tmp := self getVariableContext: aContext.
	^ memory wordAt: tmp second
]

{ #category : #private }
CVTL >> findLine [

	| pos v boundary currentLine |
	boundary := self boundary.
	currentLine := self currentLineNo.
	pos := self programAddress.
	[ pos ~= boundary ] whileTrue: [ 
		v := memory wordAt: pos.
		v >= currentLine ifTrue: [ 
			^ pos ].
		pos := self nextLineOf: pos ].
	^ nil
]

{ #category : #'input/output' }
CVTL >> getLineInto: anInteger [

	| ret |
	ret := ui getLine.
	ret ifNil: [ ^ self doExit ].
	memory copyString: ret to: anInteger
]

{ #category : #private }
CVTL >> getNumberContext: aContext [

	| c num pos |
	pos := aContext pos.
	c := memory byteAt: pos.
	(Character value: c) isDigit ifFalse: [ ^ nil ].
	num := 0.
	[ (Character value: c) isDigit ] whileTrue: [ 
		num := num * 10.
		num := num + (c - $0 asciiValue).
		pos := pos + 1.
		c := memory byteAt: pos ].
	aContext pos: pos.
	^ num
]

{ #category : #private }
CVTL >> getVariableContext: aContext [

	| c value address |
	c := memory byteAt: aContext pos.
	aContext incrementPos.
	c = $: asciiValue
		ifTrue: [
			value := self expressionContext: aContext.
			address := self boundary + (value * 2) ]
		ifFalse: [ address := self addressForAsciiValue: c ].
	^ Array with: c with: address
]

{ #category : #private }
CVTL >> indexForAsciiValue: anInteger [

	anInteger = Character delete asciiValue ifTrue: [ 
		^ self invalidCharacterIndex ].
	anInteger = Character space asciiValue ifTrue: [ ^ 16r20 ].
	(anInteger between: $0 asciiValue and: $9 asciiValue) ifTrue: [ 
		^ anInteger ].
	(anInteger between: $! asciiValue and: $? asciiValue) ifTrue: [ 
		^ anInteger ].
	(anInteger between: $@ asciiValue and: $_ asciiValue) ifTrue: [ 
		^ anInteger - $@ asciiValue ].
	(anInteger between: $a asciiValue and: $z asciiValue) ifTrue: [ 
		^ anInteger - 16r60 ].
	^ self invalidCharacterIndex
]

{ #category : #private }
CVTL >> insert: anInteger at: anInteger2 [

	| boundary limit src dst |
	boundary := self boundary.
	limit := self memoryLimit.
	boundary + anInteger >= limit ifTrue: [ ^ false ].
	src := boundary.
	boundary := boundary + anInteger.
	self boundary: boundary.
	dst := boundary.
	[ src ~= anInteger2 ] whileTrue: [ 
		dst := dst - 1.
		src := src - 1.
		memory copyByteFrom: src to: dst ].
	^ true
]

{ #category : #constants }
CVTL >> invalidCharacterIndex [

	^ 16r66
]

{ #category : #constants }
CVTL >> lineBufferAddress [

	^ 16r88
]

{ #category : #accessing }
CVTL >> memory [

	^ memory
]

{ #category : #accessing }
CVTL >> memory: anObject [

	memory := anObject
]

{ #category : #accessing }
CVTL >> memoryLimit [

	^ memory wordAt: self memoryLimitAddress
]

{ #category : #accessing }
CVTL >> memoryLimit: anInteger [

	memory wordAt: self memoryLimitAddress put: anInteger
]

{ #category : #constants }
CVTL >> memoryLimitAddress [

	^ 2 * (2 + $* asciiValue)
]

{ #category : #'instance creation' }
CVTL >> newContext: anInteger [

	^ CVTLContext pos: anInteger
]

{ #category : #private }
CVTL >> nextLineOf: anInteger [

	| pos c |
	pos := anInteger + 2.
	[ 
	c := memory byteAt: pos.
	pos := pos + 1.
	c ~= 0 ] whileTrue.
	^ pos
]

{ #category : #constants }
CVTL >> numberBufferAddress [

	^ 16r82
]

{ #category : #constants }
CVTL >> programAddress [

	^ 16r108
]

{ #category : #'input/output' }
CVTL >> putAsciiValue: anInteger [

	ui putAsciiValue: anInteger
]

{ #category : #'input/output' }
CVTL >> putCrlf [

	self
		putAsciiValue: Character cr asciiValue;
		putAsciiValue: Character lf asciiValue
]

{ #category : #private }
CVTL >> putLineNo: anInteger from: anInteger2 to: anInteger3 [

	| src dst tmp |
	memory wordAt: anInteger3 put: anInteger.
	src := anInteger2.
	dst := anInteger3 + 2.
	[ 
	tmp := memory copyByteFrom: src to: dst.
	src := src + 1.
	dst := dst + 1.
	tmp ~= 0 ] whileTrue
]

{ #category : #'input/output' }
CVTL >> putNumber: anInteger [

	| pos x y |
	x := anInteger.
	pos := self numberBufferAddress + 5.
	memory byteAt: pos put: 0.
	[ 
	y := x \\ 10.
	x := x // 10.
	pos := pos - 1.
	memory byteAt: pos put: y + $0 asciiValue ] doWhileTrue: [ x ~= 0 ].
	self putUntil: 0 context: (self newContext: pos)
]

{ #category : #'input/output' }
CVTL >> putString: aString [

	aString do: [ :each | self putAsciiValue: each asciiValue ].
	self putCrlf
]

{ #category : #'input/output' }
CVTL >> putUntil: anInteger context: aContext [

	| c |
	[ 
	c := memory byteAt: aContext pos.
	c ~= anInteger ] whileTrue: [ 
		self putAsciiValue: c.
		aContext incrementPos ].
	aContext incrementPos
]

{ #category : #constants }
CVTL >> randomAddress [

	^ 2 * (2 + $' asciiValue)
]

{ #category : #constants }
CVTL >> remainderAddress [

	^ 2 * (2 + $% asciiValue)
]

{ #category : #constants }
CVTL >> savedLineNoAddress [

	^ 2 * (2 + $! asciiValue)
]

{ #category : #accessing }
CVTL >> status [

	^ status
]

{ #category : #accessing }
CVTL >> status: anObject [

	status := anObject
]

{ #category : #private }
CVTL >> term: anInteger context: aContext [

	| c value |
	c := memory byteAt: aContext pos.
	aContext incrementPos.
	value := self factorContext: aContext.
	c = $* asciiValue ifTrue: [ ^ anInteger * value ].
	c = $+ asciiValue ifTrue: [ ^ anInteger + value ].
	c = $- asciiValue ifTrue: [ ^ anInteger - value ].
	c = $/ asciiValue ifTrue: [ 
		memory wordAt: self remainderAddress put: anInteger \\ value.
		^ anInteger // value ].
	c = $= asciiValue ifTrue: [ ^ (anInteger = value) asBit ].
	c = $> asciiValue ifTrue: [ ^ (anInteger >= value) asBit ].
	^ (anInteger < value) asBit
]

{ #category : #accessing }
CVTL >> ui [

	^ ui
]

{ #category : #accessing }
CVTL >> ui: anObject [

	ui := anObject
]

{ #category : #private }
CVTL >> updateRandom: anInteger [

	| tmp |
	tmp := memory wordAt: self randomAddress.
	tmp := tmp + anInteger.
	tmp := (tmp << 8 bitAnd: 16rFF00) + (tmp >> 8 bitAnd: 16rFF).
	memory wordAt: self randomAddress put: tmp
]
