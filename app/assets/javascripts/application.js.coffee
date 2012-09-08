#= require jquery
#= require jquery_ujs
#= require_tree .

jQuery ->
	$('.start_station_select, .destination_station_select').select2
		ajax:
			url: '/stops.json'
			dataType: 'jsonp'
			data: (term) ->
				name: term
			results: (data) ->
				results: data
		formatResult: (stop) ->
			stop.name
		formatSelection: (stop) ->
			stop.name
	
	$('.start_station_select').select2 'data', {id:1,name:'Grand Central Terminal'}
	
	$('.start_station_select').change () ->
		id = $(this).val()
		$('.start_station').html id
		$.getScript '/stop_times?starting_id=' + $(this).val() + '&destination_id=' + $('.destination_station').text()
		if $('.destination_station').text().length && ($('.destination_station').text() != $('.start_station').text())
			startIndicator()	
	
	$('.destination_station_select').change () ->
		id = $(this).val()
		$('.destination_station').html id
		$.getScript '/stop_times?starting_id=' + $('.start_station').text() + '&destination_id=' + $(this).val()
		if $('.start_station').text().length && ($('.destination_station').text() != $('.start_station').text())
			startIndicator()
	
	startIndicator = ->
		$('.schedule').html '<div class="activity-indicator"><span>Thinking...</span></div>'
		$('.activity-indicator').activity
			segments: 8
			width: 4
			space: 4
			length: 8
			speed: 1.1