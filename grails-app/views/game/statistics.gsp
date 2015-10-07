
<%@page import="skatdb.SkatGroup"%>
<%@ page import="skatdb.Game" %>
<!doctype html>

	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'game.label', default: 'Game')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
		<g:javascript src="highcharts/highcharts.js" />
		<g:javascript src="highcharts/modules/exporting.js" />
        <g:javascript src="pickadate.js-3.5.6/picker.js"/>
        <g:javascript src="pickadate.js-3.5.6/picker.date.js"/>
        <g:javascript src="pickadate.js-3.5.6/legacy.js"/>

	</head>

<body>
		<a href="#list-game" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="statistics-game" class="content scaffold-statistics" role="main">
			<h1><g:message code="default.statistics.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

            <g:form action="statistics" class="filter">
				<fieldset>
						<label for="filterByGroup"> Gruppe:</label>
						<g:select id="filterByGroup" name="filterGroup" from="${SkatGroup.all}"
									  noSelection="['': 'Kein Filter']" value="${filterGroup}" optionKey="id"/>
				</fieldset>

				<fieldset>
					   <label for="from">Zeitraum von:</label>
                        <input type="text" name="filterFrom"  id="from" class="datepicker" value="${filterPeriodFrom}" >
				</fieldset>

				<fieldset>
					   <label for="to">bis:</label>
                       <input type="text" name="filterTo"  id="to" class="datepicker" value="${filterPeriodTo}" >
				</fieldset>
			</g:form>
            <g:if test="${!showChart}">
                <div style="text-align: center">
                    <h1 style="color: red">Keine Spiele im angegebenen Zeitraum gefunden</h1>
                </div>
            </g:if>
            <g:if test="${showChart}">
	            <g:render template="/util/PlayerTable" bean="${gameStatisticsList}" />
				<div id="gameChart" style="min-width: 400px; height: 450px; margin: 0 auto">
				</div>
				<div id="dateChart" style="min-width: 400px; height: 450px; margin: 0 auto">
				</div>
            </g:if>
		</div>
	</body>
</html>
<g:if test="${showChart}">
<g:javascript>
$(function () {
	$(document).ready(function() {
		loadCharts();
		$('#filterByGroup,#filterByPeriod').change(function() {
			$('form:first').submit();
		});
	});

	function loadCharts() {
		var gameChart = getDefaultChart();
		gameChart.chart.renderTo = 'gameChart';
		gameChart.title.text = 'Spiele';
		gameChart.xAxis.title.text = 'Spiele';
		gameChart.plotOptions.series.point.events.click = function(evt) {
			if(evt.point.game) {
				var url = g.createLink({controller: 'game'});
				window.location.href = url + "/show/" + evt.point.game.id;
			}
		}
		<g:each in="${gameChart}" status="i" var="series">
		gameChart.series.push({
			name: '${series.player.name}',
			data: ${series.data.encodeAsJSON()}
		});
		</g:each>
		new Highcharts.Chart(gameChart);

		var dateChart = getDefaultChart();
		dateChart.chart.renderTo = 'dateChart';
		dateChart.title.text = 'Zeitraum';
		dateChart.xAxis.title.text = 'Spiele';
		dateChart.xAxis.type = 'datetime';
		dateChart.tooltip.formatter = function() {
			var date = new Date(this.x);
			var dateString = date.getDate() + "." + (date.getMonth() + 1) + "." + date.getFullYear();
			return '<b>'+ this.series.name + ' ' + dateString + '</b><br/>'+ this.y + ' Punkte';
		}
		<g:each in="${dateChart}" status="i" var="series">
		dateChart.series.push({
			name: '${series.player.name}',
			data: ${series.data},
			pointStart: ${series.pointStart},
            pointInterval: ${series.pointInterval}
		});
		</g:each>
		new Highcharts.Chart(dateChart);
	}

	function getDefaultChart() {
		return {
	        chart: {
	            type: 'spline',
	            marginRight: 130,
	            marginBottom: 25
	        },
	        title: {
	            x: -20 //center
	        },
	        xAxis: {
	        	title: {
	        		margin: -2
	        	}
	        },
	        yAxis: {
	            title: {
	            	text: 'Punkte'
	            },
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }]
	        },
	        plotOptions: {
	        	series: {
	        		point: {
	        			events: {
	        			}
	        		}
	        	}
	        },
	        tooltip: {
	        	formatter: function() {
					return '<b>'+ this.series.name +'</b><br/>'+ this.y + ' Punkte';
				}
	        },
	        legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'top',
	            x: -10,
	            y: 100,
	            borderWidth: 0
	        },
	        series: []
	    }
	}
});


</g:javascript>
</g:if>
<g:javascript>
	window.onload = function () {
		var options = {format: 'yyyy-mm-dd',
			onClose: function () {
				jQuery("form.filter").submit();
            }};
		jQuery("[name=filterFrom]").pickadate(options)
		jQuery("[name=filterTo]").pickadate(options)

	};
</g:javascript>