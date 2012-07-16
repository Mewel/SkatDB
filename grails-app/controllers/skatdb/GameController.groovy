package skatdb

class GameController {

	def beforeInterceptor = [action:this.&auth]
	
	def scaffold=true

    def index() {
		redirect(action: "list")
	}

	def auth() {
		if(!session.loggedIn) {
			redirect(controller:"Auth", action:"login")
			return false
		}
	}

	def list() {
		if(!params.sort) {
			params.sort = "createDate"
		}
		if(!params.order) {
			params.order = "desc"
		}
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[gameInstanceList: Game.list(params), gameInstanceTotal: Game.count()]
	}

	def statistics() {
		// filter
		SkatGroup group = null
		if(params.filterGroup != null) {
			group = SkatGroup.findById(params.filterGroup)
		}
		Date filterPeriod = getPeriodDate(params.filterPeriod)
		// get data
		def playerList = Player.all
		def playerInfoList = getPlayerInfo(playerList, group, filterPeriod)
		def gameChart = getGameChart(playerList, group, filterPeriod)
		def dateChart = getDateChart(playerList, group, filterPeriod)
		[
			gameStatisticsList: playerInfoList,
			gameChart: gameChart,
			dateChart: dateChart,
			filterGroup: group == null ? "" : group.id,
			filterPeriod: params.filterPeriod
		]
	}

	private Date getPeriodDate(String filterPeriod) {
		Calendar cal = Calendar.getInstance()
		cal.setTime(new Date())
		int week = cal.get(Calendar.WEEK_OF_YEAR)
		int month = cal.get(Calendar.MONTH)
		int year = cal.get(Calendar.YEAR)
		cal.clear()
		cal.set(Calendar.YEAR, year)
		if("week".equals(filterPeriod)) {
			cal.set(Calendar.WEEK_OF_YEAR, week)
			return cal.getTime()
		} else if("month".equals(filterPeriod)) {
			cal.set(Calendar.MONTH, month)
			return cal.getTime()
		} else if("year".equals(filterPeriod)) {
			return cal.getTime()
		}
		return null
	}

	private ArrayList getPlayerInfo(List<Player> playerList, SkatGroup group, Date filterDate) {
		def playerInfoList = [];
		for(Player p : playerList) {
			def games = null
			int won = 0
			if(filterDate == null) {
				games = group == null ? Game.findAllByPlayer(p) : Game.findAllByPlayerAndGroup(p, group);
				won = group == null ? Game.countByPlayerAndWon(p, true) : Game.countByPlayerAndGroupAndWon(p, group, true)
			} else {
				games = group == null ? Game.findAllByPlayerAndCreateDateGreaterThanEquals(p, filterDate) : Game.findAllByPlayerAndGroupAndCreateDateGreaterThanEquals(p, group, filterDate)
				won = group == null ? Game.countByPlayerAndWonAndCreateDateGreaterThanEquals(p, true, filterDate) : Game.countByPlayerAndGroupAndWonAndCreateDateGreaterThanEquals(p, group, true, filterDate)
			}
			if(games.size() > 0) {
				playerInfoList.push([
					player: p,
					count: games.size(),
					won: won,
					points: games.sum { it.value }
				])
			}
		}
		return playerInfoList
	}

	private ArrayList getGameChart(playerList, SkatGroup group, Date filterDate) {
		def chart = []
		for(Player p : playerList) {
			def series = [
				player: p,
				data: [[
					y: 0
				]],
			]
			def games = null
			if(filterDate == null) {
				games = group == null ? Game.findAllByPlayer(p) : Game.findAllByPlayerAndGroup(p, group)
			} else {
			games = group == null ? Game.findAllByPlayerAndCreateDateGreaterThanEquals(p, filterDate) : Game.findAllByPlayerAndGroupAndCreateDateGreaterThanEquals(p, group, filterDate)
			}
			def value = 0
			if(games.size() > 0) {
				for(Game g : games) {
					value += g.value
					series.data.push([
						y: value,
						game: g
					]);
				}
				chart.push(series)
			}
		}
		return chart
	}

	private ArrayList getDateChart(playerList, SkatGroup group, Date filterDate) {
		def chart = []
		int dayRange = 1
		Game firstGame = getFirstGame(group, filterDate)
		if(firstGame == null) {
			return chart
		}
		Game lastGame = getLastGame(group)
		Date date = maxDate(firstGame.createDate, filterDate)
		Date lastDate = minDate(lastGame.createDate, new Date())
		while(date < lastDate) {
			for(Object series : chart) {
				series.data.push(series.data[series.data.size() - 1]);
			}
			List<Game> games = null;
			if(group == null) {
				games = Game.findAll("from Game as g where g.createDate >= ? and g.createDate < ?", [date, date.plus(dayRange)])
			} else {
				games = Game.findAll("from Game as g where g.createDate >= ? and g.createDate < ? and g.group = ?", [date, date.plus(dayRange), group])
			}
			for(Game g : games) {
				def series = getSeries(g.player, chart)
				if(series == null) {
					series = createSeries(g.player, date, dayRange)
					chart.push(series)
				}
				series.data[series.data.size() - 1] += g.value
			}
			date = date.plus(dayRange);
		}
		return chart
	}

	private Game getFirstGame(SkatGroup group, Date filterDate) {
		if(filterDate != null && group != null) {
			return Game.find("from Game as g where g.group = ? and g.createDate >= ? ORDER BY createDate", [group, filterDate])
		} else if(group != null) {
			return Game.find("from Game as g where g.group = ? ORDER BY createDate", [group])
		} else if(filterDate != null) {
			return Game.find("from Game as g where g.createDate >= ? ORDER BY createDate", [filterDate])
		} else {
			return Game.find("from Game ORDER BY createDate")
		}
	}

	private Game getLastGame(SkatGroup group) {
		if(group != null) {
			return Game.find("from Game as g where g.group = ? ORDER BY createDate desc", [group])
		} else {
			return Game.find("from Game ORDER BY createDate desc")
		}
	}

	private Object createSeries(Player p, Date startDate, int dayRange) {
		long day = 24 * 3600 * 1000
		return [
			player: p,
			data: [0, 0],
			pointStart: startDate.time - (day * dayRange),
			pointInterval: day * dayRange
		]
	}

	private Object getSeries(Player p, ArrayList chart) {
		for(Object series : chart) {
			if(series.player.equals(p)) {
				return series
			}
		}
		return null
	}

	private Date maxDate(Date d1, Date d2) {
		if(d1 == null && d2 == null) {
			return null
		}
		if(d1 == null) {
			return d2
		}
		if(d2 == null) {
			return d1
		}
		return new Date(Math.max(d1.time, d2.time))
	}
	
	private Date minDate(Date d1, Date d2) {
		if(d1 == null && d2 == null) {
			return null
		}
		if(d1 == null) {
			return d2
		}
		if(d2 == null) {
			return d1
		}
		return new Date(Math.min(d1.time, d2.time))
	}
}
