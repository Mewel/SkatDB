<%@ page import="skatdb.SkatGroup" %>



<div class="fieldcontain ${hasErrors(bean: skatGroupInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="skatGroup.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${skatGroupInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: skatGroupInstance, field: 'games', 'error')} ">
	<label for="games">
		<g:message code="skatGroup.games.label" default="Games" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${skatGroupInstance?.games?}" var="g">
    <li><g:link controller="game" action="show" id="${g.id}">${g?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="game" action="create" params="['skatGroup.id': skatGroupInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'game.label', default: 'Game')])}</g:link>
</li>
</ul>

</div>

