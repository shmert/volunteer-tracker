'use strict'

describe 'Filter: time', ->

  # load the filter's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # initialize a new instance of the filter before each test
  time = {}
  beforeEach inject ($filter) ->
    time = $filter 'time'

  it 'should return the input prefixed with "time filter:"', ->
    text = 'angularjs'
    expect(time text).toBe ('time filter: ' + text)
