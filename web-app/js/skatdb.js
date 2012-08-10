function calcGameValue(bid, jacks, gameType, gameLevel, announcement, won) {
	var value = 0;
	if(bid == 0) {
		// ramsch we use the jacks as value
		return jacks * gameLevel;
	}
	if(isNullGame(gameType)) {
		value = gameType;
	} else {
		value = gameType * (jacks + gameLevel);
	}
	value *= announcement;
	if(!won) {
		value = value * -2;
	}
	return value;
}

function isNullGame(gameType) {
	return gameType == 23 || gameType == 35 || gameType == 46 || gameType == 59;
}