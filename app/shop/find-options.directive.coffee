class FindOptions extends Directive

  constructor: ->

    return {

      scope:
        variants: '='
        fields: '=options'
        selectedOption: '&'
      controller: 'findOptionsController as findoptions'
      bindToController: true
      templateUrl: '/app/shop/find-options.html'

    }

class FindOptionsController extends Controller

  constructor: ->
    @options = {}

    for variant in @variants
      for field in @fields
        @options[field] or= {}
        value = variant.fields?[field]?.value
        continue unless value
        item = {}
        item.name = variant.fields[field].value
        item.swatchColor = variant.fields['swatchColor']?.value
        if not @options[field][value]?.valid and variant.fields.stock?.value
          item.valid = !!variant.fields.stock?.value
        @options[field][value] = item
    # console.log '@options', @options

  selected: (option) ->
    # console.log 'selected', @selectedOption, option
    return unless @selectedOption or option
    @selectedOption({option: option})
