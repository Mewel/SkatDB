
<%@ page import="skatdb.Game" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'game.label', default: 'Game')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-game" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="statistics" action="statistics"><g:message code="default.statistics.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-game" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list game">
			
				<g:if test="${gameInstance?.group}">
				<li class="fieldcontain">
					<span id="group-label" class="property-label"><g:message code="game.group.label" default="Group" /></span>
						<span class="property-value" aria-labelledby="group-label"><g:link controller="skatGroup" action="show" id="${gameInstance?.group?.id}">${gameInstance?.group?.encodeAsHTML()}</g:link></span>
				</li>
				</g:if>
			
				<g:if test="${gameInstance?.player}">
				<li class="fieldcontain">
					<span id="player-label" class="property-label"><g:message code="game.player.label" default="Player" /></span>
					
						<span class="property-value" aria-labelledby="player-label"><g:link controller="player" action="show" id="${gameInstance?.player?.id}">${gameInstance?.player?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${gameInstance?.bid}">
				<li class="fieldcontain">
					<span id="bid-label" class="property-label"><g:message code="game.bid.label" default="Bid" /></span>
					
						<span class="property-value" aria-labelledby="bid-label"><g:fieldValue bean="${gameInstance}" field="bid"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${gameInstance?.jacks}">
				<li class="fieldcontain">
					<span id="jacks-label" class="property-label"><g:message code="game.jacks.label" default="Jacks" /></span>
					
						<span class="property-value" aria-labelledby="jacks-label"><g:fieldValue bean="${gameInstance}" field="jacks"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${gameInstance?.gameType}">
				<li class="fieldcontain">
					<span id="gameType-label" class="property-label">
						<g:message code="game.gameType.label" default="Game Type" />
					</span>
					<span class="property-value" aria-labelledby="gameType-label">
						<g:if test="${gameInstance?.bid == 0}">
							<g:message code="gameType.0"/>
						</g:if>
						<g:else>
							<g:message code="gameType.${gameInstance.gameType}"/>
						</g:else>
					</span>
				</li>
				</g:if>

				<g:if test="${gameInstance?.hand == true || gameInstance?.hand == false}">
				<li class="fieldcontain">
					<span id="hand-label" class="property-label">
						<g:message code="game.hand.label" default="Hand" />
					</span>
					<span class="property-value" aria-labelledby="hand-label">
						<g:formatBoolean boolean="${gameInstance?.hand}" />
					</span>
				</li>
				</g:if>

				<li class="fieldcontain">
					<span id="gameLevel-label" class="property-label">
						<g:message code="game.gameLevel.label" default="Game Level" />
					</span>
					<span class="property-value" aria-labelledby="gameLevel-label">
						<g:if test="${gameInstance?.bid == 0}">
							<g:message code="gameLevel.ramsch.${gameInstance.gameLevel}"/>
						</g:if>
						<g:else>
							<g:if test="${gameInstance?.hand == true}">
								<g:message code="gameLevel.hand.${gameInstance.gameLevel}"/>
							</g:if>
							<g:else>
								<g:message code="gameLevel.${gameInstance.gameLevel}"/>
							</g:else>
						</g:else>
					</span>
				</li>

				<g:if test="${gameInstance?.announcement}">
				<li class="fieldcontain">
					<span id="announcement-label" class="property-label">
						<g:message code="game.announcement.label" default="Announcement" />
					</span>
					<span class="property-value" aria-labelledby="announcement-label">
						<g:message code="announcement.${gameInstance.announcement}"/>
					</span>
				</li>
				</g:if>
				
				<g:if test="${gameInstance?.createDate}">
				<li class="fieldcontain">
					<span id="createDate-label" class="property-label">
						<g:message code="game.createDate.label" default="create Date" />
					</span>
					<span class="property-value" aria-labelledby="createDate-label">
						<g:formatDate date="${gameInstance.createDate}" format="dd.MM.yyyy"  />
					</span>
				</li>
				</g:if>

				<g:if test="${gameInstance?.won == true || gameInstance?.won == false}">
				<li class="fieldcontain">
					<span id="won-label" class="property-label">
						<g:message code="game.won.label" default="Won" />
					</span>
					<span class="property-value" aria-labelledby="won-label">
						<g:formatBoolean boolean="${gameInstance?.won}" />
					</span>
				</li>
				</g:if>

				<li class="fieldcontain">
					<span id="value-label" class="property-label">
						<g:message code="game.value.label" default="Value" />
					</span>
					<span id="gameValue" class="property-value" aria-labelledby="won-label">
						<g:fieldValue bean="${gameInstance}" field="value"/>
					</span>
				</li>
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${gameInstance?.id}" />
					<g:link class="edit" action="edit" id="${gameInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>

<g:javascript>
  $(document).ready(function() {
    var gameValue = parseInt($('#gameValue').html());
    if(gameValue > 0) {
	  $("#gameValue").addClass("won").removeClass("lost");
	} else {
	  $("#gameValue").addClass("lost").removeClass("won");
	}
  });
</g:javascript>
