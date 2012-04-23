//= require jquery
$(document).ready(function() {
    var urlify = function(title) {
        return title.replace(/ /gi, '-').replace(';', '').replace('?', '').toLowerCase();
    };

    var list = $('aside.contents ul'),
        h2s = $('.post h2'),
        ln = h2s.length,
        canShow = false,
        i, h2, title, url;

    for (i = 1; i < ln; i++) {
        canShow = true;

        h2 = h2s[i];
        title = h2.innerHTML;
        url = urlify(title);
        h2.innerHTML = '<a name="' + url + '">' + title + '</a>';
        list.append('<li><a href="#' + url + '">' + title + '</a></li>');
    }

    var scrollTop = $(document).scrollTop();
    $(document).scroll(function(e) {
        scrollTop = $(document).scrollTop();

        if (scrollTop > 100 && canShow) {
            list.fadeIn();
            console.log('here');
        } else {
            list.fadeOut();
        }
    });
});
