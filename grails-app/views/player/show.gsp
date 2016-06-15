
<%@page import="skatdb.Tournament"%>
<%@ page import="skatdb.Player" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'player.label', default: 'Player')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<style>
			body {
				margin: auto;
			}
			div.contentdiv {
				margin: 0 3em;
			}
			.nav > ul {
				margin-bottom: 0;
			}
			div.nav {
				padding-left: 0.75em;
			}
			td, th {
				padding: 0.2em 0.4em;
			}
		</style>
	</head>
	<body>
		<a href="#show-player" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-player" class="content scaffold-show" role="main">
			<h1>${playerInstance?.name}</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<div class="contentdiv">
				<h2>Spiele</h2>
				<g:render template="/util/StatisticTable" bean="${gameStatistics}" /> 
				<h2>Sonstiges</h2>
				<div>längste Siegesserie: ${wonSeries}</div>
				<div>längste Verlustserie: ${lostSeries}</div>
				<g:if test="${bestGame != null}">
					<div>bestes Spiel: <g:link controller="game" action="show" id="${bestGame.id}">${bestGame.value} Punkte</g:link></div>
				</g:if>
				<g:if test="${worstGame != null}">
					<div>schlechtestes Spiel: <g:link controller="game" action="show" id="${worstGame.id}">${worstGame.value} Punkte</g:link></div>
				</g:if>
				<h2>Turniere</h2>
				<g:if test="${tournamentsPlayed <= 0}">
					<p>Noch keine Turniere gespielt</p>
				</g:if>
				<g:if test="${tournamentsPlayed > 0}">
					<div>Turniere gespielt: ${tournamentsPlayed}</div>
					<div>
					<g:each in="${firstPlaces}">
						<g:set var="t" value="${Tournament.findById(it)}" />
						<g:link controller="tournament" action="show" id="${t.id}">
							<g:img file="first.png" title="${t.name}" />
						</g:link>
					</g:each>
					<g:each in="${secondPlaces}">
						<g:set var="t" value="${Tournament.findById(it)}" />
						<g:link controller="tournament" action="show" id="${t.id}">
							<g:img file="second.png" title="${t.name}" />
						</g:link>
					</g:each>
					<g:each in="${thirdPlaces}">
						<g:set var="t" value="${Tournament.findById(it)}" />
						<g:link controller="tournament" action="show" id="${t.id}">
							<g:img file="third.png" title="${t.name}" />
						</g:link>
					</g:each>
					</div>
				</g:if>
			</div>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${playerInstance?.id}" />
					<g:link class="edit" action="edit" id="${playerInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
