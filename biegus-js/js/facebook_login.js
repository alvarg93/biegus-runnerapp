var appId = "JWpJYt1aejnTI3KRdinlEvoMd4GW1Ntgawgjpzyk";
var jsKey = "cIhobNrilTbLaM1iucB2S7FgO651HYLqDepW3zWT";
Parse.initialize(appId, jsKey);
window.fbAsyncInit = function() {
Parse.FacebookUtils.init({ // this line replaces FB.init({
  appId      : '397795367060088', // Facebook App ID
  status     : true,  // check Facebook Login status
  cookie     : true,  // enable cookies to allow Parse to access the session
  xfbml      : true,  // initialize Facebook social plugins on the page
  version    : 'v2.3' // point to the latest Facebook Graph API version
});

// Run code after the Facebook SDK is loaded.
};

(function(d, s, id){
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) {return;}
js = d.createElement(s); js.id = id;
js.src = "//connect.facebook.net/en_US/sdk.js";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));