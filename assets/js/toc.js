;(function( $ ){
    "use strict";

    $.fn.ToC = function( options ) {

        var toc = $.extend({
            heading         : 'h3',
            appendTo        : this
        }, options);

        return this.each(function() {
            var $this = $(this);

            var nav = $('<ul id="doc-menu" class="nav doc-menu" data-spy="affix">');
            var submenu = false;

            $this.find( toc.heading ).each(function(i) {
                var id = this.id;
                var li = $('<li>').append(
                            $('<a class="scrollto">')
                                .attr( 'href', '#' + id )
                                .text( this.innerHTML )
                            )

                if (this.nodeName == "H2") {
                    nav.append( li );
                    submenu = false;
                }
                else {
                    if (! submenu) {
                        nav.find('li:last-child')
                            .append( $('<ul class="nav doc-sub-menu">') )
                    }
                    nav.find('li:last-child > ul').append( li );
                    submenu = true;
                }
            });

            $(toc.appendTo).prepend( nav );
        });

    };
})( jQuery );

$('.content-inner').ToC({
    heading         : 'h2,h3',
    appendTo        : '#doc-nav'
});
