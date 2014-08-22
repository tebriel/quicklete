(function() {
  var ModalInstanceCtrl, PPCtrl, app,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  app = angular.module('athletable', ['ngResource', 'ui.bootstrap']);

  ModalInstanceCtrl = (function() {
    function ModalInstanceCtrl($scope, $modalInstance, status) {
      this.$scope = $scope;
      this.$modalInstance = $modalInstance;
      this.cancel = __bind(this.cancel, this);
      this.ok = __bind(this.ok, this);
      this.$scope.status = status;
      this.$scope.ok = this.ok;
      this.$scope.cancel = this.cancel;
    }

    ModalInstanceCtrl.prototype.ok = function() {
      return this.$modalInstance.close();
    };

    ModalInstanceCtrl.prototype.cancel = function() {
      return this.$modalInstance.dismiss('cancel');
    };

    return ModalInstanceCtrl;

  })();

  PPCtrl = (function() {
    function PPCtrl($scope, $http, $log, $resource, $modal, ping_pong_id) {
      this.$scope = $scope;
      this.$http = $http;
      this.$log = $log;
      this.$resource = $resource;
      this.$modal = $modal;
      this.ping_pong_id = ping_pong_id;
      this.open = __bind(this.open, this);
      this.getSport = __bind(this.getSport, this);
      this.deleteLastSport = __bind(this.deleteLastSport, this);
      this.submit = __bind(this.submit, this);
      this.$scope.players = [];
      this.$scope.score = {};
      this.$scope.submit = this.submit;
      this.previousId = null;
      this.PingPong = this.$resource('/athletable/sports/:sportId.json', {
        sportId: '@id'
      });
      this.getSport();
      return;
    }

    PPCtrl.prototype.submit = function(score) {
      var result;
      result = {
        result: {
          scores_attributes: [
            {
              player_id: score.firstPlayer.id,
              score: score.firstScore
            }, {
              player_id: score.secondPlayer.id,
              score: score.secondScore
            }
          ]
        }
      };
      this.previousId = null;
      this.$http.post("/athletable/sports/" + this.ping_pong_id + "/results.json", result).error((function(_this) {
        return function(data, status) {
          _this.$log.log(data, status);
          return _this.open('lg', true);
        };
      })(this)).success((function(_this) {
        return function(data, status) {
          _this.previousId = data.id;
          _this.open();
          score.firstScore = 0;
          score.secondScore = 0;
        };
      })(this));
    };

    PPCtrl.prototype.deleteLastSport = function() {
      if (this.previousId == null) {
        return;
      }
      this.$http["delete"]("/athletable/sports/" + this.ping_pong_id + "/results/" + this.previousId + ".json").error((function(_this) {
        return function(data, status) {
          _this.$log.error(data, status);
        };
      })(this)).success((function(_this) {
        return function(data, status) {
          _this.$log.log(data, status, "deleted!");
        };
      })(this));
    };

    PPCtrl.prototype.getSport = function() {
      this.$scope.sport = this.PingPong.get({
        sportId: this.ping_pong_id
      }, (function(_this) {
        return function() {
          _this.$scope.sport.leaderboard.forEach(function(leader) {
            _this.$scope.players.push(leader.player);
          });
          _this.$scope.players = _.sortBy(_this.$scope.players, function(player) {
            return player.name;
          });
          _this.$scope.score.firstPlayer = _this.$scope.players[0];
          _this.$scope.score.secondPlayer = _this.$scope.players[1];
        };
      })(this));
    };

    PPCtrl.prototype.open = function(size, fail) {
      var confirm, dismiss, modalInstance, template;
      if (size == null) {
        size = 'lg';
      }
      if (fail == null) {
        fail = false;
      }
      template = '/templates/submissionComplete.html';
      if (fail) {
        template = '/templates/submissionFailed.html';
      }
      modalInstance = this.$modal.open({
        templateUrl: template,
        controller: ModalInstanceCtrl,
        size: size,
        resolve: {
          status: (function(_this) {
            return function() {
              var player;
              player = "NO ONE";
              if (_this.$scope.score.firstScore > _this.$scope.score.secondScore) {
                player = _this.$scope.score.firstPlayer;
              } else if (_this.$scope.score.secondScore > _this.$scope.score.firstScore) {
                player = _this.$scope.score.secondPlayer;
              }
              return {
                winner: player,
                fail: fail
              };
            };
          })(this)
        }
      });
      confirm = (function(_this) {
        return function() {
          return _this.$log.info("Modal confirmed at: " + (new Date()));
        };
      })(this);
      dismiss = (function(_this) {
        return function() {
          _this.$log.info("Modal dismissed at: " + (new Date()));
          return _this.deleteLastSport();
        };
      })(this);
      modalInstance.result.then(confirm, dismiss);
    };

    return PPCtrl;

  })();

  app.constant('ping_pong_id', 'c77da4728f').filter('withoutUser', function() {
    return function(users, without) {
      return _.without(users, without);
    };
  }).controller('ppCtrl', ['$scope', '$http', '$log', '$resource', '$modal', 'ping_pong_id', PPCtrl]);

}).call(this);
