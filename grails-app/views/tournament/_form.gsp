<%@ page import="skatdb.Tournament" %>



<div class="fieldcontain ${hasErrors(bean: tournamentInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="tournament.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${tournamentInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tournamentInstance, field: 'games', 'error')} ">
	<label for="games">
		<g:message code="tournament.games.label" default="Games" />
	</label>
<ul class="one-to-many">
<g:each in="${tournamentInstance?.games?}" var="g">
    <li><g:link controller="game" action="show" id="${g.id}">${g?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>

</div>

<div class="fieldcontain ${hasErrors(bean: tournamentInstance, field: 'gamesPerRound', 'error')} required">
	<label for="gamesPerRound">
		<g:message code="tournament.gamesPerRound.label" default="Games Per Round" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="gamesPerRound" from="${skatdb.Tournament.constraints.gamesPerRound.inList}" value="${tournamentInstance.gamesPerRound}"/> 
</div>

<div class="fieldcontain ${hasErrors(bean: tournamentInstance, field: 'players', 'error')} ">
	<label for="players">
		<g:message code="tournament.players.label" default="Players" />
	</label>
	<g:select name="players" from="${skatdb.Player.list()}" multiple="multiple" optionKey="id" size="5" value="${tournamentInstance?.players*.id}" class="many-to-many"/>
	<g:link controller="player" action="create" params="['tournament.id': tournamentInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'player.label', default: 'Player')])}</g:link>
</div>

<div class="fieldcontain ${hasErrors(bean: tournamentInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="tournament.status.label" default="Status" />
		<span class="required-indicator">*</span>
	</label>
	<g:select valueMessagePrefix="tournament.status" name="status" from="${skatdb.Tournament.constraints.status.inList}" value="${tournamentInstance.status}"/> 
</div>
