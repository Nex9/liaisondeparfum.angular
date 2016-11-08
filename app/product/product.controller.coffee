class Product extends Controller

  constructor: (@$state, $rootScope, @$scope, @imagoProduct, @promiseData, @imagoCart) ->
    if @imagoCart.currency
      @getProduct()
    else
      watcher = $rootScope.$on 'imagocart:currencyloaded', (evt, data) =>
        @getProduct()
        watcher()


  getProduct: ->
    @optionsWhitelist = [
      {
        name  : 'color'
        color : 'swatchColor'
      }
      {
        name  : 'size'
      }
    ]

    optionsProduct =
      optionsWhitelist : @optionsWhitelist
      lowStock  : 3

    for item in @optionsWhitelist
      continue unless @$state.params[item.name]
      optionsProduct[item.name] = @$state.params[item.name]

    for item in @promiseData
      # redirect if not a procut
      # unless item.type is 'product'
      #   return @$state.go 'shop', collection: 'eyewear'

      @data = item
      @productItem = new @imagoProduct(item.variants, optionsProduct)
      break

    getDefault = (key) =>
      return _.head(_.head(@data.assets)?.assets)?.fields?[key]?.value


    for key, value of @productItem.options
      continue if @productItem[key]
      @productItem[key] = getDefault(key)

    toWatchProperties = []
    createWatchFunc = (name) =>
      toWatchProperties.push(=> @productItem[name])

    for item in @optionsWhitelist
      continue unless item.name
      createWatchFunc(item.name)

    @$scope.$watchGroup toWatchProperties, (value) =>
      @changePath()
      # @filterImages()


  changePath: ->
    console.log 'changePath'
    parameters = {}
    for item in @optionsWhitelist
      parameters[item.name] = @productItem[item.name]
      changed = true if @productItem[item.name] isnt @$state.params[item.name]

    console.log 'parameters', parameters
    return unless changed

    @$state.go 'product', parameters,
      'notify': false
      'location': 'replace'
