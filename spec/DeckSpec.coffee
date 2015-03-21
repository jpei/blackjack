assert = chai.assert

describe 'deck', ->
  deck = null
  hand = null

  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  describe 'hit', ->
    it 'should give the last card from the deck', ->
      assert.strictEqual deck.length, 50
      assert.strictEqual deck.last(), hand.hit().at(2)
      assert.strictEqual deck.length, 49

  describe 'flip', ->
    it 'should have the dealer\'s first card flipped', ->
      dealer = deck.dealDealer()
      assert.strictEqual (dealer.at(0).get('revealed')), false


