// copied from http://stackoverflow.com/questions/1959455/how-to-store-an-array-in-jquery-cookie

//This is not production quality, its just demo code.
var cookieList = function(cookieName) {
  //When the cookie is saved the items will be a comma seperated string
  //So we will split the cookie by comma to get the original array
  var cookie = $.cookie(cookieName);
  //Load the items or a new array if null.
  var items = cookie ? cookie.split(/,/) : new Array();

  //Return a object that we can use to access the array.
  //while hiding direct access to the declared items array
  //this is called closures see http://www.jibbering.com/faq/faq_notes/closures.html
  return {
    "add": function(val) {
        //Add to the items.
        items.push(val);
        //Save the items to a cookie.
        //EDIT: Modified from linked answer by Nick see 
        //      http://stackoverflow.com/questions/3387251/how-to-store-array-in-jquery-cookie
        $.cookie(cookieName, items.join(','), { expires: 7, path: '/' });
    },
    "remove": function (val) { 
        //EDIT: Thx to Assef and luke for remove.
        indx = items.indexOf(val); 
        if(indx!=-1) items.splice(indx, 1); 
        $.cookie(cookieName, items.join(','), { expires: 7, path: '/' });
    },
    "clear": function() {
        items = null;
        //clear the cookie.
        $.cookie(cookieName, null, { expires: 7, path: '/' });
    },
    "items": function() {
        //Get all the items.
        return items;
    }
  }
}  