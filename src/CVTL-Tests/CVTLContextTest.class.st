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
CVTLContextTest >> testDecrement [

	| obj |
	obj := self newObj.
	obj position: 123.
	self assert: obj position equals: 123.
	obj decrement.
	self assert: obj position equals: 122.
	obj decrement.
	self assert: obj position equals: 121
]

{ #category : #tests }
CVTLContextTest >> testIncrement [

	| obj |
	obj := self newObj.
	obj position: 123.
	self assert: obj position equals: 123.
	obj increment.
	self assert: obj position equals: 124.
	obj increment.
	self assert: obj position equals: 125
]

{ #category : #tests }
CVTLContextTest >> testPosition [

	| obj |
	obj := self newObj.
	self assert: obj position isNil.
	obj position: 123.
	self assert: obj position equals: 123.
	obj position: 456.
	self assert: obj position equals: 456
]

{ #category : #tests }
CVTLContextTest >> testPrintOn [

	| obj stream |
	obj := self newObj.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[nil]'.
	obj position: 123.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[123]'
]
