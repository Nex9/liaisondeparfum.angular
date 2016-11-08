class Collection extends Controller

  constructor: ($scope, imagoModel) ->

    imagoModel.getData().then (response) =>
      for data in response
        @data = data
        break
