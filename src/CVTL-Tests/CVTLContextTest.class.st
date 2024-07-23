"
A CVTLContextTest is a test class for testing the behavior of CVTLContext
"
Class {
	#name : #CVTLContextTest,
	#superclass : #TestCase,
	#category : #'CVTL-Tests'
}

{ #category : #'instance creation' }
CVTLContextTest >> newObj [

	^ CVTLContext new
]

{ #category : #tests }
CVTLContextTest >> testDecrementPos [

	| obj |
	obj := self newObj.
	obj pos: 123.
	self assert: obj pos equals: 123.
	obj decrementPos.
	self assert: obj pos equals: 122.
	obj decrementPos.
	self assert: obj pos equals: 121
]

{ #category : #tests }
CVTLContextTest >> testIncrementPos [

	| obj |
	obj := self newObj.
	obj pos: 123.
	self assert: obj pos equals: 123.
	obj incrementPos.
	self assert: obj pos equals: 124.
	obj incrementPos.
	self assert: obj pos equals: 125
]

{ #category : #tests }
CVTLContextTest >> testPos [

	| obj |
	obj := self newObj.
	self assert: obj pos isNil.
	obj pos: 123.
	self assert: obj pos equals: 123.
	obj pos: 456.
	self assert: obj pos equals: 456
]

{ #category : #tests }
CVTLContextTest >> testPrintOn [

	| obj stream |
	obj := self newObj.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[nil]'.
	obj pos: 123.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[123]'
]
