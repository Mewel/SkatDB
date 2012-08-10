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
				<li><g:link class="export" controller="JSON" action="games"><g:message code="export.label" /></g:link></li>
			</ul>
		</div>
		<div id="import-game" class="content scaffold-import" role="main">
			<h1><g:message code="default.import.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:if test="${flash.error}">
            	<div class="errors">${flash.error}
				<g:if test="${flash.errorList}" >
					<ul>
					<g:each in="${flash.errorList}" status="i" var="errorEntry">
						<li>${errorEntry}</li>
					</g:each>
					</ul>
				</g:if>
				</div>
			</g:if>

			<g:form action="importGames">
				<fieldset class="form">
					<div class="fieldcontain">
						<label for="group">
							<g:message code="game.group.label" default="Group" />
						</label>
						<g:select id="group" name="group.id" from="${skatdb.SkatGroup.list()}" optionKey="id" required="" value="${gameInstance?.group?.id}" class="many-to-one"/>
					</div>
					<div class="fieldcontain">
						<label for="fakeDate">
							<g:message code="game.import.fakeDate.label" default="Fake date" />
						</label>
						<g:checkBox id="fakeDateBox" name="useFakeDate" checked="false"/>
						<g:datePicker id="fakeDatePicker" name="fakeDate" disabled="disabled" precision="day" />
					</div>
					<div class="fieldcontain required">
						<label for="importArea">
							<g:message code="game.import.label" default="Import" />
							<span class="required-indicator">*</span>
						</label>
						<g:textArea id="import" name="importTextArea" />
					</div>
				</fieldset>
				<fieldset class="buttons">
					<g:submitButton name="import" class="import" value="${message(code: 'default.button.import.label', default: 'Import')}" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>

<g:javascript>
$(function () {
	$(document).ready(function() {
		$('#fakeDateBox').change(function() {
			var checked = $('#fakeDateBox:checked').val() == "on";
			if(checked) {
				$('select[id^="fakeDatePicker_"]').removeAttr("disabled");
			} else {
				$('select[id^="fakeDatePicker_"]').attr("disabled", "disabled");
			}
		});
	});
});
</g:javascript>