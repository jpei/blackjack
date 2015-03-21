class window.Game extends Backbone.Model
  initialize: (params)->

    @set
      deck: params.deck
      player: params.player
      dealer: params.dealer
      turn: 'player'
      chips: 100
      betSize: 5

    if @get('dealer').isBlackjack() and @get('player').isBlackjack()
      @get('dealer').at(0).flip()
      @draw()


    if @get('dealer').isBlackjack()
      @get('dealer').at(0).flip()
      @lose()


    if @get('player').isBlackjack()
      @win()


  playerHit: ->
    if @get('turn') == 'player'
      if @get('player').minScore() < 21
        @get('player').hit()
        if @get('player').minScore() > 21
          @lose()


  playerStand: ->
    if @get('turn') == 'player'
      @set 'turn', 'dealer'
      @dealerStart()

  dealerHit: ->
    @get('dealer').hit()
    if @get('dealer').minScore() > 21
      @win()

  dealerStart: ->
    @get('dealer').at(0).flip()
    while @get('dealer').maxScore() < 17 + @get('dealer').hasAce()
      @dealerHit()
    if @get('turn') != 'over'
      playerScore = @get('player').maxScore()
      dealerScore = @get('dealer').maxScore()
      if playerScore > dealerScore
        @win()
      else if playerScore == dealerScore
        @draw()
      else @lose()


  win: ->
    @set 'turn', 'over'
    button = $ '.newGame'
    button.show()
    button.text 'YOU WIN!!!!!'


  lose: ->
    @set 'turn', 'over'
    button = $ '.newGame'
    button.show()
    button.text 'YOU LOSE :('

  draw: ->
    @set 'turn', 'over'
    button = $ '.newGame'
    button.show()
    button.text 'YOU DRAW ¯\\_(ツ)_/¯'

  newGame: ->

