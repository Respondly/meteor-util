###
Represents an elapsed time.
###
class Util.Elapsed
  constructor: (@startedAt, @endedAt) ->
    @endedAt ?= new Date()
    @seconds = ((@endedAt - @startedAt) / 1000).round()
    @minutes = (@seconds / 60)
    @minutes = @minutes.round(if @minutes < 1 then 1 else 0)



  format: (options = {}) ->
    options.from = @endedAt
    Util.date.elapsed(@startedAt, options)


  formatAgo: (options = {}) ->
    options.from = @endedAt
    Util.date.elapsedAgo(@startedAt, options)


  toString: -> @formatAgo(justNow:false)
