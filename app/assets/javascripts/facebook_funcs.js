//FB.init({appId: "225584237548089", status: true, cookie: true});

function fb_postToFeed(link, img_link, name) {

  // calling the API ...
  var obj = {
    method: 'feed',
    link: 'https://developers.facebook.com/docs/reference/dialogs/',
    picture: 'http://fbrell.com/f8.jpg',
    name: 'Facebook Dialogs',
    caption: 'Reference Documentation',
    description: 'Using Dialogs to interact with users.'
  };

  function callback(response) {
    document.getElementById('msg').innerHTML = "Post ID: " + response['post_id'];
  }

  FB.ui(obj, callback);
}