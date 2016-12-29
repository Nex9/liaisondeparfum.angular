angular.module 'app', [
  'angulartics'
  'angulartics.google.analytics'
  'angulartics.facebook.pixel'
  'ngAnimate'
  'ngTouch'
  'ui.router'
  'templatesApp'
  'angular-inview'
  'imago'
  'lodash'
  'ngSanitize'
  'headroom'
  'com.2fdevs.videogular'
  'com.2fdevs.videogular.plugins.controls'
  'com.2fdevs.videogular.plugins.overlayplay'
  'com.2fdevs.videogular.plugins.poster'
]

class Setup extends Config

  constructor: ($httpProvider, $provide, $sceProvider, $locationProvider, $compileProvider, $stateProvider, $urlRouterProvider, $analyticsProvider, imagoModelProvider) ->

    $sceProvider.enabled false
    $httpProvider.useApplyAsync true

    $provide.decorator '$exceptionHandler', [
      '$delegate'
      '$window'
      ($delegate, $window) ->
        (exception, cause) ->
          if $window.trackJs
            $window.trackJs.track exception
          $delegate exception, cause
    ]

    if document.location.hostname is 'localhost'
      $analyticsProvider.developerMode true
    else
      $compileProvider.debugInfoEnabled false

    $analyticsProvider.firstPageview true
    $locationProvider.html5Mode true
    $urlRouterProvider.otherwise '/'

    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: '/app/home/home.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/home'

      .state 'about',
        url: '/about'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/about'

      .state 'inprint',
        url: '/inprint'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/inprint'

      .state 'policy',
        url: '/policy'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/policy'

      .state 'terms',
        url: '/terms'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/terms'

      .state 'contact',
        url: '/contact'
        templateUrl: '/app/contact/contact.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/contact'

      .state 'shop',
        url: '/shop?{tag}'
        templateUrl: '/app/shop/shop.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel, $stateParams) ->
            query =
              path: '/shop'

            if $stateParams.tag
              query.tags = $stateParams.tag

            imagoModel.getData query

      .state 'product',
        url: '/shop/:product?{color}&{size}'
        templateUrl: '/app/product/product.html'
        controller: 'product as page'
        resolve:
          promiseData: (imagoModel, $stateParams) ->
            imagoModel.getData
              path: "/shop/#{$stateParams.product}"


      .state 'blog',
        url: '/blog'
        templateUrl: '/app/blog/blog.html'
        reload: true
        data:
          pageSize: 5
          query: '/blog'
      .state 'blog.paged',
        url: '/page/:page'
      .state 'blog.filtered',
        url: '/tags/:tag'
      .state 'blog.filtered.paged',
        url: '/page/:page'


      .state 'blogpage',
        url: '/blog/:page'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel, $stateParams) ->
            imagoModel.getData
              path: "/blog/#{$stateParams.page}"





class Load extends Run

  constructor: ($rootScope, $state, $location, $timeout, tenantSettings, imagoUtils, ngProgress) ->
    document.documentElement.classList.remove('nojs')

    # imago image enable blury preview
    $rootScope.imagePlaceholder = true
    # imago video theme
    $rootScope.videoTheme = 'https://storage.googleapis.com/videoangular-imago-theme/videoangular-imago-theme.min.css'

    $rootScope.js = true
    $rootScope.mobile = imagoUtils.isMobile()
    $rootScope.mobileClass = if $rootScope.mobile then 'mobile' else 'desktop'
    FastClick.attach(document.body)


    $rootScope.toggleMenu = (status) ->
      if _.isUndefined status
        $rootScope.navActive = !$rootScope.navActive
      else
        $rootScope.navActive =  status

    $rootScope.$on '$stateChangeStart', (evt) ->
      ngProgress.start()


    # general code
    $rootScope.$on '$stateChangeSuccess', (evt) ->
      $rootScope.urlPath = $location.path()
      $rootScope.controller =  _.last $state.current.controller.split(' ')
      state = $state.current.name.split('.').join(' ')
      path  = $rootScope.urlPath.split('/').join(' ')
      path = 'home' if path is ' '
      $rootScope.state = state
      $rootScope.path  = path
      $rootScope.toggleMenu(false)
      ngProgress.done()

