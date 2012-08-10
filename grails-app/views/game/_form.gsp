<%@ page import="skatdb.Game" %>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'group', 'error')} required">
	<label for="group">
		<g:message code="game.group.label" default="Group" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="group" name="group.id" from="${skatdb.SkatGroup.list()}" optionKey="id" required="" value="${gameInstance?.group?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'player', 'error')} required">
	<label for="player">
		<g:message code="game.player.label" default="Player" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="player" name="player.id" from="${skatdb.Player.list()}" optionKey="id" required="" value="${gameInstance?.player?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'bid', 'error')}">
	<label for="bid">
		<g:message code="game.bid.label" default="Bid" />
		<span class="required-indicator">*</span>
	</label>
	<%--<g:field type="number" name="bid" required="" value="${gameInstance.bid}"/> --%>
	<g:select valueMessagePrefix="bid" name="bid" from="${skatdb.Game.constraints.bid.inList}" value="${gameInstance?.bid}" />
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'gameType', 'error')}">
	<label for="gameType">
		<g:message code="game.gameType.label" default="Game Type" />
		<span class="required-indicator">*</span>
	</label>
	<g:select valueMessagePrefix="gameType" name="gameType" from="${skatdb.Game.constraints.gameType.inList}" value="${gameInstance?.gameType}" />
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'jacks', 'error')}">
	<label for="jacks">
		<g:message code="game.jacks.label" default="Jacks" />
	</label>
	<g:field type="number" name="jacks" required="" value="${gameInstance?.bid == 0 ? -gameInstance.value : gameInstance.jacks}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'hand', 'error')}">
	<label for="hand">
		<g:message code="game.hand.label" default="Hand" />
	</label>
	<g:checkBox name="hand" value="${gameInstance?.hand}" />
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'gameLevel', 'error')}">
	<label for="gameLevel">
		<g:message code="game.gameLevel.label" default="Game Level" />
	</label>
	<g:select name="gameLevel" from="${skatdb.Game.constraints.gameLevel.inList}" />
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'announcement', 'error')} required">
	<label for="announcement">
		<g:message code="game.announcement.label" default="Announcement" />
		<span class="required-indicator">*</span>
	</label>
	 <g:select valueMessagePrefix="announcement" name="announcement" from="${skatdb.Game.constraints.announcement.inList}" value="${gameInstance?.announcement}"  />
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'announcement', 'error')}">
	<label for="announcement">
		<g:message code="game.createDate.label" default="create date" />
	</label>
	<g:datePicker name="createDate" value="${gameInstance?.createDate}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: gameInstance, field: 'won', 'error')} ">
	<label for="won">
		<g:message code="game.won.label" default="Won" />
	</label>
	<g:checkBox name="won" value="${gameInstance?.won}" />
</div>

<div class="points">
	<span id="gameValue"></span>
	<g:message code="game.gamevalue.label" default="Points"/>
</div>

<g:javascript>

  var ramsch = ${gameInstance?.bid} == 0;
  var gameLevel;
  var gameLevelOptions = [];
  var gameLevelHandOptions = [];
  var gameLevelRamschOptions = [];

  $(document).ready(function() {
	initGSP();
  	updateEditable(ramsch);
  	updateGameLevel(ramsch);
  	$('#gameLevel option[value=${gameInstance?.gameLevel}]').attr("selected", "selected");
  	updatePoints();

    $('#jacks,#gameLevel,#announcement,#won').change(function() {
      updatePoints();
    });
    $('#gameType').change(function() {
      updateEditable(ramsch);
      updatePoints();
    });
    $('#bid').change(function() {
      var bid = parseInt($('#bid').val());
      if(bid == 0) {
      	setRamsch(true);
      } else if(ramsch) {
      	setRamsch(false);
      }
      updatePoints();
    });
    $('#hand').change(function() {
      updateGameLevel(ramsch);
      updatePoints();
    });
  });

  function initGSP() {
    gameLevel = ${gameInstance?.gameLevel};
    <g:set var="i" value="${1}"/>
    <g:while test="${i <= 3}">
      gameLevelOptions.push({value: ${i}, i18n: "<g:message code="gameLevel.$i" />"});
      <%i++ %>
    </g:while>

    <g:set var="i" value="${2}"/>
    <g:while test="${i <= 7}">
      gameLevelHandOptions.push({value: ${i}, i18n: "<g:message code="gameLevel.hand.$i" />"});
      <%i++ %>
    </g:while>

    gameLevelRamschOptions.push({value: -1, i18n: "<g:message code="gameLevel.ramsch.-1" />"});
    gameLevelRamschOptions.push({value: -2, i18n: "<g:message code="gameLevel.ramsch.-2" />"});
    gameLevelRamschOptions.push({value: 2, i18n: "<g:message code="gameLevel.ramsch.2" />"});
  }

  function updatePoints() {
  	var bid = parseInt($('#bid').val());
    var jacks = parseInt($('#jacks').val());
   	var gameType = parseInt($('#gameType').val());
   	var hand = $('#hand:checked').val() == "on";
   	var gameLevel = parseInt($('#gameLevel').val());
   	var announcement = parseInt($('#announcement').val());
   	var won = $('#won:checked').val() == "on";

	var gameValue = calcGameValue(bid, jacks, gameType, gameLevel, announcement, won);
	$("#gameValue").html(gameValue);
	if(gameValue > 0) {
		$("#gameValue").addClass("won").removeClass("lost");
	} else {
		$("#gameValue").addClass("lost").removeClass("won");
	}
  }

  function setRamsch(/*boolean*/ r) {
  	updateEditable(r);
  	updateGameLevel(r);
  	ramsch = r;
  }

  function updateEditable(ramsch) {
    if(ramsch) {
      $('#gameType').attr("disabled", "disabled");
      $('#hand').attr("disabled", "disabled");
      $('#announcement').attr("disabled", "disabled");
      $('#won').attr("disabled", "disabled");
    } else {
      $('#gameType').removeAttr("disabled");
      $('#hand').removeAttr("disabled");
      $('#announcement').removeAttr("disabled");
      $('#won').removeAttr("disabled");
      var gameType = parseInt($('#gameType').val());
      if(isNullGame(gameType)) {
 	    $('#jacks').attr("disabled", "disabled");
        $('#hand').attr("disabled", "disabled");
        $('#gameLevel').attr("disabled", "disabled");
 	  } else {
        $('#jacks').removeAttr("disabled");
 	    $('#hand').removeAttr("disabled");
        $('#gameLevel').removeAttr("disabled");
 	  }
 	}
  }

  function updateGameLevel(ramsch) {
    var hand = $('#hand:checked').val() == "on";
    var gameLevelSelect = $('#gameLevel');
    gameLevelSelect.empty();
    var addOptions = ramsch ? gameLevelRamschOptions : hand ? gameLevelHandOptions : gameLevelOptions;
    for(var i = 0; i < addOptions.length; i++) {
    	var option = addOptions[i];
    	gameLevelSelect.append('<option value="' + option.value +'">' + option.i18n + '</option>');
    }
  }

</g:javascript>