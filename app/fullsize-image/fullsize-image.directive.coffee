class FullsizeImage extends Directive

  constructor: ($rootScope, $timeout) ->

    return {
      replace: true
      transclude: true
      templateUrl: '/app/fullsize-image/fullsize-image.html'
      controller: 'fullsizeImageController as fullsize'
    }

class FullsizeImageController extends Controller

  constructor: (@$rootScope, $scope, @$timeout, @$element, $document) ->

    @htmlEl = document.getElementsByTagName("html")[0]

    watchEsc = (evt) =>
      return unless evt.keyCode is 27 and @trigger
      @toggle()

    $document.on 'keydown', watchEsc

    $scope.$on '$destroy', ->
      $document.off 'keydown', watchEsc

  toggle: ->
    # @$element.css(height: "#{@$element[0].clientHeight}px") unless @trigger

    @trigger = !@trigger

    touchstart = (evt) ->
      evt.stopPropagation()

    if @trigger
      @htmlEl.style.overflow = 'hidden'
      console.log 'overflow hidden', @htmlEl.style.overflow
      elem = @$element[0].querySelector('img.imagox23')
      elem.removeAttribute('style') if elem
      @$element.on 'touchstart', touchstart
    else
      @htmlEl.style.overflow = 'auto'
      @$element.off 'touchstart'

    @$timeout.cancel(@watcher) if @watcher
    @watcher = @$timeout =>
      @$rootScope.$emit 'resizestop'
      # @$element.css(height: 'initial')
    , 300
