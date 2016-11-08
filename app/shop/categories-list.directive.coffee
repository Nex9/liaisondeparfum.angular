class CategoriesList extends Directive

  constructor: ->

    return {

      scope:
        categories: '='
        navigate: '&'
        active: '='

      templateUrl: '/app/shop/categories-list.html'
      link: (scope, element, attrs) ->

        scope.onNavigate = (category) ->
          scope.navigate({category: category})

        scope.isCategoryActive = (category) ->
          return false unless scope.active
          if _.isArray scope.active
            for item in scope.active
              return true if _.kebabCase(category) is _.kebabCase(item)
          else
            return _.kebabCase(scope.active) is _.kebabCase(category)

    }
