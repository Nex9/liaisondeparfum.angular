class FindPrice extends Directive

  constructor: ->

    return {

      scope: true
      controller: 'findPriceController as findprice'
      bindToController:
        options: '=variants'
        product: '='
        attributes: '@'
      templateUrl: '/app/shop/find-price.html'

    }

class FindPriceController extends Controller

  constructor: ($scope, $parse, @imagoCart) ->
    return unless @attributes
    @attrs = $parse(@attributes)()

    initWatcher = =>
      toWatchProperties = ['findprice.imagoCart.currency', 'findprice.options']
      createWatchFunc = (name) =>
        toWatchProperties.push(=> @product[name])

      for name in @attrs
        createWatchFunc(name)

      $scope.$watchGroup toWatchProperties, =>
        @findOpts()

    watch = $scope.$watch 'findprice.product', (value) ->
      return unless value
      watch()
      initWatcher()

  findOpts: ->
    return unless @imagoCart.currency and @options?.length and @product
    @variants = _.clone @options

    for name in @attrs
      continue unless @product[name]
      @variants = _.filter @variants, (item) =>
        return @product[name] is item.fields?[name]?.value

    @findPrice()

  findPrice: ->
    @prices = []
    @discounts = []

    for option in @variants
      if option.fields?.price?.value?[@imagoCart.currency] isnt undefined
        @prices.push option.fields.price.value[@imagoCart.currency]

      if option.fields?.discountedPrice?.value?[@imagoCart.currency] isnt undefined
        @discounts.push option.fields.discountedPrice.value[@imagoCart.currency]

    return unless @prices.length
    @highest = Math.max.apply(Math, @prices)

    if @discounts.length
      @lowest = Math.max.apply(Math, @discounts)
    else
      @lowest = Math.min.apply(Math, @prices)

    # console.log '@prices', @prices
    # console.log '@highest', @highest
    # console.log '@lowest', @lowest

