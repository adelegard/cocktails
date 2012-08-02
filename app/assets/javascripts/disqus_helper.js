//Initialize disqus global vars
var disqus_shortname = 'bombcocktails';
var disqus_identifier; //made of post id &nbsp; guid
var disqus_url; //post permalink
var disqus_developer = 1; // developer mode is on

if (typeof(Cocktails) === 'undefined') {
  Cocktails = {};
}

if (typeof(Cocktails.DisqusHelper) === 'undefined') {
  Cocktails.DisqusHelper = {

    load_disqus: function(source, identifier, url, callback) {
      $('#disqus_thread').remove();
      jQuery('<div id="disqus_thread"></div>').insertBefore(source);

      if (window.DISQUS) {
        //if Disqus exists, call it's reset method with new parameters
        DISQUS.reset({
          reload: true,
          config: function () {
            this.page.identifier = identifier;
            this.page.url = url;
            if (typeof(callback) !== 'undefined') callback();
          }
        });
      } else {
        disqus_identifier = identifier; //set the identifier argument
        disqus_url = url; //set the permalink argument

        //append the Disqus embed script to HTML
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        jQuery('head').append(dsq);

        if (typeof(callback) !== 'undefined') callback();
      }
    }
  }
}