$(document).on "ajax:before", "*[data-change-quantity]", ->
  value = prompt($(this).data('change-quantity'))
  if isNaN(value)
    alert('Vous devez mettre une valeur numérique')
    return false

  $(this).data 'params',
    quantity: value

$(document).on "ajax:success", "*[data-change-quantity]",(status, data, xhr) ->
  $('#cart').html(data)


$(document).on "ajax:before", "*[data-change-unit-pretax-amount]", ->
  value = prompt($(this).data('change-unit_pretax_amount'))
  if isNaN(value)
    alert('Vous devez mettre une valeur numérique')
    return false

  $(this).data 'params',
    unit_pretax_amount: value

$(document).on "ajax:success", "*[data-change-unit-pretax-amount]",(status, data, xhr) ->
  $('#cart').html(data)


