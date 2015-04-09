class Dashing.Errors extends Dashing.Widget

  ready: ->
    # ...

  onData: (data) ->
    console.log('[Errors] Got data : ', data)

    @set('errors', JSON.parse(data.value))
