
<%@ page import="skatdb.Game" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'game.label', default: 'Game')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-game" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="statistics" action="statistics"><g:message code="default.statistics.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-game" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
						<g:sortableColumn property="createDate" title="${message(code: 'game.createDate.label', default: 'Date')}" />

						<th><g:message code="game.group.label" default="Group" /></th>
					
						<th><g:message code="game.player.label" default="Player" /></th>
					
						<g:sortableColumn property="bid" title="${message(code: 'game.bid.label', default: 'Bid')}" />
					
						<g:sortableColumn property="jacks" title="${message(code: 'game.jacks.label', default: 'Jacks')}" />
					
						<g:sortableColumn property="gameType" title="${message(code: 'game.gameType.label', default: 'Game Type')}" />
					
						<g:sortableColumn property="gameLevel" title="${message(code: 'game.gameLevel.label', default: 'Game Level')}" />
						
						<g:sortableColumn property="announcement" title="${message(code: 'game.announcement.label', default: 'Announcement')}" />
						
						<g:sortableColumn property="value" title="${message(code: 'game.value.list.label', default: 'Game Value')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${gameInstanceList}" status="i" var="gameInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'} ${gameInstance?.won ? 'won' : 'lost'}">
					
						<td><g:link action="show" id="${gameInstance.id}"><g:formatDate format="dd.MM.yyyy" date="${gameInstance?.createDate}"/></g:link></td>

						<td>${fieldValue(bean: gameInstance, field: "group")}</td>

						<td>${fieldValue(bean: gameInstance, field: "player")}</td>

						<td>${!(gameInstance?.bid == 0) ? fieldValue(bean: gameInstance, field: "bid") : ''}</td>

						<td>${!(gameInstance?.bid == 0 || gameInstance?.isNullGame()) ? fieldValue(bean: gameInstance, field: "jacks") : ''}</td>

						<td>
							<g:if test="${gameInstance?.bid == 0}">
							<g:message code="gameType.0"/>
							</g:if>
							<g:else>
								<g:message code="gameType.${gameInstance.gameType}"/>
							</g:else>
						</td>
						<td>
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
						</td>

						<td><g:message code="announcement.${gameInstance.announcement}"/></td>

						<td>${fieldValue(bean: gameInstance, field: "value")}</td>
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${gameInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
