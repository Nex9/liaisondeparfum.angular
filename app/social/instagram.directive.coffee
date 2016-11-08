class Instagram extends Directive

  constructor: ->

    return {
      templateUrl: '/app/social/instagram.html'
      controllerAs: 'instagram'
      controller: 'instagramController'
    }

class InstagramController extends Controller

  constructor: ($http, $scope, $attrs, imagoSettings) ->

    request = =>
      options = $scope.$eval($attrs.instagram)
      $http.post("#{imagoSettings.host}/api/social/instagram/feed", options).then (response) =>
        @data = response.data
        # console.log '@data.length', @data.length
        for item in @data
          item.style =
            'background-image' : "url(#{item.images.standard_resolution.url})"
            # 'top'              : "#{_.random(-150, 150)}px"
            # 'left'             : "#{_.random(-150, 150)}px"

    watcher = $scope.$watch $attrs.instagram, (news, old) ->
      return if angular.equals news, old
      request()
      watcher()

