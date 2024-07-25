"
A CVTLContextTest is a test class for testing the behavior of CVTLContext
"
Class {
	#name : #VTLContextTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #'instance creation' }
VTLContextTest >> newObj [

	^ VTLContext new
]

{ #category : #tests }
VTLContextTest >> testDecrement [

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
VTLContextTest >> testIncrement [

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
VTLContextTest >> testPosition [

	| obj |
	obj := self newObj.
	self assert: obj position isNil.
	obj position: 123.
	self assert: obj position equals: 123.
	obj position: 456.
	self assert: obj position equals: 456
]

{ #category : #tests }
VTLContextTest >> testPrintOn [

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
