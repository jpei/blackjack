class window.GameView extends Backbone.View
  template: _.template '
    <span class = "chips">Chips: <%=chips%> </span>
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <%= button %>
    <div class = "betSize">Bet Size: <%=betSize%></div>
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
    @model.set 'name', prompt('What is your name?', 'Anonymous') or 'Anonymous'
    @render()
    @listenTo @model, 'change:status', @render
    @$el.on 'click', '.newGame', => @model.newGame()

  render: ->
    @$el.html @template
      button:@newGameText()
      chips:@model.get 'chips'
      betSize:@model.get 'betSize'
    @$('.player-hand-container').html new HandView(collection: (@model.get 'playerHand'), name: @model.get 'name').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
