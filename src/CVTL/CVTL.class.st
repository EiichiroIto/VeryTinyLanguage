Class {
	#name : #CVTL,
	#superclass : #Object,
	#instVars : [
		'memory',
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

	| obj arr |
	obj := self new.
	arr := Array new: 256.
	0 to: 255 do: [ :each | 
	arr at: each + 1 put: (obj indexForAsciiValue: each) ].
	^ arr
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

{ #category : #action }
CVTL >> break [

	self
		putCrlf;
		putAsciiValue: $B asciiValue;
		putAsciiValue: $R asciiValue;
		putAsciiValue: $E asciiValue;
		putAsciiValue: $A asciiValue;
		putAsciiValue: $K asciiValue;
		putCrlf.
	status bePrompted
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
CVTL >> doList [

	| context num boundary |
	context := self newContext: self programAddress.
	boundary := self boundary.
	[ context position < boundary ] whileTrue: [ 
		num := memory wordAt: context position.
		self putNumber: num.
		context
			increment;
			increment.
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
				  ifFalse: [ self entry: context position lineNo: lineNo ] ].
		status position: pos.
		pos := self lineBufferAddress.
		memory wordAt: pos put: 0.
		self currentLineNo: 0.
		status
			beStepping;
			topOfLine: pos ].
	status isStepping ifTrue: [ 
		self executeOnce ifTrue: [ 
			self
				putCrlf;
				putAsciiValue: $O asciiValue;
				putAsciiValue: $K asciiValue;
				putCrlf.
			status bePrompted ].
		^ self ].
	self error
]

{ #category : #private }
CVTL >> entry: anInteger into: anInteger2 lineNo: anInteger3 [

	| src dst tmp |
	memory wordAt: anInteger2 put: anInteger3.
	src := anInteger.
	dst := anInteger2 + 2.
	[ 
	tmp := memory copyByteFrom: src to: dst.
	src := src + 1.
	dst := dst + 1.
	tmp ~= 0 ] whileTrue
]

{ #category : #private }
CVTL >> entry: anInteger lineNo: anInteger2 [

	| cur count |
	cur := self deleteLineNo: anInteger2.
	cur ifNil: [ cur := self boundary ].
	(memory byteAt: anInteger) = 0 ifTrue: [ ^ self ].
	count := 3 + (memory countFrom: anInteger until: 0).
	(self insert: count at: cur) ifFalse: [ ^ self ].
	self entry: anInteger into: cur lineNo: anInteger2
]

{ #category : #private }
CVTL >> executeContext: aContext [

	| tmp c address c2 value |
	tmp := self getVariableContext: aContext.
	c := tmp first.
	address := tmp second.
	aContext increment.
	c2 := aContext byteIn: memory.
	c2 = $" asciiValue ifTrue: [ 
		aContext increment.
		self putUntil: $" asciiValue context: aContext.
		c2 := aContext byteIn: memory.
		c2 = $; asciiValue ifFalse: [ self putCrlf ].
		^ self ].
	value := self expressionContext: aContext.
	c = $$ asciiValue ifTrue: [ 
		^ self putAsciiValue: (value bitAnd: 16rFF) ].
	c = $? asciiValue ifTrue: [ ^ self putNumber: value ].
	memory wordAt: address put: value.
	self updateRandom: value
]

{ #category : #private }
CVTL >> executeOnce [

	| lineNo r2 |
	self executeContext: (self newContext: status position).
	lineNo := self currentLineNo.
	r2 := memory wordAt: status topOfLine.
	(lineNo = 0 or: [ lineNo = r2 ])
		ifTrue: [ 
			status topOfLine = self lineBufferAddress ifTrue: [ ^ true ].
			status topOfLine: (self nextLineOf: status topOfLine).
			status topOfLine >= self boundary ifTrue: [ ^ true ] ]
		ifFalse: [ 
			lineNo := memory wordAt: status topOfLine.
			memory wordAt: self savedLineNoAddress put: lineNo + 1.
			status topOfLine: self findLine.
			status topOfLine ifNil: [ ^ true ] ].
	lineNo := memory wordAt: status topOfLine.
	self currentLineNo: lineNo.
	status position: status topOfLine + 2 + 1.
	^ false
]

{ #category : #private }
CVTL >> expressionContext: aContext [

	| value c |
	value := self factorContext: aContext.
	[ (c := aContext byteIn: memory) ~= 0 and: [ c ~= $) asciiValue ] ] 
		whileTrue: [ 
			value := self term: value context: aContext.
			value := value bitAnd: 16rFFFF ].
	aContext increment.
	^ value
]

{ #category : #private }
CVTL >> factorContext: aContext [

	| c tmp |
	c := aContext byteIn: memory.
	c = 0 ifTrue: [ ^ 0 ].
	tmp := self getNumberContext: aContext.
	tmp ifNotNil: [ ^ tmp ].
	c := aContext byteIn: memory.
	aContext increment.
	c = $? asciiValue ifTrue: [ 
		tmp := self lineBufferAddress.
		self getLineInto: tmp.
		^ self expressionContext: (self newContext: tmp) ].
	c = $$ asciiValue ifTrue: [ ^ self getAsciiValue ].
	c = $( asciiValue ifTrue: [ ^ self expressionContext: aContext ].
	aContext decrement.
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
CVTL >> getAsciiValue [

	^ ui getAsciiValue
]

{ #category : #'input/output' }
CVTL >> getLineInto: anInteger [

	| pos c |
	pos := 0.
	[ 
	c := self getAsciiValue.
	c ifNil: [ self error ].
	c = Character backspace asciiValue ifTrue: [ 
		pos > 0 ifTrue: [ 
			pos := pos - 1.
			self putAsciiValue: c ] ].
	c = Character cr asciiValue ifTrue: [ 
		memory byteAt: anInteger + pos put: 0.
		^ self putCrlf ].
	(c = 16r15 or: [ pos > 74 ]) ifTrue: [ 
		self putCrlf.
		pos := 0 ].
	c >= Character space asciiValue ifTrue: [ 
		memory byteAt: anInteger + pos put: c.
		self putAsciiValue: c.
		pos := pos + 1 ] ] repeat
]

{ #category : #private }
CVTL >> getNumberContext: aContext [

	| c num pos |
	pos := aContext position.
	c := memory byteAt: pos.
	(Character value: c) isDigit ifFalse: [ ^ nil ].
	num := 0.
	[ (Character value: c) isDigit ] whileTrue: [ 
		num := num * 10.
		num := num + (c - $0 asciiValue).
		pos := pos + 1.
		c := memory byteAt: pos ].
	aContext position: pos.
	^ num
]

{ #category : #private }
CVTL >> getVariableContext: aContext [

	| c value address |
	c := aContext byteIn: memory.
	aContext increment.
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

{ #category : #initialization }
CVTL >> initialize [

	status := self newStatus
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

{ #category : #'instance creation' }
CVTL >> newStatus [

	^ CVTLStatus new
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
CVTL >> putUntil: anInteger context: aContext [

	| c |
	[ 
	c := aContext byteIn: memory.
	c ~= anInteger ] whileTrue: [ 
		self putAsciiValue: c.
		aContext increment ].
	aContext increment
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
	c := aContext byteIn: memory.
	aContext increment.
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
