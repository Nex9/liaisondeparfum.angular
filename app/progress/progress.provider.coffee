class ngProgress extends Provider

  constructor: ->

    # global configs
    settings = @settings =
      minimum: 0.08
      speed: 300
      ease: 'ease'
      trickleRate: 0.02
      trickleSpeed: 500
      template: '<div class="ngProgressLite"><div class="ngProgressLiteBar"><div class="ngProgressLiteBarShadow"></div></div></div>'

    @$get = ->
      $progressBarEl = undefined
      status = undefined
      cleanForElement = undefined
      privateMethods =
        render: ->
          $body = angular.element document.body
          return $progressBarEl if @isRendered()
          $body.addClass 'ngProgressLite-on'
          $progressBarEl = angular.element(settings.template)
          $body.append $progressBarEl
          cleanForElement = false
          $progressBarEl
        remove: ->
          $body = angular.element document.body
          $body.removeClass 'ngProgressLite-on'
          $progressBarEl.remove()
          cleanForElement = true
          return
        isRendered: ->
          $progressBarEl and $progressBarEl.children().length and !cleanForElement
        trickle: ->
          publicMethods.inc Math.random() * settings.trickleRate
        clamp: (num, min, max) ->
          if num < min
            return min
          if num > max
            return max
          num
        toBarPercents: (num) ->
          num * 100
        positioning: (num, speed, ease) ->
          {
            'width': @toBarPercents(num) + '%'
            'transition': 'all ' + speed + 'ms ' + ease
          }
      publicMethods =
        set: (num) ->
          $progress = privateMethods.render()
          num = privateMethods.clamp(num, settings.minimum, 1)
          status = if num == 1 then null else num
          setTimeout (->
            $progress.children().eq(0).css privateMethods.positioning(num, settings.speed, settings.ease)
            return
          ), 100
          if num == 1
            setTimeout (->
              $progress.css
                'transition': 'all ' + settings.speed + 'ms linear'
                'opacity': 0
              setTimeout (->
                privateMethods.remove()
                return
              ), settings.speed
              return
            ), settings.speed
          publicMethods
        get: ->
          status
        start: ->
          publicMethods.set(0) if !status

          worker = ->
            setTimeout (->
              if !status
                return
              privateMethods.trickle()
              worker()
              return
            ), settings.trickleSpeed
            return

          worker()
          publicMethods
        inc: (amount) ->
          n = status
          if !n
            return publicMethods.start()
          if typeof amount != 'number'
            amount = (1 - n) * privateMethods.clamp(Math.random() * n, 0.1, 0.95)
          n = privateMethods.clamp(n + amount, 0, 0.994)
          publicMethods.set n
        done: ->
          if status
            publicMethods.inc(0.3 + 0.5 * Math.random()).set 1
      publicMethods
