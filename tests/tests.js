/* jshint jasmine: true */
/* global cordova */

exports.defineAutoTests = function () {

    var isIOS = cordova.platformId == 'ios';
    var isAndroid = cordova.platformId == 'android';


    var AppsFlyerError = {
        INVALID_ARGUMENTS_ERROR: "Invalid arguments",
        NO_DEVKEY_FOUND: "AppsFlyer 'devKey' is missing or empty",
        NO_APPID_FOUND: "Apple 'appId' is missing or empty",
        APPID_NOT_VALID: "'appId' is not valid",
        SUCCESS: "Success"
    };


    var fail = function (done) {
        expect(true).toBe(false);
        done();
    };

    describe("AppsFlyer", function () {

        it("appsflyer.spec.1 should exist", function () {
            expect(window.plugins.appsFlyer).toBeDefined();
        });

        it("appsFlyer.initSdk method", function () {
            expect(window.plugins.appsFlyer.initSdk).toBeDefined();
            expect(typeof window.plugins.appsFlyer.initSdk).toBe('function');
        });

        it("appsFlyer.setCurrencyCode method", function () {
            expect(window.plugins.appsFlyer.setCurrencyCode).toBeDefined();
            expect(typeof window.plugins.appsFlyer.setCurrencyCode).toBe('function');
        });

        it("appsFlyer.setAppUserId method", function () {
            expect(window.plugins.appsFlyer.setAppUserId).toBeDefined();
            expect(typeof window.plugins.appsFlyer.setAppUserId).toBe('function');
        });

        it("appsFlyer.setGCMProjectID method", function () {
            expect(window.plugins.appsFlyer.setGCMProjectID).toBeDefined();
            expect(typeof window.plugins.appsFlyer.setGCMProjectID).toBe('function');
        });

        it("appsFlyer.enableUninstallTracking method", function () {        
            expect(window.plugins.appsFlyer.enableUninstallTracking).toBeDefined();
            expect(typeof window.plugins.appsFlyer.enableUninstallTracking).toBe('function');
        });

        it("appsFlyer.registerUninstall method", function () {
            expect(window.plugins.appsFlyer.registerUninstall).toBeDefined();
            expect(typeof window.plugins.appsFlyer.registerUninstall).toBe('function');
        });

        it("appsFlyer.getAppsFlyerUID method", function () {
            expect(window.plugins.appsFlyer.getAppsFlyerUID).toBeDefined();
            expect(typeof window.plugins.appsFlyer.getAppsFlyerUID).toBe('function');
        });

        it("appsFlyer.trackEvent method", function () {
            expect(window.plugins.appsFlyer.trackEvent).toBeDefined();
            expect(typeof window.plugins.appsFlyer.trackEvent).toBe('function');
        });

    });

    describe("AppsFlyer -> initSdk", function () {

        /* ##################   SUCCESS testing   ################################ */
        var DEV_KEY = 'd3Ac9qPnrpXYZxfWmCdpwL';

        it("appsflyer.spec.2 success callback devKey is defined", function (done) {

            //ios uses appId, this test will fail
            if (isIOS) {
                pending();
                return;
            }

            function successCB(result) {
                expect(result).toBeDefined();
                expect(typeof result === "string").toBe(true);
                expect(result).toBe(AppsFlyerError.SUCCESS);
                done();
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                expect(typeof err === "string").toBe(true);
                fail(done);
            }

            var options = {
                devKey: DEV_KEY
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });


        it("appsflyer.spec.2 success callback devKey | AppId | isDebug is defined", function (done) {

            function successCB(result) {
                expect(result).toBeDefined();
                expect(typeof result === "string").toBe(true);
                expect(result).toBe(AppsFlyerError.SUCCESS);
                done();
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                fail(done);
            }

            var options = {
                devKey: DEV_KEY,
                appId: '123456789',
                isDebug: false
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });

        it("appsflyer.spec.2 success callback devKey and AppId is defined", function (done) {

            function successCB(result) {
                expect(result).toBeDefined();
                expect(typeof result === "string").toBe(true);
                expect(result).toBe(AppsFlyerError.SUCCESS);
                done();
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                fail(done);
            }

            var options = {
                devKey: DEV_KEY,
                appId: '123456789'
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });

        /* ##################   ERROR testing   ################################ */

        it("appsflyer.spec.2 error callback devKey is undefined", function (done) {
            function successCB() {
                fail(done);
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                expect(typeof err === "string").toBe(true);
                expect(err).toBe(AppsFlyerError.NO_DEVKEY_FOUND);
                done();
            }

            var options = {};
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });


        it("appsflyer.spec.2 error callback appId is undefined", function (done) {

            if (isAndroid) {
                pending();
                return;
            }

            function successCB() {
                fail(done);
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                expect(typeof err === "string").toBe(true);
                expect(err).toBe(AppsFlyerError.NO_APPID_FOUND);
                done();
            }

            var options = {
                devKey: DEV_KEY
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });

        it("appsflyer.spec.2 error callback appId defined as Integer", function (done) {

            if (isAndroid) {
                pending();
                return;
            }

            function successCB() {
                fail(done);
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                expect(typeof err === "string").toBe(true);
                expect(err).toBe(AppsFlyerError.APPID_NOT_VALID);
                done();
            }

            var options = {
                devKey: DEV_KEY,
                appId: 123456789
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });

        it("appsflyer.spec.2 error callback devKey is Empty", function (done) {

            function successCB() {
                fail(done);
            }

            function errorCB(err) {
                expect(err).toBeDefined();
                expect(typeof err === "string").toBe(true);
                expect(err).toBe(AppsFlyerError.NO_DEVKEY_FOUND);
                done();
            }

            var options = {
                devKey: '',
                appId: '123456789'
            };
            window.plugins.appsFlyer.initSdk(options, successCB, errorCB);
        });
    });

};

exports.defineManualTests = function (contentEl, createActionButton) {};
