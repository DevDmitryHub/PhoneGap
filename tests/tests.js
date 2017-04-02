/* jshint jasmine: true */

exports.defineAutoTests = function () {
  describe("AppsFlyer", function () {

    it("appsflyer.spec.1 should exist", function() {
        expect(window.plugins.appsFlyer).toBeDefined();
    });
   

    it("appsFlyer.initSdk method", function(){        
        expect(window.plugins.appsFlyer.initSdk).toBeDefined();
        expect(typeof window.plugins.appsFlyer.initSdk).toBe('function');    
    });

    it("appsFlyer.setCurrencyCode method", function(){        
       expect(window.plugins.appsFlyer.setCurrencyCode).toBeDefined();
        expect(typeof window.plugins.appsFlyer.setCurrencyCode).toBe('function');
    });

    it("appsFlyer.setAppUserId method", function(){        
        expect(window.plugins.appsFlyer.setAppUserId).toBeDefined();
        expect(typeof window.plugins.appsFlyer.setAppUserId).toBe('function'); 
    });

    it("appsFlyer.setGCMProjectID method", function(){        
         expect(window.plugins.appsFlyer.setGCMProjectID).toBeDefined();
        expect(typeof window.plugins.appsFlyer.setGCMProjectID).toBe('function');  
    });

    it("appsFlyer.registerUninstall method", function(){        
         expect(window.plugins.appsFlyer.registerUninstall).toBeDefined();
        expect(typeof window.plugins.appsFlyer.registerUninstall).toBe('function');
    });

    it("appsFlyer.getAppsFlyerUID method", function(){        
       expect(window.plugins.appsFlyer.getAppsFlyerUID).toBeDefined();
        expect(typeof window.plugins.appsFlyer.getAppsFlyerUID).toBe('function');
    });

    it("appsFlyer.trackEvent method", function(){        
        expect(window.plugins.appsFlyer.trackEvent).toBeDefined();
        expect(typeof window.plugins.appsFlyer.trackEvent).toBe('function');   
    });

    it("appsFlyer.onInstallConversionDataLoaded method", function(){        
       expect(window.plugins.appsFlyer.onInstallConversionDataLoaded).toBeDefined();
        expect(typeof window.plugins.appsFlyer.onInstallConversionDataLoaded).toBe('function');     
    });

  });
};

exports.defineManualTests = function (contentEl, createActionButton) {};