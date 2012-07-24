//FB.init({appId: "225584237548089", status: true, cookie: true});

function fb_postToFeed(link, img_link, name) {

  // calling the API ...
  var obj = {
    method: 'feed',
    link: link,
    picture: 'http://fbrell.com/f8.jpg', /* replace with img_link once site is released */
    name: name,
    caption: 'Enter cocktail caption here!',
    description: 'Enter cocktail description here! Maybe the inspiration? Description? Ingredients?'
  };

  function callback(response) {
    //document.getElementById('msg').innerHTML = "Post ID: " + response['post_id'];
  }

  FB.ui(obj, callback);
}