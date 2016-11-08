class Shop extends Controller

  constructor: (promiseData) ->
    for asset in promiseData
      @data = asset
      break


  selectedColor: (item, option) =>
    @$state.go 'product', {
      product: @imagoUtils.normalize item.name
      color: option
    }
