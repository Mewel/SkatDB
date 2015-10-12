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
				<li><g:link class="export" controller="JSON" action="games">Export Games</g:link></li>
				<li><g:link class="export" controller="JSON" action="tournaments">Export Tournaments</g:link></li>
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
				    <p>You can add games or tournaments here. The supported input format is <b>JSON</b>.
				    You can drop it directly into the text area, or you can specify an URL where the
				    importer can find the data.</p>
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