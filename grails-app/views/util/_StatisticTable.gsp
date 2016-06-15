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
		<g:set var="gamesLost" value="${it.games != 0 ? it.games-it.gamesWon : 0}"></g:set>
		<g:set var="gamesWinPercent" value="${gamesLost != 0 ? (it.gamesWon/(it.games) * 100) : 100}"></g:set>
		<td><b>Spiele</b></td>
		<td>${it.games}</td>
		<td>100%</td>
		<td>${it.gamesWon}</td>
		<td>${gamesLost}</td>
		<td><g:formatNumber number="${gamesWinPercent}" format="0.00" />%</td>
	</tr>
	<tr>
		<g:set var="suitGamesLost" value="${it.suitGames != 0 ? it.suitGames-it.suitGamesWon : 0}"></g:set>
		<g:set var="suitGamesPercent" value="${it.suitGames != 0 ? (it.suitGames/it.games * 100) : 0}"></g:set>
		<g:set var="suitGamesWinPercent" value="${it.suitGames != 0 ? (it.suitGamesWon/it.suitGames * 100) : 0}"></g:set>
		<td><b>Farbspiele</b></td>
		<td>${it.suitGames}</td>
		<td><g:formatNumber number="${suitGamesPercent}" format="0.00" />%</td>
		<td>${it.suitGamesWon}</td>
		<td>${suitGamesLost}</td>
		<td><g:formatNumber number="${suitGamesWinPercent}" format="0.00" />%</td>
	</tr>
	<tr>
		<g:set var="grandsLost" value="${it.grands != 0 ? it.grands-it.grandsWon : 0}"></g:set>
		<g:set var="grandsPercent" value="${it.grands != 0 ? (it.grands/it.games * 100) : 0}"></g:set>
		<g:set var="grandsWinPercent" value="${it.grands != 0 ? (it.grandsWon/it.grands * 100) : 0}"></g:set>
		<td><b>Grands</b></td>
		<td>${it.grands}</td>
		<td><g:formatNumber number="${grandsPercent}" format="0.00" />%</td>
		<td>${it.grandsWon}</td>
		<td>${grandsLost}</td>
		<td><g:formatNumber number="${grandsWinPercent}" format="0.00" />%</td>
	</tr>
	<tr>
		<g:set var="nullGamesLost" value="${it.nullGames != 0 ? it.nullGames-it.nullGamesWon : 0}"></g:set>
		<g:set var="nullGamesPercent" value="${it.nullGames != 0 ? (it.nullGames/it.games * 100) : 0}"></g:set>
		<g:set var="nullGamesWinPercent" value="${it.nullGames != 0 ? (it.nullGamesWon/it.nullGames * 100) : 0}"></g:set>
		<td><b>Nullspiele</b></td>
		<td>${it.nullGames}</td>
		<td><g:formatNumber number="${nullGamesPercent}" format="0.00" />%</td>
		<td>${it.nullGamesWon}</td>
		<td>${nullGamesLost}</td>
		<td><g:formatNumber number="${nullGamesWinPercent}" format="0.00" />%</td>
	</tr>
	<tr>
		<g:set var="ramschGamesLost" value="${it.ramschGames != 0 ? it.ramschGames-it.ramschGamesWon : 0}"></g:set>
		<g:set var="ramschGamesPercent" value="${it.ramschGames != 0 ? (it.ramschGames/it.games * 100) : 0}"></g:set>
		<g:set var="ramschGamesWinPercent" value="${it.ramschGames != 0 ? (it.ramschGamesWon/it.ramschGames * 100) : 0}"></g:set>
		<td><b>Ramsch</b></td>
		<td>${it.ramschGames}</td>
		<td><g:formatNumber number="${ramschGamesPercent}" format="0.00" />%</td>
		<td>${it.ramschGamesWon}</td>
		<td>${ramschGamesLost}</td>
		<td><g:formatNumber number="${ramschGamesWinPercent}" format="0.00" />%</td>
	</tr>
</table>