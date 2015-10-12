
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
				<table>
					<tr>
						<th></th>
						<th>Anzahl</th>
						<th>Anteilig %</th>
						<th>Gewonnen</th>
						<th>Verloren</th>
						<th>Gewonnen %</th>
					</tr>
					<tr>
						<g:set var="gamesLost" value="${games != 0 ? games-gamesWon : 0}"></g:set>
						<g:set var="gamesWinPercent" value="${gamesLost != 0 ? (gamesWon/(games) * 100) : 100}"></g:set>
						<td><b>Spiele</b></td>
						<td>${games}</td>
						<td>100%</td>
						<td>${gamesWon}</td>
						<td>${gamesLost}</td>
						<td><g:formatNumber number="${gamesWinPercent}" format="0.00" />%</td>
					</tr>
					<tr>
						<g:set var="suitGamesLost" value="${suitGames != 0 ? suitGames-suitGamesWon : 0}"></g:set>
						<g:set var="suitGamesPercent" value="${suitGames != 0 ? (suitGames/games * 100) : 0}"></g:set>
						<g:set var="suitGamesWinPercent" value="${suitGames != 0 ? (suitGamesWon/suitGames * 100) : 0}"></g:set>
						<td><b>Farbspiele</b></td>
						<td>${suitGames}</td>
						<td><g:formatNumber number="${suitGamesPercent}" format="0.00" />%</td>
						<td>${suitGamesWon}</td>
						<td>${suitGamesLost}</td>
						<td><g:formatNumber number="${suitGamesWinPercent}" format="0.00" />%</td>
					</tr>
					<tr>
						<g:set var="grandsLost" value="${grands != 0 ? grands-grandsWon : 0}"></g:set>
						<g:set var="grandsPercent" value="${grands != 0 ? (grands/games * 100) : 0}"></g:set>
						<g:set var="grandsWinPercent" value="${grands != 0 ? (grandsWon/grands * 100) : 0}"></g:set>
						<td><b>Grands</b></td>
						<td>${grands}</td>
						<td><g:formatNumber number="${grandsPercent}" format="0.00" />%</td>
						<td>${grandsWon}</td>
						<td>${grandsLost}</td>
						<td><g:formatNumber number="${grandsWinPercent}" format="0.00" />%</td>
					</tr>
					<tr>
						<g:set var="nullGamesLost" value="${nullGames != 0 ? nullGames-nullGamesWon : 0}"></g:set>
						<g:set var="nullGamesPercent" value="${nullGames != 0 ? (nullGames/games * 100) : 0}"></g:set>
						<g:set var="nullGamesWinPercent" value="${nullGames != 0 ? (nullGamesWon/nullGames * 100) : 0}"></g:set>
						<td><b>Nullspiele</b></td>
						<td>${nullGames}</td>
						<td><g:formatNumber number="${nullGamesPercent}" format="0.00" />%</td>
						<td>${nullGamesWon}</td>
						<td>${nullGamesLost}</td>
						<td><g:formatNumber number="${nullGamesWinPercent}" format="0.00" />%</td>
					</tr>
				</table>
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
