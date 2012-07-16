function calcGameValue(withOrWithout, gameType, gameLevel, announcement, won) {
	var value = 0;
	if(isNullGame(gameType)) {
		value = gameType;
	} else {
		value = gameType * (withOrWithout + gameLevel);
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