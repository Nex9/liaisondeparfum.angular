class SimpleAddtobag extends Component

  constructor: ->
    return {
      bindings:
        product: '<'
      controller: 'simpleAddtobagController'
      templateUrl: '/app/shop/simple-addtobag.html'

    }

class SimpleAddtobagController extends Controller

  constructor: (@imagoCart, @imagoProduct) ->

  $onInit: ->
    return unless @product?.sellable

    @optionsWhitelist = [
      { name  : 'size' }
      { name  : 'color' }
    ]

    optionsProduct =
      optionsWhitelist : @optionsWhitelist
      lowStock  : 3

    @productItem = new @imagoProduct(@product.variants, optionsProduct)

    # set default product item
    @productItem.setOption('size', @productItem.variants[0]?.fields?.size?.value)
    @productItem.setOption('color', @productItem.variants[0]?.fields?.color?.value)
    # set default varient in select box
    @selectedVariant = @productItem.variants[0]

