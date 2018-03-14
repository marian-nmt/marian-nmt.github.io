;(function( $ ){
    "use strict";

    $.fn.ToC = function( options ) {

        var toc = $.extend({
            heading         : 'h3',
            appendTo        : this,
            topElement      : 'H2',
            menuAttrib      : 'id="doc-menu" class="nav doc-menu" data-spy="affix"',
            submenuAttrib   : 'class="nav doc-sub-menu"'
        }, options);

        return this.each(function() {
            var $this = $(this);

            var nav = $('<ul ' + toc.menuAttrib + '>');
            var submenu = false;

            $this.find( toc.heading ).each(function(i) {
                var id = this.id;
                var txt = this.textContent.replace(/[.:;-]+$/, '')
                var li = $('<li>').append(
                            $('<a class="scrollto">')
                                .attr( 'href', '#' + id )
                                .text( txt )
                            )

                if (this.nodeName == toc.topElement) {
                    nav.append( li );
                    submenu = false;
                }
                else {
                    if (! submenu) {
                        nav.find('li').last()
                            .append( $('<ul ' + toc.submenuAttrib + '>') );
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

$('.content-inner').ToC({
    heading         : 'h3,h4',
    appendTo        : '#faq-nav',
    topElement      : 'H3',
    menuAttrib      : 'id="faq-menu"',
    submenuAttrib   : 'class="faq-sub-menu"'
});
