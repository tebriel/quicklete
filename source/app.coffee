app = angular.module 'athletable', ['ngResource', 'ui.bootstrap', 'LocalStorageModule']

class ModalInstanceCtrl
    constructor: (@$scope, @$modalInstance, status) ->
        @$scope.status = status
        @$scope.ok = @ok
        @$scope.cancel = @cancel

    ok: =>
        @$modalInstance.close()

    cancel: =>
        @$modalInstance.dismiss 'cancel'

class PPCtrl
    constructor: (@$scope, @$http, @$log, @$resource, @localStorageService, @$modal) ->
        @$scope.players = []
        @$scope.score = {}
        @$scope.submit = @submit
        @previousId = null

        @PingPong = @$resource('/athletable/sports/:sportId.json', {sportId:'@id'})
        @getSport()


        return

    submit: (score) =>
        result =
            result:
                scores_attributes: [
                    { player_id: score.firstPlayer.id, score: score.firstScore }
                    { player_id: score.secondPlayer.id, score: score.secondScore }
                ]

        @localStorageService.set 'firstPlayerId', score.firstPlayer.id
        @localStorageService.set 'secondPlayerId', score.secondPlayer.id

        @previousId = null
        @$http.post "/athletable/sports/PING_PONG/results.json", result
            .error (data, status) =>
                @$log.log data, status
                @open 'lg', true
            .success (data, status) =>
                @previousId = data.id
                @open()
                score.firstScore = 0
                score.secondScore = 0

                return

        return

    deleteLastSport: =>
        return unless @previousId?

        @$http.delete "/athletable/sports/PING_PONG/results/#{@previousId}.json"
            .error (data, status) =>
                @$log.error data, status
                return

            .success (data, status) =>
                @$log.log data, status, "deleted!"
                return

        return

    setPlayers: ->
        firstId = @localStorageService.get 'firstPlayerId'
        secondId = @localStorageService.get 'secondPlayerId'
        unless firstId? and secondId?
            @$scope.score.firstPlayer = @$scope.players[0]
            @$scope.score.secondPlayer = @$scope.players[1]
            return

        firstId = parseInt firstId
        secondId = parseInt secondId
        for player in @$scope.players
            if player.id is firstId
                @$scope.score.firstPlayer = player
            else if player.id is secondId
                @$scope.score.secondPlayer = player

        return


    getSport: =>
        @$scope.sport = @PingPong.get {sportId:'PING_PONG'}, =>
            @$scope.sport.leaderboard.forEach (leader) =>
                @$scope.players.push leader.player

                return

            @$scope.players = _.sortBy @$scope.players, (player) ->
                return player.name

            @setPlayers()

            for player in @$scope.players
                unless /^https:\/\//.test player.photo_url
                    player.photo_url = "#{player.photo_url}"

            return

        return

    open: (size='lg', fail=false) =>
        template = '/templates/submissionComplete.html'
        template = '/templates/submissionFailed.html' if fail
        modalInstance = @$modal.open
            templateUrl: template
            controller: ModalInstanceCtrl
            size: size
            resolve:
                status: =>
                    player = "NO ONE"
                    if @$scope.score.firstScore > @$scope.score.secondScore
                        player = @$scope.score.firstPlayer
                    else if @$scope.score.secondScore > @$scope.score.firstScore
                        player = @$scope.score.secondPlayer

                    return { winner: player, fail }

        confirm = =>
            @$log.info "Modal confirmed at: #{new Date()}"

        dismiss = =>
            @$log.info "Modal dismissed at: #{new Date()}"
            @deleteLastSport()

        modalInstance.result.then confirm, dismiss

        return

app.filter 'withoutUser', ->
        return (users, without) ->
            return _.without(users, without)
    .controller 'ppCtrl', [
        '$scope'
        '$http'
        '$log'
        '$resource'
        'localStorageService'
        '$modal'
        PPCtrl
    ]
