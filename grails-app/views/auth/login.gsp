
<%@ page import="skatdb.Game" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'auth.label', default: 'Auth')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
			</ul>
		</div>
		<div id="auth" class="content scaffold" role="main">
			<h1><g:message code="default.auth.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:form action="authenticate" >
				<div class="fieldcontain required">
					<label for="password">
						<g:message code="auth.password.label" default="Password" />
					</label>
					<g:passwordField name="password" />
				</div>
				<fieldset class="buttons">
					<g:actionSubmit class="login" action="authenticate" value="${message(code: 'default.button.login.label', default: 'Login')}" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
