
<%@ page import="skatdb.Tournament" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'tournament.label', default: 'Tournament')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<style>
			body {
				margin: auto;
			}
			div.contentdiv {
				margin: 0 1.5em;
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
		<a href="#show-tournament" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-tournament" class="content scaffold-show" role="main">
			<h1><g:fieldValue bean="${tournamentInstance}" field="name"/> - <g:message code="tournament.status.${tournamentInstance.status}"/></h1>
			<g:if test="${flash.message}">
			  <div class="alert alert-info" role="alert">${flash.message}</div>
			</g:if>
			<g:if test="${flash.error}">
			  <div class="alert alert-danger" role="alert">${flash.error}</div>
			</g:if>
			
			<div class="row contentdiv">
		        <g:if test="${tournamentInstance.status != 2}">
					<div class="col-md-12">
						<h3>Aktionen</h3>
						<g:if test="${tournamentInstance.status == 0}">
							<g:link action="startTournament" id="${tournamentInstance?.id}">
						    	<button type="button" class="btn btn-primary">Turnier starten</button>
						    </g:link>
						</g:if>
						<g:if test="${tournamentInstance.status == 1}">
						    <g:link action="newRound" id="${tournamentInstance?.id}">
							    <button type="button" class="btn btn-primary">Neue Runde starten</button>
							</g:link>
							<g:link action="finishTournament" id="${tournamentInstance?.id}">
								<button type="button" class="btn btn-danger">Turnier beenden</button>
							</g:link>
						</g:if>
						<hr />
					</div>
				</g:if>
				<div class="col-md-12">
					<h3></h3>
					<g:render template="/util/PlayerTable" bean="${results}" />
					<hr />
				</div>
				<div class="col-md-12">
					<h3>Runden</h3>
					<g:if test="${tournamentInstance.rounds.isEmpty()}">
					    <p>Noch keine Runden gespielt</p>
					</g:if>
					<g:each in="${tournamentInstance.rounds}" var="round" status="r">
					    <div class="panel panel-default">
                          <div class="panel-heading">
                            <h3 class="panel-title"><b>Runde ${r + 1}</b></h3>
                          </div>
                          <div class="panel-body">
                            <g:each in="${round.groups}" var="group" status="g">
                              <g:set var="gamesPerRound" value="${skatdb.RenderUtils.gamesPerRound(group)}" />
                              <div class="panel ${group.games.size() == gamesPerRound ? 'panel-success' : 'panel-danger'}">
                                <div class="panel-heading">
                                  <h3 class="panel-title">
                                  	<span>Gruppe ${g + 1} - </span>
                                  	<span>${group.games.size()}/${gamesPerRound} Spiele gespielt</span>
                                   </h3>
                                </div>
                                <div class="panel-body">
                                	<g:render template="/util/PlayerTable" bean="${skatdb.RenderUtils.getPlayerInfo(group)}" />
                                </div>
                              </div>
                            </g:each>
                          </div>
                        </div>
					</g:each>
				</div>
			</div>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${tournamentInstance?.id}" />
					<g:link class="edit" action="edit" id="${tournamentInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
