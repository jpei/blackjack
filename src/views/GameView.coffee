class window.GameView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <%= button %>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  newGameTemplate: _.template '<button class= "newGame"><%= status %></button>'

  newGameText: ->
    switch @model.get 'status'
      when 'win' then @newGameTemplate status:'YOU WIN!!!!!'
      when 'draw' then @newGameTemplate status:'YOU DRAW ' + '\xAF\\_(\u30C4)_/\xAF' # '¯\\_(ツ)_/¯'
      when 'lose' then @newGameTemplate status:'YOU LOSE :('
      else ''

  events:
    'click .hit-button': -> @model.playerHit()
    'click .stand-button': -> @model.playerStand()

  initialize: ->
    @render()
    @listenTo(@model, 'change:status', @render)

  render: ->
    @$el.html @template button:@newGameText()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
