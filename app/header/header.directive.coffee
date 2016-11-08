class Header extends Directive

  constructor: () ->

    return {

      templateUrl: '/app/header/header.html'
      controller: 'headerController as header'

    }

class HeaderController extends Controller

  constructor: (@$rootScope, imagoCart, imagoUtils, imagoModel) ->
    @utils  = imagoCart


    # imagoModel.getData({path: '/shop', recursive: true}).then (response) =>
    #   for data in response
    #     @categoriesShop = []
    #     for item in data.fields.shopCategories.value.split('\n')
    #       continue unless item
    #       @categoriesShop.push {name: item, bold: true}

    #     console.log '@categoriesShop', @categoriesShop

    # @$rootScope.$on 'shop:params', (evt, data) =>
    #   @activeCategory = data

    # @$rootScope.$on '$stateChangeSuccess', (evt, current) =>
    #   # @navActive = false
    #   @activeCategory = null if current.name not in ['shop', 'product']

  activate: (state) ->
    if state is 'show'
      @$rootScope.navActive = true
    else if state is 'hide'
      @$rootScope.navActive = false
    else
      @$rootScope.navActive = !@$rootScope.navActive


