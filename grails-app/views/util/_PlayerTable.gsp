<table>
	<thead>
		<tr>
			<th><g:message code="game.player.label" default="Spieler" /></th>
			<th><g:message code="game.games.label" default="Anzahl Spiele" /></th>
			<th><g:message code="game.wonlost.label" default="Gewonnen/Verloren" /></th>
			<th><g:message code="game.points.label" default="Punkte" /></th>
		</tr>
	</thead>
	<tbody>
		<g:each in="${it}" status="i" var="row">
			<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
				<td><g:link controller="player" action="show" id="${row.player.id}">${row.player.name}</g:link></td>
				<td>${row.count}</td>
				<g:set var="lost" value="${row.count != 0 ? row.count-row.won : 0}"></g:set>
				<g:set var="ratio" value="${lost != 0 ? row.won/lost : 0}"></g:set>
				<td>${row.won}/${lost} (<g:formatNumber number="${ratio}" format="0.00" />)</td>
				<td>${row.points}</td>
			</tr>
		</g:each>
	</tbody>
</table>