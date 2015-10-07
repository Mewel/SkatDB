package skatdb

import java.text.ParseException
import java.text.SimpleDateFormat

class GameController {

    public static final int MILLISECONDS_OF_A_DAY = 24 * 60 * 60 * 1000
    def beforeInterceptor = [action: this.&auth]

    def scaffold = true

    def index() {
        redirect(action: "list")
    }

    def auth() {
        if (!session.loggedIn) {
            redirect(controller: "Auth", action: "login")
            return false
        }
    }

    def list() {
        if (!params.sort) {
            params.sort = "createDate"
        }
        if (!params.order) {
            params.order = "desc"
        }
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [gameInstanceList: Game.list(params), gameInstanceTotal: Game.count()]
    }

    def statistics() {
        // filter
        SkatGroup group = null
        if (params.filterGroup != null) {
            group = SkatGroup.findById(params.filterGroup)
        }

        log.info "From: " + params.filterFrom
        log.info "To: " + params.filterTo

        def filterPeriodFrom = params.filterFrom
        def filterPeriodTo = params.filterTo

        if (filterPeriodTo != null) {
            filterPeriodTo = new Date(filterPeriodTo.getTime() + MILLISECONDS_OF_A_DAY)
            // erhöht filterPeriodTo um einen Tag um die Spiele des ausgewählten Tages anzuzeigen
        }
        Game firstGame = getFirstGame(group,filterPeriodFrom)
        Game lastGame = getLastGame(group, filterPeriodTo)
		if(firstGame == null && lastGame == null) {
			return;
		}
        if (filterPeriodFrom == null) {
            filterPeriodFrom = firstGame.createDate
        }
        if (filterPeriodTo == null) {
            filterPeriodTo = lastGame.createDate
        }

        // get data
        def playerList = Player.all
        def playerInfoList = RenderUtils.getPlayerInfo(playerList, group, filterPeriodFrom, filterPeriodTo, false)
        def gameChart = getGameChart(playerList, group, filterPeriodFrom, filterPeriodTo)
        def dateChart = getDateChart(playerList, group, filterPeriodFrom, filterPeriodTo)
        [
                gameStatisticsList: playerInfoList,
                gameChart         : gameChart,
                dateChart         : dateChart,
                filterGroup       : group == null ? "" : group.id,
                filterPeriod      : params.filterPeriod,
                showChart         : !gameChart.empty,
                filterPeriodFrom  : filterPeriodFrom,
                filterPeriodTo    : new Date(filterPeriodTo.getTime() - MILLISECONDS_OF_A_DAY)
        ]
    }

    private Date stringtodate(String filterPeriod) {
        if (filterPeriod == null) return null;
        try {
            String dateString = filterPeriod
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd")

            Date timeStamp = simpleDateFormat.parse(dateString)

            return timeStamp

        } catch (ParseException e) {
            return null
        }

    }


    private String datetoString(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd")

        String timeStamp = simpleDateFormat.format(date)

        return timeStamp

    }

    private ArrayList getGameChart(playerList, SkatGroup group, Date filterDateFrom, Date filterDateTo) {
        def chart = []
        for (Player p : playerList) {
            def series = [
                    player: p,
                    data  : [[
                                     y: 0
                             ]],
            ]
            def games = null
            if (filterDateFrom == null && filterDateTo == null) {
                games = group == null ? Game.findAllByPlayer(p) : Game.findAllByPlayerAndGroup(p, group)
            } else {
                games = group == null ? Game.findAllByPlayerAndCreateDateBetween(p, filterDateFrom, filterDateTo) : Game.findAllByPlayerAndGroupAndCreateDateBetween(p, group, filterDateFrom, filterDateTo)
            }
            def value = 0
            if (games.size() > 0) {
                for (Game g : games) {
                    value += g.value
                    series.data.push([
                            y   : value,
                            game: g
                    ]);
                }
                chart.push(series)
            }
        }
        return chart
    }

    private ArrayList getDateChart(playerList, SkatGroup group, Date filterDateFrom, Date filterDateTo) {
        def chart = []
		int dayRange = 1
		Game firstGame = getFirstGame(group, filterDateFrom)
		if(firstGame == null) {
			return chart
		}
		Game lastGame = getLastGame(group, filterDateTo)
		Date date = maxDate(firstGame != null ? firstGame.createDate : null, filterDateFrom)
		Date lastDate = minDate(lastGame != null ? lastGame.createDate : new Date(), filterDateTo)
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

    private Game getFirstGame(SkatGroup group, Date filterDateFrom) {
        if (filterDateFrom != null && group != null) {
            return Game.find("from Game as g where g.group = ? and g.createDate >= ? ORDER BY createDate", [group, filterDateFrom])
        } else if (group != null) {
            return Game.find("from Game as g where g.group = ? ORDER BY createDate", [group])
        } else if (filterDateFrom != null) {
            return Game.find("from Game as g where g.createDate >= ? ORDER BY createDate", [filterDateFrom])
        } else {
            return Game.find("from Game ORDER BY createDate")
        }
    }

    private Game getLastGame(SkatGroup group, Date filterDateTo) {
        if (filterDateTo != null && group != null) {
            return Game.find("from Game as g where g.group = ? and g.createDate <= ? ORDER BY createDate desc", [group, filterDateTo])
        } else if (group != null) {
            return Game.find("from Game as g where g.group = ? ORDER BY createDate desc", [group])
        } else {
            return Game.find("from Game ORDER BY createDate desc ")
        }
    }

    private Object createSeries(Player p, Date startDate, int dayRange) {
        long day = 24 * 3600 * 1000
        return [
                player       : p,
                data         : [0, 0],
                pointStart   : startDate.time - (day * dayRange),
                pointInterval: day * dayRange
        ]
    }

    private Object getSeries(Player p, ArrayList chart) {
        for (Object series : chart) {
            if (series.player.equals(p)) {
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
