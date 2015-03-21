class window.GameView extends Backbone.View
  template: _.template '
    <span class = "chips">Chips: $<%=chips%> </span>
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
      when 'win' then (@options.color = 'green') and @newGameTemplate status:'YOU WIN!!!!!'
      when 'draw' then (@options.color = 'black') and @newGameTemplate status:'YOU DRAW ' + '\xAF\\_(\u30C4)_/\xAF' # '¯\\_(ツ)_/¯'
      when 'lose' then (@options.color = 'red') and @newGameTemplate status:'YOU LOSE :('
      when 'bankrupt' then (@options.color = 'red') and @newGameTemplate status:'THANKS FOR THE MONEY!!!!!'
      else ''

  events:
    'click .hit-button': -> @model.playerHit()
    'click .stand-button': -> @model.playerStand()

  initialize: ->
    @model.set 'name', prompt('What is your name?', 'Anonymous') or 'Anonymous'
    if @model.get('name') isnt 'Anonymous'
      @model.set 'chips', JSON.parse window.localStorage[@model.get 'name'] || "100"
    @render()
    @listenTo @model, 'change:status', @render
    @listenTo @model, 'change:chips', -> if window.localStorage then window.localStorage[@model.get 'name'] = JSON.stringify @model.get 'chips'
    @$el.on 'click', '.newGame', => @model.newGame()
    @options.color = 'black'

  chipColor: ->
    chips = @model.get 'chips'
    initChips = @model.get 'initChips'
    if chips > initChips then 'green'
    else if chips is initChips then 'black'
    else 'red'

  render: ->
    @$el.html @template
      button:@newGameText()
      chips:@model.get 'chips'
      betSize:@model.get 'betSize'
    @$el.children('.chips').css('color', @chipColor())
    @$el.children('.newGame').css('color', @options.color)
    @$('.player-hand-container').html new HandView(collection: (@model.get 'playerHand'), name: @model.get 'name').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
