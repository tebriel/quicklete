describe "App Test", ->
    beforeEach module 'athletable'
    beforeEach inject (@$controller, @$rootScope) ->
        @$scope = @$rootScope.$new()
        @ppCtrl = @$controller 'ppCtrl', {@$scope}

    describe "PPCtrl", ->
        it "Creates a PPCtrl", ->
            expect(@ppCtrl).toBeDefined()
